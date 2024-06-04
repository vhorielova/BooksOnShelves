import Foundation

enum TabbedItems: Int, CaseIterable {
    case bookshelf = 0
    //case favorite
    case wishList
    case profile
    
    var title: String {
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
    
    var iconName: String {
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
