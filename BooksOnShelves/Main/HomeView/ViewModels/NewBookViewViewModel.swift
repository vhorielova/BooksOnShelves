import Foundation
import FirebaseStorage
import FirebaseAuth
import SwiftUI
import FirebaseFirestore

class NewBookViewViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var rate: String = ""
    @Published var description: String = ""
    @Published var note: String = ""
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var selectedImage: UIImage? = nil
    @Published var textImage: UIImage? = nil
    @Published var isUploading: Bool = false
    @Published var quotes: [Quote] = []
    
    init() {}

    func addQuote() {
        let newQuote = Quote(id: UUID().uuidString, quote: "")
        quotes.append(newQuote)
    }

    func save() {
        if !canSave {
            showAlert = true
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        guard let rateInt = Int(rate) else {
            errorMessage = "Rate must be a number between 1 and 10."
            showAlert = true
            return
        }
        
        if let image = selectedImage {
            uploadImage(image) { [weak self] url in
                guard let self = self else { return }
                guard let url = url else {
                    self.errorMessage = "Failed to upload image."
                    self.showAlert = true
                    return
                }

                let newItem = BookBuilder()
                    .setId(UUID().uuidString)
                    .setTitle(self.title)
                    .setAuthor(self.author)
                    .setRate(rateInt)
                    .setImageUrl(url.absoluteString)
                    .setDescription(self.description)
                    .setNote(self.note)
                    .build()

                self.saveBook(newItem, userId: userId)
            }
        } else {
            let newItem = BookBuilder()
                .setId(UUID().uuidString)
                .setTitle(title)
                .setAuthor(author)
                .setRate(rateInt)
                .setDescription(self.description)
                .setNote(self.note)
                .build()

            saveBook(newItem, userId: userId)
        }
    }

    private func saveBook(_ book: Book, userId: String) {
        let db = Firestore.firestore()
        let bookRef = db.collection("users")
            .document(userId)
            .collection("books")
            .document(book.id)
        
        bookRef.setData(book.asDictionary()) { error in
            if let error = error {
                self.errorMessage = "Failed to save book: \(error.localizedDescription)"
                self.showAlert = true
            } else {
                print("Book saved")
                self.saveQuotes(bookId: book.id, userId: userId)
            }
        }
    }

    private func saveQuotes(bookId: String, userId: String) {
        let db = Firestore.firestore()
        let quotesCollectionRef = db.collection("users")
            .document(userId)
            .collection("books")
            .document(bookId)
            .collection("quotes")
        
        let nonEmptyQuotes = quotes.filter { !$0.quote.trimmingCharacters(in: .whitespaces).isEmpty }
        
        for quote in nonEmptyQuotes {
            quotesCollectionRef.document(quote.id).setData(quote.asDictionary()) { error in
                if let error = error {
                    self.errorMessage = "Failed to save quote: \(error.localizedDescription)"
                    self.showAlert = true
                } else {
                    print("Quote saved")
                }
            }
        }
    }

    private func uploadImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference().child("book_images/\(UUID().uuidString).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        isUploading = true
        storageRef.putData(imageData, metadata: metadata) { _, error in
            self.isUploading = false
            if let error = error {
                print("Failed to upload image: \(error.localizedDescription)")
                completion(nil)
            } else {
                storageRef.downloadURL { url, _ in
                    completion(url)
                }
            }
        }
    }
    
    func appendDescription(with text: String?) {
        if let text = text {
            description += "\n" + text
        }
    }
    
    func appendQuote(at index: Int, with text: String) {
        guard index < quotes.count else { return }
        quotes[index].quote += " " + text
    }
    
    var canSave: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Title cannot be empty."
            return false
        }
        
        guard let rateNumber = Int(rate), rateNumber >= 1, rateNumber <= 10 else {
            errorMessage = "Rate must be a number between 1 and 10."
            return false
        }
        
        return true
    }
}
