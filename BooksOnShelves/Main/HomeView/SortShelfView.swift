import SwiftUI

struct SortShelfView: View {
    var body: some View {
        ZStack(alignment: .leading){
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: .infinity, height: 34)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.73, green: 0.73, blue: 0.73), lineWidth: 1)
                    
                )
            Text("Сортування")
                .font(Font.custom("Inria Serif", size: 13))
                .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.56))
            
                .frame(width: 324, height: 20, alignment: .topLeading)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    SortShelfView()
}
