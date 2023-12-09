//
//  SwiftUIView.swift
//  BooksOnShelves
//
import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewViewModel()
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                HeaderView()
                
                Form{
                    if !viewModel.errorMessage.isEmpty{
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                    TextField("Email address", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TLButton(title: "Log in"){
                        viewModel.login()
                    }
                }
                .background(.white)
                
                VStack{
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