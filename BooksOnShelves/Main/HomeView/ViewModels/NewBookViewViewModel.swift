import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class NewBookViewViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var rate: String = ""
    @Published var notes: [String] = [""]
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var selectedImage: UIImage? = nil
    @Published var isUploading: Bool = false

    init() {}

    func save() {
        if !canSave {
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
        
        let newId = UUID().uuidString
        if let image = selectedImage {
            uploadImage(image) { [weak self] url in
                guard let self = self, let url = url else {
                    self?.errorMessage = "Failed to upload image."
                    self?.showAlert = true
                    return
                }

                let newItem = Book(id: newId, title: self.title, author: self.author, rate: rateInt, imageUrl: url.absoluteString)
                self.saveBook(newItem, userId: userId)
            }
        } else {
            let newItem = Book(id: newId, title: title, author: author, rate: rateInt, imageUrl: nil)
            saveBook(newItem, userId: userId)
        }
    }

    private func saveBook(_ book: Book, userId: String) {
        let db = Firestore.firestore()
        db.collection("users")
            .document(userId)
            .collection("books")
            .document(book.id)
            .setData(book.asDictionary())
        
        print("Book saved")
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
