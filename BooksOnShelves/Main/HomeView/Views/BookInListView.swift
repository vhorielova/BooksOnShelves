import SwiftUI

struct BookInListView: View {
    let item: Book
    @StateObject var viewModel = BookInListViewViewModel()

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: .infinity, height: 150)
                .background(Color(red: 0.99, green: 0.75, blue: 0.72).opacity(0.27))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            HStack {
                if let imageUrl = item.imageUrl, !imageUrl.isEmpty {
                    if let downloadedImage = viewModel.downloadedImage {
                        Image(uiImage: downloadedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 76, height: 103)
                            .clipped()
                            .cornerRadius(15)
                    } else {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 76, height: 103)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(15)
                            .onAppear {
                                viewModel.fetchImage(from: imageUrl)
                            }
                    }
                } else {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 76, height: 103)
                        .background(
                            Image("Book")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 76, height: 103)
                                .clipped()
                        )
                        .cornerRadius(15)
                }
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(Font.custom("Inria Serif", size: 25))
                        .foregroundColor(.black)
                    Text(item.author)
                        .font(Font.custom("Inria Serif", size: 20))
                        .foregroundColor(.black.opacity(0.65))
                    HStack {
                        Text("Rate:")
                        Text(String(item.rate))
                            .font(Font.custom("Inria Serif", size: 17))
                            .foregroundColor(.black)
                    }
                }
                .padding()
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: 150)
    }
}

#Preview {
    BookInListView(item: .init(id: "123", title: "abc", author: "ghk", rate: 2, imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/bookshelves-8fb64.appspot.com/o/book_images%2F4EBE6E93-63F8-4605-A243-C6F6A45ECB03.jpg?alt=media&token=de5133f9-15f1-4202-b535-4c7eef9a4a20"))
}
