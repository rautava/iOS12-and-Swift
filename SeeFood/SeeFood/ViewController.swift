//
//  ViewController.swift
//  SeeFood
//
//  Created by Tommi Rautava on 07/08/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import CoreML
import UIKit
import Vision

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var resultText: UITextField!

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }

    func detect(ciImage: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Could not initialize a CoreML model.")
        }

        let request = VNCoreMLRequest(model: model, completionHandler: processResults)

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])

        do {
            try handler.perform([request])
        } catch {
            fatalError("Failed to process an image analysis request: \(error)")
        }
    }


    func processResults(_ request: VNRequest, _ error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else {
            fatalError("A model request failed: \(error?.localizedDescription ?? "")")
        }

        if let firstResult = results.first {
            resultText.text = firstResult.identifier

            let isHotdog = firstResult.identifier.contains("hotdog")

            if isHotdog {
                navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                self.navigationItem.title = "Hotdog"
            } else {
                navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                self.navigationItem.title = "Not hotdog"
            }

            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[.originalImage] as? UIImage {
            imageView.image = userPickedImage

            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }

            detect(ciImage: ciImage)
        }

        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate {
}
