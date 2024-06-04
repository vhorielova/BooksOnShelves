import SwiftUI

struct EditBookView: View {
    @ObservedObject var viewModel: EditBookViewViewModel
    @State private var isImagePickerPresented = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Edit Book")
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
                        Image(systemName: "book.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 125, height: 125)
                            .foregroundColor(.gray)
                    }

                    Button("Change Book Cover") {
                        isImagePickerPresented = true
                    }
                    .padding()
                    
                    if let successMessage = viewModel.successMessage {
                        Text(successMessage)
                            .foregroundColor(.green)
                            .padding(.horizontal)
                    }

                    Text("Title:")
                        .padding(.horizontal)
                        .bold()
                    TextField("Title", text: $viewModel.title)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Text("Author:")
                        .padding(.horizontal)
                        .bold()
                    TextField("Author", text: $viewModel.author)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Rating:")
                        .padding(.horizontal)
                        .bold()
                    TextField("Rating", value: $viewModel.rate, formatter: NumberFormatter())
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Description:")
                        .padding(.horizontal)
                        .bold()
                    TextField("Description", text: $viewModel.description)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Note:")
                        .padding(.horizontal)
                        .bold()
                    TextField("Note", text: $viewModel.note)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()

                Spacer()
                
                TLButton(title: "Save", command: SaveEditedBook(viewModel: viewModel))
                    .padding()
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $viewModel.image, width: 125, height: 125)
            }
        }
    }
}

struct EditBookView_Previews: PreviewProvider {
    static var previews: some View {
        EditBookView(viewModel: EditBookViewViewModel(userId: "123", bookId: "123"))
    }
}
