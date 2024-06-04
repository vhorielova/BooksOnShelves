import SwiftUI

struct CreateAccountView: View {
    @State private var showImagePicker: Bool = false
    @StateObject var viewModel = CreateAccountViewViewModel()
    
    var body: some View {
        VStack {
            HeaderView()
            
            Form {
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
                TextField("Your name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                TextField("Nickname", text: $viewModel.nickname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                TextField("Email address", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 125, height: 125)
                }
                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Select image of book")
                }
                TLButton(title: "Create an account", command: CreateAccountCommand(viewModel: viewModel))
            }
            .background(.white)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $viewModel.selectedImage, width: 125, height: 125)
            }
        }
        .ignoresSafeArea()
    }
}

