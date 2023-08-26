//
//  ViewController.swift
//  SeeFood-Core-ML
//
//  Created by Rajveer Singh on 24/08/23.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,
                      UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = true
        
        addButton.menu = menuItems()
    }
    
    func menuItems() -> UIMenu {
        
        let items = UIMenu(title: "", options: .displayInline, children: [
            
            UIAction(title: "Camera", image: UIImage(systemName: "camera"), handler: { [self] (_) in
                self.imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }),
            UIAction(title: "Photo Library", image: UIImage(systemName: "photo"), handler: { [self] (_) in
                self.imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
        ])
        
        return items
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.editedImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage into CIImage")
            }
                
            detect(image: ciImage)
        } else if let userPickedImage = info[.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage into CIImage")
            }
                
            detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3(configuration: .init()).model) else {
            fatalError("Loading CoreML failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                } else {
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
}

