import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class CreateAccountViewViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var nickname: String = ""
    @Published var selectedImage: UIImage? = nil
    
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
                    
                    self?.uploadProfileImage(userId: userId)
                }
            }
        }
    }
    
    private func uploadProfileImage(userId: String) {
        guard let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.75) else {
            insertUserRecord(id: userId, imageUrl: "")
            return
        }
        
        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")
        storageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            guard error == nil else {
                print("Failed to upload image: \(error!.localizedDescription)")
                self?.insertUserRecord(id: userId, imageUrl: "")
                return
            }
            
            storageRef.downloadURL { [weak self] url, error in
                guard let downloadUrl = url else {
                    print("Failed to get download URL: \(error!.localizedDescription)")
                    self?.insertUserRecord(id: userId, imageUrl: "")
                    return
                }
                
                self?.insertUserRecord(id: userId, imageUrl: downloadUrl.absoluteString)
            }
        }
    }
    
    private func insertUserRecord(id: String, imageUrl: String) {
        let newUser = User(id: id, name: name, email: email, nickname: nickname, joined: Date().timeIntervalSince1970, imageUrl: imageUrl)
        
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
