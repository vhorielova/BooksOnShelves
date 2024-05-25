import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewBookViewViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var rate: String = ""
    @Published var notes: [String] = [""]
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

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
        let newItem = Book(id: newId, title: title, author: author, rate: rateInt)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("books")
            .document(newId)
            .setData(newItem.asDictionary())
        
        print("Called")
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
