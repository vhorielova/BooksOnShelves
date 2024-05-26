import Foundation

struct Book: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let author: String
    let rate: Int
    let imageUrl: String?  // Optional URL for the book image
}
