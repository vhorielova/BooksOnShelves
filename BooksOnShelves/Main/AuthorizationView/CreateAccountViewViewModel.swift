import Foundation
import FirebaseAuth
import FirebaseFirestore

class CreateAccountViewViewModel: ObservableObject{
    @Published var name:String = ""
    @Published var email:String = ""
    @Published var password:String = ""
    @Published var errorMessage:String = ""
    
    init() {}
    
    func createAcc() {
        guard validate() else{
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in guard let userId = result?.user.uid else{
                return
            }
            
            self?.insertUserRecord(id: userId)
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id, name: name, email: email, joined: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        if name.trimmingCharacters(in: .whitespaces).isEmpty ||
           email.trimmingCharacters(in: .whitespaces).isEmpty ||
           password.trimmingCharacters(in: .whitespaces).isEmpty {
            
            errorMessage = "Fill in all fields"
            return false
        }
        
        if !email.contains("@") || !email.contains("."){
            
            errorMessage = "Enter valid email"
            return false
        }
        
        if password.count < 6{
            errorMessage = "Password must contains at least 6 symbols"
            return false
        }
        
        return true
        
    }
}
