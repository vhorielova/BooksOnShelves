import SwiftUI

struct NewBookView: View {
    @StateObject var viewModel = NewBookViewViewModel()
    @Binding var newItemPresented: Bool
    
    var body: some View {
        VStack{
            Text("Add a Book")
                .bold()
                .font(.system(size: 36))
                .foregroundColor(.white)
                .padding(.top, 30)
            
            Form{
                TextField("Title", text: $viewModel.title)
                TextField("Author", text: $viewModel.author)
                TextField("Rate: from 1 to 10", text: $viewModel.rate)
                    .keyboardType(.numberPad)
                
                TLButton(title: "Save") {
                    if viewModel.canSave {
                        viewModel.save()
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
                .padding()
            }
        }
        .background(Color.mainPink)
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
