//
//  ViewController.swift
//  SeeFood2
//
//  Created by Tommi Rautava on 07/08/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import RestKit
import Social
import SVProgressHUD
import UIKit
import VisualRecognition

class ViewController: UIViewController {
    @IBOutlet var mainImageView: UIImageView!

    @IBOutlet var topImageView: UIImageView!

    @IBOutlet var cameraButton: UIBarButtonItem!

    @IBOutlet var shareButton: UIButton!

    @IBOutlet var resultText: UILabel!

    let imagePicker = UIImagePickerController()

    let apiKey: String = getApiKey(name: "apiKey") ?? ""
    let version: String = "2019-08-07"

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self

        shareButton.isHidden = true
        shareButton.layer.cornerRadius = 15
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        setTitleBarLooks()
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false

        present(imagePicker, animated: true, completion: nil)
    }

    /*
     - SeeAlso: https://stackoverflow.com/a/35931947
     */
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        // image to share
        let image = mainImageView.image

        // set up activity view controller
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    func setTitleBarLooks(title: String? = nil, textColor: UIColor? = nil, bgColor: UIColor? = nil, image: UIImage? = nil) {
        navigationItem.title = title ?? "Take a picture →"
        navigationController?.navigationBar.tintColor = .white
        let titleTextSize: CGFloat = (title == nil) ? 20 : 35
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: textColor ?? UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: titleTextSize),
        ]
        navigationController?.navigationBar.barTintColor = bgColor ?? #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        topImageView.image = image
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            SVProgressHUD.show(withStatus: "Evaluating...")
            cameraButton.isEnabled = false

            mainImageView.image = image
            resultText.text = nil

            let jpegData = image.jpegData(compressionQuality: 0.1)

            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)

            visualRecognition.classify(imagesFile: jpegData) {
                response, error in
                DispatchQueue.main.async { self.recognitionCompletionHandler(response, error) }
            }
        }
    }

    func recognitionCompletionHandler(_ response: RestResponse<ClassifiedImages>?, _ error: WatsonError?) {
        SVProgressHUD.dismiss()
        cameraButton.isEnabled = true

        if let error = error {
            self.resultText.text = error.localizedDescription
            return
        }

        guard let classes = response?.result?.images.first?.classifiers.first?.classes else {
            return
        }

        let resultText = classes.map({ $0.className }).joined(separator: ", ")
        self.resultText.text = resultText

        let isHotdog = resultText.contains("hotdog")
        updateNavigationBar(isHotdog)

        shareButton.isHidden = false
    }

    func updateNavigationBar(_ isHotdog: Bool) {
        isHotdog
            ? setTitleBarLooks(title: "Hotdog", textColor: .yellow, bgColor: #colorLiteral(red: 0.166972518, green: 0.9931097627, blue: 0.00595512148, alpha: 1), image: UIImage(named: "hotdog"))
            : setTitleBarLooks(title: "Not hotdog", textColor: .yellow, bgColor: #colorLiteral(red: 0.9045106769, green: 0.2475692928, blue: 0.2026289999, alpha: 1), image: UIImage(named: "not-hotdog"))
    }
}

extension ViewController: UINavigationControllerDelegate {
}
