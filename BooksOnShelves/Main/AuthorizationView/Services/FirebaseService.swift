import FirebaseAuth
import FirebaseFirestore

class FirebaseService {
    static let shared = FirebaseService()
    
    private init() {}
    
    func signIn(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }
            
            self.fetchUserDetails(uid: firebaseUser.uid, completion: completion)
        }
    }
    
    private func fetchUserDetails(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data(),
                  let name = data["name"] as? String,
                  let email = data["email"] as? String,
                  let nickname = data["nickname"] as? String,
                  let joined = data["joined"] as? TimeInterval else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data not found or malformed"])))
                return
            }
            
            let user = User(id: uid, name: name, email: email, nickname: nickname, joined: joined)
            completion(.success(user))
        }
    }
    
    func checkIfUserExists(email: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { querySnapshot, error in
            if let _ = error {
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
