import SwiftUI

struct ScrollShelfView: View {
    var body: some View {
        ScrollView{
            VStack{
                //SortShelfView()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 70)
                    .padding(.horizontal, 35)
                //Spacer()
                ForEach (1..<10){_ in
                    Button{
                        //go to the book
                        //ProfileView()
                    } label: {
                        //BookView(item: )
                    }
                }
            }
        }


    }
}

#Preview {
    ScrollShelfView()
}
