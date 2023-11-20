import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.mainPink)
            VStack(){
                
                Text("BOOKSHELVES")
                    .foregroundColor(.white)
                    .font(.system(size: 50))
                    .bold()
                Text("Save all your books in one place")
                    .foregroundColor(.white)
                    .font(.system(size: 25))
            }

        }
        .frame(height: UIScreen.main.bounds.height/3)
    }
}

#Preview {
    HeaderView()
}
