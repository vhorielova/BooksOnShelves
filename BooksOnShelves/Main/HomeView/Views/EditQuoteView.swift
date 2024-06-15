import SwiftUI

struct EditQuoteView: View {
    @Binding var quote: String
    var onImagePicker: () -> Void
    var onDelete: () -> Void

    var body: some View {
        HStack {
            TextField("Quote", text: $quote)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: onImagePicker) {
                Image(systemName: "camera")
                    .foregroundColor(.blue)
            }

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
    }
}
