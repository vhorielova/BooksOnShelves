import Foundation

struct Book: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let author: String
    let rate: Int
    let imageUrl: String?
    let description: String
    let note: String
    
    func asDictionary() -> [String: Any] {
        return [
            "id": id,
            "title": title,
            "author": author,
            "rate": rate,
            "imageUrl": imageUrl ?? "",
            "description": description,
            "note": note
        ]
    }
}
