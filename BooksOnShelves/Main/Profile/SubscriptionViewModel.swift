import Foundation
import FirebaseAuth
import FirebaseFirestore

class SubscriptionViewModel: ObservableObject {
    func followUser(userId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        let followingRef = db.collection("users").document(currentUserId).collection("following").document(userId)
        let followersRef = db.collection("users").document(userId).collection("followers").document(currentUserId)
        
        followingRef.setData(["userId": userId]) { error in
            if let error = error {
                print("Error following user: \(error)")
            } else {
                followersRef.setData(["userId": currentUserId]) { error in
                    if let error = error {
                        print("Error adding follower: \(error)")
                    }
                }
            }
        }
    }
    
    func unfollowUser(userId: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        
        let followingRef = db.collection("users").document(currentUserId).collection("following").document(userId)
        let followersRef = db.collection("users").document(userId).collection("followers").document(currentUserId)
        
        followingRef.delete { error in
            if let error = error {
                print("Error unfollowing user: \(error)")
            } else {
                followersRef.delete { error in
                    if let error = error {
                        print("Error removing follower: \(error)")
                    }
                }
            }
        }
    }
}
