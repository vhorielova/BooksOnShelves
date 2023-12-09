import SwiftUI

struct NewWishlistItemView: View {
    @StateObject var viewModel = NewWishlistItemViewViewModel()
    @Binding var newItemPresented: Bool
    
    var body: some View {
        VStack{
            Text("New wish-book")
                .bold()
                .font(.system(size: 36))
                .foregroundColor(.white)
                .padding(.top, 30)
            
            Form{
                TextField("Title", text: $viewModel.title)
                
                DatePicker("Due Date", selection: $viewModel.dueDate)
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                TLButton(title: "Save"){
                    if viewModel.canSave{
                        viewModel.save()
                        newItemPresented = false
                    } else {
                        viewModel.showAlert = true
                    }
                }
                .padding()
            }
        }
        .background(.mainPink)
        .alert(isPresented: $viewModel.showAlert){
            Alert(title: Text("Error"), message: Text("Fill in at least \"Title\" field"))
        }
    }
}

#Preview {
    NewWishlistItemView(newItemPresented: Binding(get: {
        return true
    }, set: { _ in
        
    } ))
}