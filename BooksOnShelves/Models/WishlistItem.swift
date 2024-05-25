import Foundation

struct WishlistItem: Codable, Identifiable {
    let id: String
    let title: String
    let author: String
    let createdDate: TimeInterval
    var isDone: Bool
    
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
}
