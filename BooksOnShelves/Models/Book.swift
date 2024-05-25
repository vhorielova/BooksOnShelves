import Foundation

struct Book: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let author: String
    let rate: Int
    //let notes: [String]
    //let quotes: [String]
    //let createdDate: TimeInterval
}
