import SwiftUI
import Combine

struct NewBookView: View {
    @StateObject var viewModel = NewBookViewViewModel()
    @Binding var newItemPresented: Bool
    @State private var showImagePicker: Bool = false
    @State private var imagePickerForDescription: Bool = false
    @State private var imagePickerForQuote: Bool = false
    @State private var selectedQuoteIndex: Int? = nil
    @State private var mainImage: UIImage? = nil
    
    func limitText(_ text: Binding<String>, _ upper: Int) {
        if text.wrappedValue.count > upper {
            text.wrappedValue = String(text.wrappedValue.prefix(upper))
        }
    }

    var body: some View {
        VStack {
            VStack {
                Text("Add a Book")
                    .bold()
                    .font(.system(size: 36))
                    .foregroundColor(.text)
                    .padding(.top, 30)
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(Color.violetBG)
            
            ScrollView {
                TextField("Title", text: $viewModel.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top)
                    .onReceive(Just(viewModel.title)) { _ in limitText($viewModel.title, 100) }

                TextField("Author", text: $viewModel.author)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onReceive(Just(viewModel.author)) { _ in limitText($viewModel.author, 100) }

                TextField("Rate", text: $viewModel.rate)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)

                HStack {
                    TextField("Book description (try take a photo)", text: $viewModel.description)
                        .frame(height: 100)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(viewModel.description)) { _ in limitText($viewModel.description, 1000) }
                    Button(action: {
                        imagePickerForDescription = true
                    }) {
                        Image(systemName: "camera")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }

                TextField("Your note", text: $viewModel.note)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onReceive(Just(viewModel.note)) { _ in limitText($viewModel.note, 500) }

                if let image = mainImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 76, height: 103)
                }

                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Select image of book")
                }
                .padding(.vertical)

                Section(header: Text("Quotes").font(.headline)) {
                    ForEach(viewModel.quotes.indices, id: \.self) { index in
                        AddQuoteView(
                            quote: $viewModel.quotes[index].quote,
                            onCameraTap: {
                                selectedQuoteIndex = index
                                imagePickerForQuote = true
                            },
                            onDeleteTap: {
                                viewModel.quotes.remove(at: index)
                                selectedQuoteIndex = nil
                            }
                        )
                        .onReceive(Just(viewModel.quotes[index].quote)) { _ in limitText($viewModel.quotes[index].quote, 500) }
                    }
                    
                    Button(action: {
                        viewModel.addQuote()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add Quote")
                        }
                        .padding()
                        
                    }
                }

                TLButton(title: "Save", command: SaveBookCommand(viewModel: viewModel, newItemPresented: $newItemPresented))
                    .frame(height: 40)
            }
            .padding(.horizontal)
        }
        //.background(Color.violetBG)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage, width: 76, height: 103, completion: { _ in mainImage = viewModel.selectedImage })
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
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
        }
    }
}

#Preview {
    NewBookView(newItemPresented: Binding(get: {
        return true
    }, set: { _ in
        
    }))
}
