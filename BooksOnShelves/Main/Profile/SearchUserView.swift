import SwiftUI

struct SearchUserView: View {
    @State private var searchText = ""
    @StateObject var viewModel: SearchUserViewViewModel
    
    init(viewModel: SearchUserViewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Enter nickname", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                .frame(height: 50)
                .background(Color(.systemGray6))
                .cornerRadius(10)

                Button("Search") {
                    viewModel.searchUser(by: searchText)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

                if let user = viewModel.foundUser {
                    UserProfileView(user: user)
                        .padding(.horizontal)
                } else {
                    Text("No user found")
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 32)
        }
        .background(Color(.systemBackground))
    }
}

struct UserProfileView: View {
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Name: \(user.name)")
            Text("Email: \(user.email)")
            Text("Nickname: \(user.nickname)")

            Spacer()

            Button("View Profile") {
                // Navigate to User's Profile
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    SearchUserView(viewModel: SearchUserViewViewModel())
}
