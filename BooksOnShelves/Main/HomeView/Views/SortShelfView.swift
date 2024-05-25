import SwiftUI

struct SortShelfView: View {
    @StateObject var viewModel: SortShelfViewViewModel
    
    init(userId: String) {
        self._viewModel = StateObject(wrappedValue: SortShelfViewViewModel(userId: userId))
    }
    
    @State var sortValue:String = "За назвою"
    @State var name:String = "Сортування: "
    @State var show:Bool = false
    @State var sortNumber:Int = 1
    
    var body: some View {
        //VStack{
            VStack(spacing: 5) {
                ZStack(){
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: .infinity, height: 34)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0.73, green: 0.73, blue: 0.73), lineWidth: 1)
                            
                        )
                    HStack{
                        Text(name + sortValue)
                            .font(.title3)
                        Spacer()
                        Image(systemName: "chevron.forward")
                            .rotationEffect(.degrees(show ? 90 : 0))
                    }
                    .padding(.horizontal)
                }
                .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.56))
                .onTapGesture {
                    withAnimation{
                        show.toggle()
                    }
                }
                ZStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0.73, green: 0.73, blue: 0.73), lineWidth: 1)
                            
                        )
                    ScrollView{
                        VStack(spacing: 17){
                            ForEach((SortItem.allCases), id: \.self){ item in
                                Button{
                                    withAnimation{
                                        sortValue = item.name
                                        sortNumber = item.rawValue
                                        show.toggle()
                                    }
                                } label: {
                                    Text(item.name)
                                        .foregroundColor(Color(red: 0.73, green: 0.73, blue: 0.73))
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        .padding(.vertical, 10)
                    }
                
                }
                .frame(height: show ? 120 : 0)
                //Text(String(sortNumber))
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        ListOfBooksView(userId: viewModel.getUserId(), valueToCompare: sortNumber)
        //}
        //.padding()
        //.frame(height: show ? 170 : 34)
        //.offset(y: 15)
    }
}

#Preview {
    SortShelfView(userId: "")
}
