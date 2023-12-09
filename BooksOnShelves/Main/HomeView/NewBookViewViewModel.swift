import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewBookViewViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var rate: String = ""
    @Published var notes: [String] = [""]
    @Published var showAlert: Bool = false
    
    init() {}
    
    func save() {
        
        if(!canSave){
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else{
            return
        }
        
        let newId = UUID().uuidString
        let newItem = Book(id: newId, title: title, author: author, rate: rate)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("books")
            .document(newId)
            .setData(newItem.asDictionary())
        
        print("Called")
    }
    
    var canSave: Bool {
        if(title.trimmingCharacters(in: .whitespaces).isEmpty){
            return false
        }
        
        return true
    }
}
