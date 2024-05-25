import Foundation

class ListOfBooksViewViewModel: ObservableObject {
    private let userId: String
    private var sortingStrategy: SortingStrategy
    
    @Published var books: [Book] = []
    
    init(userId: String, sortingStrategy: SortingStrategy) {
        self.userId = userId
        self.sortingStrategy = sortingStrategy
    }
    
    func setSortingStrategy(_ strategy: SortingStrategy) {
        self.sortingStrategy = strategy
        self.books = sortBooks(self.books)
    }
    
    func sortBooks(_ books: [Book]) -> [Book] {
        return sortingStrategy.sort(books)
    }
}


