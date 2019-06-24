//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController {
    fileprivate func setChatView() {
        performSegue(withIdentifier: "goToChat", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = Auth.auth().currentUser {
            setChatView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
