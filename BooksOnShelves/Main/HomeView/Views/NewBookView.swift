import SwiftUI

struct NewBookView: View {
    @StateObject var viewModel = NewBookViewViewModel()
    @Binding var newItemPresented: Bool
    @State private var showImagePicker: Bool = false
    
    var body: some View {
        VStack {
            Text("Add a Book")
                .bold()
                .font(.system(size: 36))
                .foregroundColor(.text)
                .padding(.top, 30)
            
            Form {
                TextField("Title", text: $viewModel.title)
                TextField("Author", text: $viewModel.author)
                TextField("Rate", text: $viewModel.rate)
                    .keyboardType(.numberPad)
                TextField("Book description", text: $viewModel.description)
                    .keyboardType(.numberPad)
                    .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                TextField("Your note", text: $viewModel.note)
                    .keyboardType(.numberPad)
                
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 76, height: 103)
                }

                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Select image of book")
                }
                
                TLButton(title: "Save", command: SaveBookCommand(viewModel: viewModel, newItemPresented: $newItemPresented))
                    .padding()
            }
        }
        .background(Color.violetBG)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage, width: 76, height: 103)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
        }
    }
}

#Preview {
    NewBookView(newItemPresented: Binding(get: {
        return true
    }, set: { _ in
        
    }))
}
