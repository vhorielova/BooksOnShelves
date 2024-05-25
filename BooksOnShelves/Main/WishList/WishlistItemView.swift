import SwiftUI

struct WishlistItemView: View {
    let item: WishlistItem
    @StateObject var viewModel = WishListItemViewViewModel()
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(item.title)
                    .font(.body)
                Text(item.author)
                    .foregroundStyle(Color(.gray))
                Text("\(Date(timeIntervalSince1970: item.createdDate).formatted(date: .abbreviated, time: .shortened))")
                
            }
            
            Spacer()
            
            Button{
                viewModel.toggleIsDone(item: item)
            } label: {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
            }
        }
    }
}

#Preview {
    WishlistItemView(item: .init(id: "123", title: "abc", author: "fgh", createdDate: Date().timeIntervalSince1970, isDone: false))
}
