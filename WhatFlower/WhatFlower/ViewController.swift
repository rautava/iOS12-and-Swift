//
//  ViewController.swift
//  WhatFlower
//
//  Created by Tommi Rautava on 12/08/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import CoreML
import SDWebImage
import UIKit
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!

    @IBOutlet var resultText: UILabel!

    @IBOutlet weak var wikipediaText: UILabel!

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
    }

    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true)
    }

    func fetchWikipediaData() {
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        navigationItem.title = nil
        wikipediaText.text = nil

        if let image = info[.originalImage] as? UIImage {
            imageView.image = image

            guard let ciImage = CIImage(image: image) else {
                fatalError("UIIMage to CIImage conversion failed")
            }

            detect(ciImage: ciImage)
        }
    }

    func detect(ciImage: CIImage) {
        guard let model = try? VNCoreMLModel(for: oxford102().model) else {
            fatalError("Failed to create a core model.")
        }

        let request = VNCoreMLRequest(model: model) {
            request, error in

            DispatchQueue.main.async {
                self.handleImageRequestResponse(request, error)
            }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)

        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

    func handleImageRequestResponse(_ request: VNRequest, _ error: Error?) {
        if let error = error {
            print(error)
            return
        }

        let observations = (request.results as? [VNClassificationObservation])?.filter({ $0.confidence > 0.1 })

        let firstClassification = observations?.first?.identifier
        let classifications = observations?.map({ "\(Int($0.confidence * 100))% \($0.identifier)" }).joined(separator: ", ")

        navigationItem.title = firstClassification
        resultText.text = classifications

        if let firstClassification = firstClassification {
            Wikipedia.fetchArticle(query: firstClassification) { text, imageUrl in
                self.wikipediaText.text = text
                self.imageView.sd_setImage(with: URL(string: imageUrl ?? ""), completed: nil)
            }
        }
    }
}
