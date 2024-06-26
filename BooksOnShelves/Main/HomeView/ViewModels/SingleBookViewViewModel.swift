import Foundation
import FirebaseFirestore
import FirebaseStorage

class SingleBookViewModel: ObservableObject {
    @Published var book: Book
    var userId: String
    @Published var quotes: [Quote] = []
    @Published var isLoading: Bool = true

    init(book: Book, userId: String) {
        self.book = book
        self.userId = userId
        self.loadQuotes()
    }

    func loadQuotes() {
        let db = Firestore.firestore()
        db.collection("users")
            .document(self.userId)
            .collection("books")
            .document(self.book.id)
            .collection("quotes")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error loading quotes: \(error.localizedDescription)")
                } else {
                    self.quotes = snapshot?.documents.compactMap { document in
                        try? document.data(as: Quote.self)
                    } ?? []
                }
                self.isLoading = false
            }
    }

    func deleteBook() {
        let db = Firestore.firestore()
        let storage = Storage.storage()

        if let imageUrl = self.book.imageUrl, !imageUrl.isEmpty {
            let imageRef = storage.reference(forURL: imageUrl)
            imageRef.delete { error in
                if let error = error {
                    print("Error deleting image from storage: \(error.localizedDescription)")
                } else {
                    print("Image successfully deleted from storage.")
                }
                self.deleteBookDocument(db: db)
            }
        } else {
            self.deleteBookDocument(db: db)
        }
    }

    private func deleteBookDocument(db: Firestore) {
        db.collection("users")
            .document(self.userId)
            .collection("books")
            .document(self.book.id)
            .delete { error in
                if let error = error {
                    print("Error deleting document from Firestore: \(error.localizedDescription)")
                } else {
                    print("Successfully removed from Firestore")
                }
            }
    }
}
