import SwiftUI
import Combine

struct EditBookView: View {
    @ObservedObject var viewModel: EditBookViewViewModel
    @State private var isImagePickerPresented = false
    @State private var imagePickerForDescription = false
    @State private var imagePickerForQuote = false
    @State private var selectedQuoteIndex: Int? = nil
    
    func limitText(_ text: Binding<String>, _ upper: Int) {
        if text.wrappedValue.count > upper {
            text.wrappedValue = String(text.wrappedValue.prefix(upper))
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
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
                                .frame(width: 76, height: 103)
                                .clipped()
                                .cornerRadius(15)
                        } else if let downloadedImage = viewModel.downloadedImage {
                            Image(uiImage: downloadedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 76, height: 103)
                                .clipped()
                                .cornerRadius(15)
                        } else {
                            Image(systemName: "book.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 76, height: 103)
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
                            .onReceive(Just(viewModel.title)) { _ in limitText($viewModel.title, 100) }
                            .padding(.horizontal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Text("Author:")
                            .padding(.horizontal)
                            .bold()
                        TextField("Author", text: $viewModel.author)
                            .onReceive(Just(viewModel.author)) { _ in limitText($viewModel.author, 100) }
                            .padding(.horizontal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Text("Rating:")
                            .padding(.horizontal)
                            .bold()
                        TextField("Rating", value: $viewModel.rate, formatter: NumberFormatter())
                            .padding(.horizontal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        HStack {
                            TextField("Description (try take a photo)", text: $viewModel.description)
                                .onReceive(Just(viewModel.description)) { _ in limitText($viewModel.description, 1000) }
                                .frame(height: 100)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.leading)
                            Button(action: {
                                imagePickerForDescription = true
                            }) {
                                Image(systemName: "camera")
                                    .foregroundColor(.blue)
                            }
                            .padding(.trailing)
                        }

                        Text("Note:")
                            .padding(.horizontal)
                            .bold()
                        TextField("Note", text: $viewModel.note)
                            .onReceive(Just(viewModel.note)) { _ in limitText($viewModel.note, 500) }
                            .padding(.horizontal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding()

                    VStack(alignment: .leading) {
                        Text("Quotes")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(viewModel.quotes.indices, id: \.self) { index in
                            EditQuoteView(quote: $viewModel.quotes[index].quote, onImagePicker: {
                                selectedQuoteIndex = index
                                imagePickerForQuote = true
                            }, onDelete: {
                                viewModel.deleteQuote(viewModel.quotes[index])
                            })
                            .onReceive(Just(viewModel.quotes[index].quote)) { _ in limitText($viewModel.quotes[index].quote, 500) }
                        }

                        HStack {
                            TextField("New Quote", text: $viewModel.newQuote)
                                .onReceive(Just(viewModel.newQuote)) { _ in limitText($viewModel.newQuote, 500) }
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Button(action: {
                                viewModel.addQuote()
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding()

                    Spacer()
                    
                    TLButton(title: "Save", command: SaveEditedBook(viewModel: viewModel))
                        .padding()
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $viewModel.image, width: 76, height: 103)
                }
                .sheet(isPresented: $imagePickerForQuote) {
                    ImagePicker(selectedImage: $viewModel.textImage, completion: { text in
                        if let index = selectedQuoteIndex {
                            viewModel.appendQuote(at: index, with: text ?? "")
                        }
                    })
                }
                .sheet(isPresented: $imagePickerForDescription) {
                    ImagePicker(selectedImage: $viewModel.textImage) { text in
                        viewModel.appendDescription(with: text)
                    }
                }
            }
        }
    }
}

struct EditBookView_Previews: PreviewProvider {
    static var previews: some View {
        EditBookView(viewModel: EditBookViewViewModel(userId: "123", bookId: "123"))
    }
}
