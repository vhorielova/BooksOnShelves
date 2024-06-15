import SwiftUI

struct AddQuoteView: View {
    @Binding var quote: String
    var onCameraTap: () -> Void
    var onDeleteTap: () -> Void

    var body: some View {
        HStack {
            TextField("Enter quote (or take a photo of it)", text: $quote)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: onCameraTap) {
                Image(systemName: "camera")
                    .foregroundColor(.blue)
            }
            Button(action: onDeleteTap) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
    }
}
