//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login

import UIKit
import FirebaseAuth
import SVProgressHUD

class LogInViewController: UIViewController {
    // Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func logInPressed(_: AnyObject) {

        SVProgressHUD.show()

        Auth.auth().signIn(withEmail: emailTextfield.text ?? "", password: passwordTextfield.text ?? "") { (authDataResult, error) in

            SVProgressHUD.dismiss()

            if let error = error {
                SVProgressHUD.setStatus(error.localizedDescription)
                return
            }

            self.performSegue(withIdentifier: "goToChat", sender: self)
        }
    }
}
