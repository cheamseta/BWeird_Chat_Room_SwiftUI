//
//  ImagePicker.swift
//  Mood Diary
//
//  Created by seta cheam on 4/19/21.
//

import SwiftUI
import UIKit

struct ImagePicker : UIViewControllerRepresentable {
 
    @Binding var selectedImage : String
    @Environment(\.presentationMode) private var presentationMode
    
    var sourceType : UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: Context) -> some UIViewController {
     
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType;
        imagePickerController.delegate = context.coordinator
        return imagePickerController;
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
    final class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent : ImagePicker
        
        init(_ parent : ImagePicker) {
            self.parent = parent;
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {

                let resizedImage = img.convert(toSize:CGSize(width:200.0, height:200.0), scale: UIScreen.main.scale)
                
                let  value = writeImageFileToDirectory(image: resizedImage);
               
                parent.selectedImage = value;
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func writeImageFileToDirectory(image : UIImage) -> String {
        
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = String(Int.random(in: 1..<10000000)) +  ".jpg"
            // create the destination file url to save your image
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            // get your UIImage jpeg data representation and check if the destination file url already exists
            if let data = image.jpegData(compressionQuality:  0.9),
              !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    print("file saved")
                    return fileURL.path;
             
                } catch {
                    print("error saving file:", error)
                    return ""
                }
            }else{
                return ""
            }
            
       
        }
    }
    
}


extension UIImage
{
    // convenience function in UIImage extension to resize a given image
    func convert(toSize size:CGSize, scale:CGFloat) ->UIImage
    {
        let imgRect = CGRect(origin: CGPoint(x:0.0, y:0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: imgRect)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return copied!
    }
}
