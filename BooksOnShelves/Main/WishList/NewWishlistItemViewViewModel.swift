import Foundation
import FirebaseAuth
import FirebaseFirestore

class NewWishlistItemViewViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var dueDate = Date()
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
        let newItem = WishlistItem(id: newId, title: title, dueDate: dueDate.timeIntervalSince1970, createdDate: Date().timeIntervalSince1970, isDone: false)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("wishlist")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    var canSave: Bool {
        if(title.trimmingCharacters(in: .whitespaces).isEmpty){
            return false
        }
        
        return true
    }
}
