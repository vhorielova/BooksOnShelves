import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ProfileViewViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isCurrentUser: Bool = false
    @Published var downloadedImage: UIImage?
    
    func fetchUser(userId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        isCurrentUser = (userId == currentUserId)
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    nickname: data["nickname"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0, 
                    imageUrl: data["imageUrl"] as? String ?? ""
                )
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }

    func fetchImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Failed to download image: \(error)")
            } else if let data = data {
                DispatchQueue.main.async {
                    self.downloadedImage = UIImage(data: data)
                }
            }
        }
    }
}
