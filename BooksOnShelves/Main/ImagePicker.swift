import SwiftUI
import UIKit
import CropViewController
import Vision

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var width: Int?
    var height: Int?
    var completion: ((String?) -> Void)?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CropViewControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                let cropViewController = CropViewController(croppingStyle: .default, image: image)
                cropViewController.delegate = self
                
                if let width = parent.width, let height = parent.height {
                    cropViewController.customAspectRatio = CGSize(width: width, height: height)
                    cropViewController.aspectRatioLockEnabled = true
                } else {
                    cropViewController.aspectRatioLockEnabled = false
                }

                picker.pushViewController(cropViewController, animated: true)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }

        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            parent.selectedImage = image
            parent.presentationMode.wrappedValue.dismiss()
            
            recognizeText(in: image) { recognizedText in
                self.parent.completion?(recognizedText)
            }
        }

        private func recognizeText(in image: UIImage, completion: @escaping (String?) -> Void) {
            guard let cgImage = image.cgImage else {
                completion(nil)
                return
            }
            
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest { request, error in
                guard error == nil, let observations = request.results as? [VNRecognizedTextObservation] else {
                    completion(nil)
                    return
                }
                
                let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                completion(recognizedText)
            }
            
            do {
                try requestHandler.perform([request])
            } catch {
                completion(nil)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
