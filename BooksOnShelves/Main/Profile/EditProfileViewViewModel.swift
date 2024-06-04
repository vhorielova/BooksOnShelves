import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class EditProfileViewViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var nickname: String = ""
    @Published var downloadedImage: UIImage?
    @Published var image: UIImage?

    var userId: String

    init(userId: String) {
        self.userId = userId
        fetchUser()
    }

    private func fetchUser() {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }

            DispatchQueue.main.async {
                self.name = data["name"] as? String ?? ""
                self.email = data["email"] as? String ?? ""
                self.nickname = data["nickname"] as? String ?? ""
                if let imageUrl = data["imageUrl"] as? String, !imageUrl.isEmpty {
                    self.fetchImage(from: imageUrl)
                }
            }
        }
    }

    func updateProfile() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserId)

        var updatedData: [String: Any] = [
            "name": name,
            "email": email,
            "nickname": nickname
        ]

        if let image = image {
            uploadImage(image) { imageUrl in
                if let imageUrl = imageUrl {
                    updatedData["imageUrl"] = imageUrl
                }

                userRef.updateData(updatedData) { error in
                    if let error = error {
                        print("Error updating profile: \(error)")
                    } else {
                        print("Profile successfully updated")
                    }
                }
            }
        } else {
            userRef.updateData(updatedData) { error in
                if let error = error {
                    print("Error updating profile: \(error)")
                } else {
                    print("Profile successfully updated")
                }
            }
        }
    }

    private func fetchImage(from url: String) {
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

    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }

        let storageRef = Storage.storage().reference().child("profile_images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
            } else {
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                        completion(nil)
                    } else {
                        completion(url?.absoluteString)
                    }
                }
            }
        }
    }
}
