import SwiftUI

/*struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    
    var body: some View {
        VStack{
            TitleView(title: "My Profile")
            
            if let user = viewModel.user{
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.mainGrey)
                    .frame(width: 125, height: 125)
                
                VStack(alignment: .leading){
                    HStack{
                        Text("Name: ")
                            .bold()
                        Text(user.name)
                    }
                    .padding()
                    HStack{
                        Text("Email: ")
                            .bold()
                        Text(user.email)
                    }
                    .padding()
                    HStack{
                        Text("Member since: ")
                            .bold()
                        Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                    }
                    .padding()
                    
                }
                
                Spacer()
                
                TLButton(title: "Log out"){
                    viewModel.logout()
                }
                .padding()
                .frame(height: 80)
            } else {
                Text("Loading profile...")
            }
            
            
            //Spacer()
        }
        .onAppear{
            viewModel.fetchUser()
        }
    }
}

#Preview {
    ProfileView()
}
*/

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    @StateObject var subscriptionViewModel = SubscriptionViewModel()
    var userId: String // ID профілю користувача, якого переглядаємо

    var body: some View {
        VStack {
            TitleView(title: "Profile")

            if let user = viewModel.user {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.mainGrey)
                    .frame(width: 125, height: 125)

                VStack(alignment: .leading) {
                    HStack {
                        Text("Name: ")
                            .bold()
                        Text(user.name)
                    }
                    .padding()
                    HStack {
                        Text("Email: ")
                            .bold()
                        Text(user.email)
                    }
                    .padding()
                    HStack {
                        Text("Nickname: ")
                            .bold()
                        Text(user.nickname)
                    }
                    .padding()
                    HStack {
                        Text("Member since: ")
                            .bold()
                        Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                    }
                    .padding()
                }

                Spacer()

                if viewModel.isCurrentUser {
                    TLButton(title: "Log out") {
                        viewModel.logout()
                    }
                    .padding()
                    .frame(height: 80)
                } else {
                    TLButton(title: "Follow") {
                        subscriptionViewModel.followUser(userId: user.id)
                    }
                    .padding()
                    .frame(height: 80)
                }
            } else {
                Text("Loading profile...")
            }
        }
        .onAppear {
            viewModel.fetchUser(userId: userId)
        }
    }
}

#Preview {
    ProfileView(userId: "")
}

