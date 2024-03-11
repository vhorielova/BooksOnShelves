import SwiftUI

struct TLButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button{
            action()
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.mainPink)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Text(title)
                    .foregroundColor(.white)
                    .bold()
            }
        }
    }
}

#Preview {
    TLButton(title: "title"){
        //action
    }
}
