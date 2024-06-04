import SwiftUI

struct TLButton: View {
    let title: String
    let command: Command
    
    var body: some View {
        Button {
            command.execute()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundStyle(.violetBG)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Text(title)
                    .foregroundColor(.text)
                    .bold()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
    }
}

#Preview {
    TLButton(title: "title", command: SaveCommand(viewModel: NewWishlistItemViewViewModel(), newItemPresented: .constant(true)))
}
