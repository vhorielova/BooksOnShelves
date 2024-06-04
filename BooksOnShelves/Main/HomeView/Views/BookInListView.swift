import SwiftUI

struct BookInListView: View {
    let item: Book
    @StateObject var viewModel = BookInListViewViewModel()

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: .infinity, height: 150)
                .background(Color(red: 0.99, green: 0.75, blue: 0.72).opacity(0.27))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            HStack {
                if let imageUrl = item.imageUrl, !imageUrl.isEmpty {
                    if let downloadedImage = viewModel.downloadedImage {
                        Image(uiImage: downloadedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 76, height: 103)
                            .clipped()
                            .cornerRadius(15)
                    } else {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 76, height: 103)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(15)
                            .onAppear {
                                viewModel.fetchImage(from: imageUrl)
                            }
                    }
                } else {
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
                }
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(Font.custom("Inria Serif", size: 25))
                        .foregroundColor(.black)
                    Text(item.author)
                        .font(Font.custom("Inria Serif", size: 20))
                        .foregroundColor(.black.opacity(0.65))
                    HStack {
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
    BookInListView(item: .init(id: "123", title: "Залізне полум’я. Емпіреї. Книга 2", author: "Ребекка Яррос", rate: 9, imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/bookshelves-8fb64.appspot.com/o/book_images%2F4EBE6E93-63F8-4605-A243-C6F6A45ECB03.jpg?alt=media&token=de5133f9-15f1-4202-b535-4c7eef9a4a20", description: "У перший рік деякі з нас втрачають життя. На другий рік ми втрачаємо свою людяність. Багато хто очікував, що Вайолет Сорренґейл загине під час свого першого року навчання у Військовому коледжі Басґіат. Однак Обмолот був лише першим надважким випробуванням, покликаним відсіяти слабких, негідних і невдах.А тепер починається справжнє навчання, тож Вайолет уже переймається, як вона впорається. Річ не тільки в тому, що другий курс має бути виснажливий і неймовірно жорстокий, до того ж, цього року вершники повинні навчитися витримувати фізичний і моральний тиск. Однак є ще новий віцекомендант, який поставив собі за особисту мету довести Вайолет, наскільки вона слабка і легкодуха, якщо тільки не зрадить чоловіка, якого кохає.І хоча тіло Вайолет не таке сильне й витривале, як у інших курсантів, вона має гострий розум і залізну волю. А керівництво забуває найважливіший урок, який засвоюєш у Басґіаті: вершники драконів встановлюють власні правила. Проте самого бажання вижити цього року буде недостатньо. Адже Вайолет знає страшну таємницю, яку століттями приховували у Наваррі.", note: ""))
}

