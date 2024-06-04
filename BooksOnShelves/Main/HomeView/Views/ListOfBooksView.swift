import SwiftUI
import FirebaseFirestoreSwift

struct ListOfBooksView: View {
    @ObservedObject var viewModel: ListOfBooksViewViewModel
    @FirestoreQuery var items: [Book]
    @State private var selectedBook: Book?
    @State private var isSingleBookPresented = false
    let userId: String
    
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
        self.userId = userId
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.sortBooks(items)) { item in
                Button {
                    selectedBook = item
                    isSingleBookPresented = true
                } label: {
                    BookInListView(item: item)
                }
            }
            .listStyle(PlainListStyle())
            .sheet(isPresented: $isSingleBookPresented) {
                if let selectedBook = selectedBook {
                    SingleBookView(userId: userId, book: selectedBook, isPresented: $isSingleBookPresented)
                }
            }
        }
    }
}

#Preview {
    ListOfBooksView(userId: "pWMKTKnp1wOL5sD9aYvZDm4wngE3", valueToCompare: 1)
}
