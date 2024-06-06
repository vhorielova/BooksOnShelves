import SwiftUI
import FirebaseFirestoreSwift

struct WishListView: View {
    @StateObject var viewModel: WishListViewViewModel
    @FirestoreQuery var items: [WishlistItem]
    @State private var itemToDelete: WishlistItem?

    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/wishlist")
        self._viewModel = StateObject(wrappedValue: WishListViewViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView{
            VStack{
                TitleView(title: "My Wishlist")
                
                List(items) { item in
                    WishlistItemView(item: item)
                        .swipeActions {
                            Button {
                                itemToDelete = item
                            } label: {
                                Text("Delete")
                                    .tint(.mainGrey)
                            }
                        }
                }
                .listStyle(PlainListStyle())
                Spacer()
                Button{
                    viewModel.showingNewItemView = true
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.mainGrey)
                            .frame(height: 34)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        Text("add wish-book")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewWishlistItemView(newItemPresented: $viewModel.showingNewItemView)
            }
            .alert(item: $itemToDelete) { item in
                Alert(
                    title: Text("Delete Item"),
                    message: Text("Are you sure you want to delete this item?"),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.delete(id: item.id)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

#Preview {
    WishListView(userId: "SQbTRRiY8dRc6jiRLJ8KlAHYwKm2")
}
