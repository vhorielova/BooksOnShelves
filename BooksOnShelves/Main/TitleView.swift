import SwiftUI

struct TitleView: View {
    let title: String
    var body: some View {
        ZStack(alignment: .top){
            ZStack(alignment: .topLeading){
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .background(Color(red: 0.99, green: 0.75, blue: 0.72))
                
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Text(title)
                    .font(Font.custom("Inria Serif", size: 36))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                
                    .frame(maxWidth: .infinity, maxHeight: 42, alignment: .topLeading)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 20)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .padding(.top, 25)
        }
        //.frame(maxWidth: .infinity, maxHeight: 110, alignment: .top)
        .padding()
    }
}

#Preview {
    TitleView(title: "Title")
}
