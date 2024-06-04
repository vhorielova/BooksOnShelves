import SwiftUI

struct NewWishlistItemView: View {
    @StateObject var viewModel = NewWishlistItemViewViewModel()
    @Binding var newItemPresented: Bool
    
    var body: some View {
        VStack {
            Text("New wish-book")
                .bold()
                .font(.system(size: 36))
                .foregroundColor(.text)
                .padding(.top, 30)
            
            Form {
                TextField("Title", text: $viewModel.title.input)
                TextField("Author", text: $viewModel.author.input)
                
                TLButton(title: "Save", command: SaveCommand(viewModel: viewModel, newItemPresented: $newItemPresented))
                    .padding()
            }
        }
        .background(.violetBG)
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text("Fill in at least \"Title\" field"))
        }
    }
}

#Preview {
    NewWishlistItemView(newItemPresented: .constant(true))
}
