import Foundation

enum SortItem: Int, CaseIterable{
    case author = 0
    case title
    case rate
    
    var name: String{
        switch self{
        case .author:
            return "За автором"
        case .title:
            return "За назвою"
        case .rate:
            return "За рейтингом"
        }
    }
}

class SortShelfViewViewModel: ObservableObject {
    private var userId: String = ""
    
    init(userId: String) {
        self.userId = userId
    }
    
    func getUserId() -> String {
        return userId
    }
}
