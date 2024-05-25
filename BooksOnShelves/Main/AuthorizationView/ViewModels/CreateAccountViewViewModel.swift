import Foundation
import FirebaseAuth
import FirebaseFirestore

class CreateAccountViewViewModel: ObservableObject{
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var nickname: String = ""
    
    init() {}
    
    func createAcc() {
        guard validate() else {
            return
        }
        
        checkUserExists(email: email) { [weak self] exists in
            guard !exists else {
                self?.errorMessage = "A user with this email already exists."
                return
            }
            
            self?.checkNicknameUnique(nickname: self?.nickname ?? "") { [weak self] unique in
                guard unique else {
                    self?.errorMessage = "This nickname is already taken."
                    return
                }
                
                Auth.auth().createUser(withEmail: self?.email ?? "", password: self?.password ?? "") { result, error in
                    guard let userId = result?.user.uid else {
                        self?.errorMessage = "Failed to create user."
                        return
                    }
                    
                    self?.insertUserRecord(id: userId)
                }
            }
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id, name: name, email: email, nickname: nickname, joined: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        if name.trimmingCharacters(in: .whitespaces).isEmpty ||
           email.trimmingCharacters(in: .whitespaces).isEmpty ||
           password.trimmingCharacters(in: .whitespaces).isEmpty ||
           nickname.trimmingCharacters(in: .whitespaces).isEmpty {
            
            errorMessage = "Fill in all fields"
            return false
        }
        
        if !email.contains("@") || !email.contains(".") {
            errorMessage = "Enter valid email"
            return false
        }
        
        if password.count < 6 {
            errorMessage = "Password must contain at least 6 symbols"
            return false
        }
        
        return true
    }
    
    private func checkUserExists(email: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error checking if user exists: \(error)")
                completion(false)
            } else {
                completion(querySnapshot?.documents.count ?? 0 > 0)
            }
        }
    }
    
    private func checkNicknameUnique(nickname: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").whereField("nickname", isEqualTo: nickname).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error checking if nickname is unique: \(error)")
                completion(false)
            } else {
                completion(querySnapshot?.documents.count ?? 0 == 0)
            }
        }
    }
}
