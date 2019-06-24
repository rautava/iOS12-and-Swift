//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class RegisterViewController: UIViewController {
    // Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func registerPressed(_: AnyObject) {

        SVProgressHUD.show()

        let email = emailTextfield.text ?? ""
        let password = passwordTextfield.text ?? ""

        User.addUser(email: email, password: password) {
            (authDataResult, error) in

            SVProgressHUD.dismiss()

            if let error = error {
                print(error.localizedDescription)
                return
            }

            self.performSegue(withIdentifier: "goToChat", sender: self)
        }
    }
}
