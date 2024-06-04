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

    var userId: String
    var bookId: String

    init(userId: String, bookId: String) {
        self.userId = userId
        self.bookId = bookId
        fetchBook()
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
                        print("Book successfully updated")
                        self.successMessage = "Book details saved successfully!"
                    }
                }
            }
        } else {
            bookRef.updateData(updatedData) { error in
                if let error = error {
                    print("Error updating book: \(error)")
                    self.successMessage = "Failed to save book details: \(error.localizedDescription)"
                } else {
                    print("Book successfully updated")
                    self.successMessage = "Book details saved successfully!"
                }
            }
        }
    }

    private func fetchImage(from url: String) {
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Failed to download image: \(error)")
            } else if let data = data {
                DispatchQueue.main.async {
                    self.downloadedImage = UIImage(data: data)
                }
            }
        }
    }

    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference().child("book_covers/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
            } else {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                        completion(nil)
                    } else {
                        completion(url?.absoluteString)
                    }
                }
            }
        }
    }
}
