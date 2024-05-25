import Foundation
import FirebaseFirestore

class SearchUserViewViewModel: ObservableObject {
    @Published var foundUser: User? = nil
    
    func searchUser(by nickname: String) {
        let db = Firestore.firestore()
        
        db.collection("users").whereField("nickname", isEqualTo: nickname).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                return
            }
            
            if let data = documents.first?.data() {
                DispatchQueue.main.async {
                    self.foundUser = User(
                        id: data["id"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        nickname: data["nickname"] as? String ?? "",
                        joined: data["joined"] as? TimeInterval ?? 0
                    )
                }
            } else {
                DispatchQueue.main.async {
                    self.foundUser = nil
                }
            }
        }
    }
}
