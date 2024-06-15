import SwiftUI
import Combine

struct EditProfileView: View {
    @ObservedObject var viewModel: EditProfileViewViewModel
    @State private var isImagePickerPresented = false
    
    func limitText(_ text: Binding<String>, _ upper: Int) {
        if text.wrappedValue.count > upper {
            text.wrappedValue = String(text.wrappedValue.prefix(upper))
        }
    }

    var body: some View {
        VStack {
            HStack {
                Text("Edit Profile")
                    .bold()
                    .font(.system(size: 36))
                    .foregroundColor(.text)
                    .padding(.top, 30)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.violetBG)
            }

            VStack(alignment: .leading) {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 125, height: 125)
                        .clipped()
                        .cornerRadius(15)
                } else if let downloadedImage = viewModel.downloadedImage {
                    Image(uiImage: downloadedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 125, height: 125)
                        .clipped()
                        .cornerRadius(15)
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 125, height: 125)
                        .foregroundColor(.gray)
                }

                Button("Change Profile Picture") {
                    isImagePickerPresented = true
                }
                .padding()

                Text("Name:")
                    .padding(.horizontal)
                    .bold()
                TextField("Name", text: $viewModel.name)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onReceive(Just(viewModel.name)) { _ in limitText($viewModel.name, 20) }

                Text("Nickname:")
                    .padding(.horizontal)
                    .bold()
                TextField("Nickname", text: $viewModel.nickname)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onReceive(Just(viewModel.nickname)) { _ in limitText($viewModel.nickname, 30) }
            }
            .padding()

            Spacer()
            
            TLButton(title: "Save", command: SaveEditedProfile(viewModel: viewModel))
                .padding()

        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $viewModel.image, width: 125, height: 125)
        }
    }
}

#Preview {
    EditProfileView(viewModel: EditProfileViewViewModel(userId: "123"))
}
