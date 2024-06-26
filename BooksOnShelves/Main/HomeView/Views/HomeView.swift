import SwiftUI
import FirebaseFirestoreSwift

struct HomeView: View {
    @StateObject var viewModel: HomeViewViewModel
    
    @FirestoreQuery var items: [Book]

    init(userId: String) {
        self._items = FirestoreQuery(collectionPath: "users/\(userId)/books")
        self._viewModel = StateObject(wrappedValue: HomeViewViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                TitleView(title: "Bookshelf")
                Button{
                    viewModel.showingNewItemView = true
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.mainGrey)
                            .frame(height: 34)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        Text("add new book")
                            .foregroundColor(.white)
                            .bold()
                        
                    }
                    .padding(.horizontal)

                }
                 Spacer()
                SortShelfView(userId: viewModel.getUserId())

                    //Spacer()
            Spacer()
            }
            .sheet(isPresented: $viewModel.showingNewItemView) {
                NewBookView(newItemPresented: $viewModel.showingNewItemView)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider{
    static var previews: some View{
        HomeView(userId: "pWMKTKnp1wOL5sD9aYvZDm4wngE3")
    }
}
