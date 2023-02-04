//
//  CSPickerImage.swift
//  FoodieClientIOS
//
//  Created by Calogero Friscia on 03/02/23.
//

import PhotosUI
import SwiftUI

/* copiato da Paul Hudson
 https://github.com/twostraws/HackingWithSwift/blob/main/SwiftUI/project13/Instafilter/ImagePicker.swift
03.02.23 */
struct CSImagePicker:UIViewControllerRepresentable {

    @Binding var image:UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        
        return picker
        
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
        
    }
    
    class Coordinator:NSObject,PHPickerViewControllerDelegate {
        
        var parent: CSImagePicker
        
        init(_ parent: CSImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage

                }
            }
            
        }
        
    } // end Coordinator
      
}

struct CSPickerImage_CAM: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) private var presentationMode
    let sourceType: UIImagePickerController.SourceType = .camera
    
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: UIViewControllerRepresentableContext<CSPickerImage_CAM>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CSPickerImage_CAM>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: CSPickerImage_CAM

        init(_ parent: CSPickerImage_CAM) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}
