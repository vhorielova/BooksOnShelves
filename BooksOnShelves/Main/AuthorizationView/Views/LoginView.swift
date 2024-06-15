import SwiftUI
import Combine

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    
    func limitText(_ text: Binding<String>, _ upper: Int) {
        if text.wrappedValue.count > upper {
            text.wrappedValue = String(text.wrappedValue.prefix(upper))
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView()
                
                Form {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                    TextField("Email address", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .onReceive(Just(viewModel.email)) { _ in limitText($viewModel.email, 50) }
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(viewModel.password)) { _ in limitText($viewModel.password, 30) }
                    TLButton(title: "Log in", command: LoginCommand(viewModel: viewModel))
                }
                .background(.white)
                
                VStack {
                    Text("Don't have an account yet?")
                        .foregroundColor(.black)
                    NavigationLink("Create an account", destination: CreateAccountView())
                }
                .padding(.bottom, 40)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    LoginView()
}
