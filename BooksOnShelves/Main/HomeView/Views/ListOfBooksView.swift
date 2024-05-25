import SwiftUI
import FirebaseFirestoreSwift

struct ListOfBooksView: View {
    @ObservedObject var viewModel: ListOfBooksViewViewModel
    @FirestoreQuery var items: [Book]
    
    init(userId: String, valueToCompare: Int) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/books")
        
        let sortingStrategy: SortingStrategy
        switch valueToCompare {
        case 0:
            sortingStrategy = AuthorSortingStrategy()
        case 1:
            sortingStrategy = TitleSortingStrategy()
        default:
            sortingStrategy = RateSortingStrategy()
        }
        
        let viewModel = ListOfBooksViewViewModel(userId: userId, sortingStrategy: sortingStrategy)
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(viewModel.sortBooks(items)) { item in
            Button {
                // go to the book
            } label: {
                BookInListView(item: item)
            }
        }
        .listStyle(PlainListStyle())
    }
}
