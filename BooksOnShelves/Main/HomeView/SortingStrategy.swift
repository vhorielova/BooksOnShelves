import Foundation

protocol SortingStrategy {
    func sort(_ books: [Book]) -> [Book]
}

class AuthorSortingStrategy: SortingStrategy {
    func sort(_ books: [Book]) -> [Book] {
        return books.sorted { $0.author < $1.author }
    }
}

class TitleSortingStrategy: SortingStrategy {
    func sort(_ books: [Book]) -> [Book] {
        return books.sorted { $0.title < $1.title }
    }
}

class RateSortingStrategy: SortingStrategy {
    func sort(_ books: [Book]) -> [Book] {
        return books.sorted { $0.rate < $1.rate }
    }
}
