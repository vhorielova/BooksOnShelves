import SwiftUI
import Combine

struct NewWishlistItemView: View {
    @StateObject var viewModel = NewWishlistItemViewViewModel()
    @Binding var newItemPresented: Bool
    
    func limitText(_ text: Binding<String>, _ upper: Int) {
        if text.wrappedValue.count > upper {
            text.wrappedValue = String(text.wrappedValue.prefix(upper))
        }
    }
    
    var body: some View {
        VStack {
            Text("New wish-book")
                .bold()
                .font(.system(size: 36))
                .foregroundColor(.text)
                .padding(.top, 30)
            
            Form {
                TextField("Title", text: $viewModel.title.input)
                    .onReceive(Just(viewModel.title.input)) { _ in limitText($viewModel.title.input, 100) }
                TextField("Author", text: $viewModel.author.input)
                    .onReceive(Just(viewModel.author.input)) { _ in limitText($viewModel.author.input, 100) }
                
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
