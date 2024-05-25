import Foundation
import FirebaseAuth
import FirebaseFirestore

class TextFieldMaxLength: ObservableObject{
    var characterLimit: Int = 100
    
    init(characterLimit: Int, input: String) {
        self.characterLimit = characterLimit
        self.input = input
    }
    
    @Published var input: String = "" {
        didSet{
            if(input.count > characterLimit){
                input = String(input.prefix(characterLimit))
            }
        }
    }
}

class NewWishlistItemViewViewModel: ObservableObject {
    @Published var title = TextFieldMaxLength(characterLimit: 150, input: "")
    @Published var author = TextFieldMaxLength(characterLimit: 150, input: "")
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
        let newItem = WishlistItem(id: newId, title: title.input, author: author.input, createdDate: Date().timeIntervalSince1970, isDone: false)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(userId)
            .collection("wishlist")
            .document(newId)
            .setData(newItem.asDictionary())
    }
    
    var canSave: Bool {
        if(title.input.trimmingCharacters(in: .whitespaces).isEmpty || author.input.trimmingCharacters(in: .whitespaces).isEmpty){
            return false
        }
        
        return true
    }
}
