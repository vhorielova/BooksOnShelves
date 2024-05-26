import SwiftUI
import FirebaseStorage

class BookInListViewViewModel: ObservableObject {
    @Published var downloadedImage: UIImage?

    func fetchImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        let storageRef = Storage.storage().reference(forURL: url)
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Failed to download image: \(error)")
            } else if let data = data {
                DispatchQueue.main.async {
                    self.downloadedImage = UIImage(data: data)
                }
            }
        }
    }
}
