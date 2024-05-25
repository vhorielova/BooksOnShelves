import SwiftUI

struct BookInListView: View {
    let item: Book
    @StateObject var viewModel = BookInListViewViewModel()
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: .infinity, height: 150)
                .background(Color(red: 0.99, green: 0.75, blue: 0.72).opacity(0.27))
            
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            HStack{
                //Spacer()
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
                //Spacer()
                VStack(alignment: .leading){
                    Text(item.title)
                        .font(Font.custom("Inria Serif", size: 25))
                        .foregroundColor(.black)

                        
                    Text(item.author)
                        .font(Font.custom("Inria Serif", size: 20))
                        .foregroundColor(.black.opacity(0.65))


                    HStack{
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
    BookInListView(item: .init(id: "123", title: "abc", author: "ghk", rate: 2))
}
