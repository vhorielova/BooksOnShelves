import Foundation
import FirebaseAuth
import FirebaseFirestore

class WishListItemViewViewModel: ObservableObject {
    init() {}
    
    func toggleIsDone(item: WishlistItem) {
        var newitem = item
        newitem.setDone(!item.isDone)
        
        guard let userId = Auth.auth().currentUser?.uid else{
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("wishlist")
            .document(newitem.id)
            .setData(newitem.asDictionary())
    }
}
