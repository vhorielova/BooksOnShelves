import Foundation

class HomeViewViewModel: ObservableObject {
    @Published var showingNewItemView: Bool = false
    
    private let userId: String
    
    func getUserId() -> String {
        return userId
    }
    
    init(userId: String) {
        self.userId = userId
    }
    
}
