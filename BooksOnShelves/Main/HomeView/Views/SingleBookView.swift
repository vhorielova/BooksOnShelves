import SwiftUI

struct SingleBookView: View {
    @ObservedObject var viewModel: SingleBookViewModel
    @Binding var isPresented: Bool
    @State private var showDeleteConfirmation = false
    @State private var isEditSheetPresented = false
    
    init(userId: String, book: Book, isPresented: Binding<Bool>) {
        let viewModel = SingleBookViewModel(book: book, userId: userId)
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Book Details")) {
                    Text("Title: \(viewModel.book.title)")
                    Text("Author: \(viewModel.book.author)")
                    Text("Rating: \(viewModel.book.rate)")
                    Text("Description: \(viewModel.book.description)")
                    Text("Note: \(viewModel.book.note)")
                }
                TLButton(title: "Edit", command: EditBookCommand(viewModel: viewModel, showEditor: $isEditSheetPresented))
                TLButton(title: "Delete", command: DeleteBookCommand(viewModel: viewModel, showDeleteConfirmation: $showDeleteConfirmation))
                    .alert(isPresented: $showDeleteConfirmation) {
                        Alert(
                            title: Text("Delete Book"),
                            message: Text("Are you sure you want to delete this book?"),
                            primaryButton: .destructive(Text("Delete")) {
                                viewModel.deleteBook()
                                self.isPresented = false
                            },
                            secondaryButton: .cancel()
                        )
                    }
            }
        }
        .navigationTitle(viewModel.book.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isEditSheetPresented) {
            EditBookView(viewModel: EditBookViewViewModel(userId: viewModel.userId, bookId: viewModel.book.id))
        }
    }
}
