import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    
    private var db = Firestore.firestore()
    
    init() {}
    
    func login() {
        guard validate() else {
            return
        }
        
        checkIfUserExists { [weak self] exists in
            guard let self = self else { return }
            
            if !exists {
                self.errorMessage = "User with this email does not exist"
                return
            }
            
            Auth.auth().signIn(withEmail: self.email, password: self.password) { result, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                } else {
                    self.errorMessage = ""
                }
            }
        }
    }
    
    private func isSignedIn() -> Bool {
        if Auth.auth().currentUser == nil {
            errorMessage = "Wrong email or password"
            return false
        }
        
        return true
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty || password.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Fill in all fields"
            return false
        }
        
        if !email.contains("@") || !email.contains(".") {
            errorMessage = "Enter valid email"
            return false
        }
        
        return true
    }
    
    private func checkIfUserExists(completion: @escaping (Bool) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { querySnapshot, error in
            if let error = error {
                self.errorMessage = "Failed to check user: \(error.localizedDescription)"
                completion(false)
                return
            }
            
            if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
