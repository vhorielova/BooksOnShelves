import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    @StateObject var subscriptionViewModel = SubscriptionViewModel()
    var userId: String // ID профілю користувача, якого переглядаємо

    @State private var isEditProfilePresented = false

    var body: some View {
        NavigationView {
            VStack {
                TitleView(title: "Profile")

                if let user = viewModel.user {
                    if let imageUrl = user.imageUrl, !imageUrl.isEmpty {
                        if let downloadedImage = viewModel.downloadedImage {
                            Image(uiImage: downloadedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 125, height: 125)
                                .clipped()
                                .cornerRadius(15)
                        } else {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 125, height: 125)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(15)
                                .onAppear {
                                    viewModel.fetchImage(from: imageUrl)
                                }
                        }
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.mainGrey)
                            .frame(width: 125, height: 125)
                    }

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
                        TLButton(title: "Edit Profile", command: EditProfileCommand(isEditProfilePresented: $isEditProfilePresented))
                            .padding(.horizontal)
                            .sheet(isPresented: $isEditProfilePresented) {
                                EditProfileView(viewModel: EditProfileViewViewModel(userId: user.id))
                            }
                            

                        TLButton(title: "Log out", command: LogoutCommand(viewModel: viewModel))
                            .padding(.bottom)
                            .padding(.horizontal)
                            
                    } else {
                        // TLButton(title: "Follow", command: FollowUserCommand(viewModel: subscriptionViewModel, userId: user.id))
                        // .padding()
                        // .frame(height: 80)
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
}

#Preview {
    ProfileView(userId: "xyaBGpZIOBV0LCDrhetpGXmofAz2")
}
