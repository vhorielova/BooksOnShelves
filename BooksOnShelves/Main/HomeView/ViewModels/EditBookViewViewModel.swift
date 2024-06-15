import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class EditBookViewViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var rate: Int = 0
    @Published var description: String = ""
    @Published var note: String = ""
    @Published var downloadedImage: UIImage?
    @Published var image: UIImage?
    @Published var successMessage: String?
    @Published var quotes: [Quote] = []
    @Published var newQuote: String = ""
    @Published var textImage: UIImage? = nil

    var userId: String
    var bookId: String

    init(userId: String, bookId: String) {
        self.userId = userId
        self.bookId = bookId
        fetchBook()
        fetchQuotes()
    }

    private func fetchBook() {
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("books").document(bookId).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }

            DispatchQueue.main.async {
                self.title = data["title"] as? String ?? ""
                self.author = data["author"] as? String ?? ""
                self.rate = data["rate"] as? Int ?? 0
                if let imageUrl = data["imageUrl"] as? String, !imageUrl.isEmpty {
                    self.fetchImage(from: imageUrl)
                }
                self.description = data["description"] as? String ?? ""
                self.note = data["note"] as? String ?? ""
            }
        }
    }

    private func fetchQuotes() {
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("books").document(bookId).collection("quotes").getDocuments { snapshot, error in
            if let error = error {
                print("Error loading quotes: \(error.localizedDescription)")
            } else {
                self.quotes = snapshot?.documents.compactMap { document in
                    try? document.data(as: Quote.self)
                } ?? []
            }
        }
    }

    func updateBook() {
        let db = Firestore.firestore()
        let bookRef = db.collection("users").document(userId).collection("books").document(bookId)

        var updatedData: [String: Any] = [
            "title": title,
            "author": author,
            "rate": rate,
            "description": description,
            "note": note
        ]

        if let image = image {
            uploadImage(image) { imageUrl in
                if let imageUrl = imageUrl {
                    updatedData["imageUrl"] = imageUrl
                }

                bookRef.updateData(updatedData) { error in
                    if let error = error {
                        print("Error updating book: \(error)")
                        self.successMessage = "Failed to save book details: \(error.localizedDescription)"
                    } else {
                        self.successMessage = "Book details updated successfully."
                    }
                }
            }
        } else {
            bookRef.updateData(updatedData) { error in
                if let error = error {
                    print("Error updating book: \(error)")
                    self.successMessage = "Failed to save book details: \(error.localizedDescription)"
                } else {
                    self.successMessage = "Book details updated successfully."
                }
            }
        }
    }

    private func fetchImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                self.downloadedImage = image
            }
        }.resume()
    }

    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference().child("book_images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard error == nil else {
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in
                completion(url?.absoluteString)
            }
        }
    }

    func addQuote() {
        guard !newQuote.isEmpty else {
            return
        }

        let db = Firestore.firestore()
        let quoteRef = db.collection("users").document(userId).collection("books").document(bookId).collection("quotes").document()
        let quote = Quote(id: quoteRef.documentID, quote: newQuote)
        
        do {
            try quoteRef.setData(from: quote)
            quotes.append(quote)
            newQuote = ""
        } catch {
            print("Error adding quote: \(error)")
        }
    }

    func deleteQuote(_ quote: Quote) {
        let db = Firestore.firestore()
        let quoteRef = db.collection("users").document(userId).collection("books").document(bookId).collection("quotes").document(quote.id)
        
        quoteRef.delete { error in
            if let error = error {
                print("Error deleting quote: \(error)")
            } else {
                if let index = self.quotes.firstIndex(where: { $0.id == quote.id }) {
                    self.quotes.remove(at: index)
                }
            }
        }
    }

    func appendDescription(with text: String?) {
        if let text = text {
            description.append(text)
        }
    }

    func appendQuote(at index: Int, with text: String?) {
        if let text = text, index < quotes.count {
            quotes[index].quote.append(text)
        }
    }
}
