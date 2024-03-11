import Foundation


struct Book: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let author: String
    let rate: String
    //let notes: [String]
    //let quotes: [String]
    //let createdDate: TimeInterval
    
}
