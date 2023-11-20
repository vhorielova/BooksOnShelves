import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewViewModel: ObservableObject{
    @Published var email:String = ""
    @Published var password:String = ""
    @Published var errorMessage:String = ""
    
    init() {}
    
    func login() {
        guard validate() else{
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        if email.trimmingCharacters(in: .whitespaces).isEmpty, password.trimmingCharacters(in: .whitespaces).isEmpty {
            
            errorMessage = "Fill in all fields"
            return false
        }
        
        if !email.contains("@") && !email.contains("."){
            
            errorMessage = "Enter valid email"
            return false
        }

        let db = Firestore.firestore()
        
        
        return true
    }
}
