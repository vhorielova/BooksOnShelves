import SwiftUI

enum TabbedItem: Int, CaseIterable{
    case bookshelf = 0
    //case favorite
    case wishList
    case profile
    
    var title: String{
        switch self {
        case .bookshelf:
            return "Bookshelf"
        //case .favorite:
            //return "Favorite"
        case .wishList:
            return "WishList"
        case .profile:
            return "Profile"
        }
    }
    
    var iconName: String{
        switch self {
        case .bookshelf:
            return "bookshelf"
        //case .favorite:
            //return "favorite"
        case .wishList:
            return "wishlist"
        case .profile:
            return "profile"
        }
    }
}

struct MainTabbedView: View {
    
    @State var selectedTab = 0
    var userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                HomeView(userId: userId)
                    .tag(0)

                //FavoriteView()
                    //.tag(1)

                WishListView(userId: userId)
                    .tag(1)

                ProfileView(userId: userId)
                    .tag(2)
            }
            
            Rectangle()
                .foregroundColor(.white)
                .frame(width: .infinity, height: 90)

            ZStack{
                
                HStack{
                    ForEach((TabbedItem.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, title: item.title, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: 70)
            .background(.violetBG.opacity(0.3))
            .cornerRadius(35)
            .padding()
            //.padding(.horizontal, 26)
            //.padding(.vertical, 15)
        }
        .ignoresSafeArea()

    }
}

extension MainTabbedView{
    func CustomTabItem(imageName: String, title: String, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .text : .gray)
                .frame(width: 20, height: 20)
            if isActive{
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isActive ? .text : .gray)
            }
            Spacer()
        }
        .frame(width: isActive ? .infinity : 60, height: 60)
        .background(isActive ? .violetBG : .clear)
        .cornerRadius(30)
    }
}

struct MainTabbedView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}
