import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    
    func login() {
        guard validate() else {
            return
        }
        
        FirebaseService.shared.checkIfUserExists(email: email) { [weak self] exists in
            guard let self = self else { return }
            
            if !exists {
                self.errorMessage = "User with this email does not exist"
                return
            }
            
            FirebaseService.shared.signIn(withEmail: self.email, password: self.password) { result in
                switch result {
                case .success(let user):
                    self.errorMessage = ""
                    print("User signed in: \(user)")
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
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
}
