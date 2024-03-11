import SwiftUI
import FirebaseFirestoreSwift

struct BooksView: View {
    @StateObject var viewModel: BooksViewViewModel
    @FirestoreQuery var items: [Book]
    
    let valueToCompare: Int
    
    init(userId: String, valueToCompare: Int) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/books")
        self.valueToCompare = valueToCompare
        self._viewModel = StateObject(wrappedValue: BooksViewViewModel(userId: userId))
    }
    
    var body: some View {
        
        List(viewModel.mergeSort(items, valueToCompare: valueToCompare)) {item in
            Button{
                //go to the book
            } label: {
                SingleBookView(item: item)
            }
        }
        .listStyle(PlainListStyle())
    }
}

