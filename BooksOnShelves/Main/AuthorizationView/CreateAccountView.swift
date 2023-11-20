import SwiftUI

struct CreateAccountView: View {
    
    @StateObject var viewModel = CreateAccountViewViewModel()
    
    var body: some View {
        VStack{
            HeaderView()
            
            Form{
                if !viewModel.errorMessage.isEmpty{
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                }
                TextField("Your name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                TextField("Email address", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TLButton(title: "Create an account"){
                    viewModel.createAcc()
                }
            }
            .background(.white)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CreateAccountView()
}
