import SwiftUI
import Combine

struct CreateAccountView: View {
    @State private var showImagePicker: Bool = false
    @StateObject var viewModel = CreateAccountViewViewModel()
    
    func limitText(_ text: Binding<String>, _ upper: Int) {
        if text.wrappedValue.count > upper {
            text.wrappedValue = String(text.wrappedValue.prefix(upper))
        }
    }
    
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
                    .onReceive(Just(viewModel.name)) { _ in limitText($viewModel.name, 20) }
                TextField("Nickname", text: $viewModel.nickname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                    .onReceive(Just(viewModel.nickname)) { _ in limitText($viewModel.nickname, 30) }
                TextField("Email address", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .onReceive(Just(viewModel.email)) { _ in limitText($viewModel.email, 50) }
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onReceive(Just(viewModel.password)) { _ in limitText($viewModel.password, 30) }
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 125, height: 125)
                }
                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Select image of profile")
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

