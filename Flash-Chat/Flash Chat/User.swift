//
//  User.swift
//  Flash Chat
//
//  Created by Tommi Rautava on 27/06/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase
import Foundation

fileprivate let USERS_DATABASE_NAME: String = "Users"

class User {
    var uid: String = ""
    var displayName: String = ""
    var avatarImage: UIImage? = UIImage(named: "egg")

    init(uid: String, displayName: String, avatarImage: UIImage? = nil) {
        self.uid = uid
        self.displayName = displayName

        if let avatarImage = avatarImage {
            self.avatarImage = avatarImage
        }
    }

    static func addUser(email: String, password: String, completion: @escaping AuthDataResultCallback)
    {
        Auth.auth().createUser(withEmail: email, password: password) {
            (authDataResult, error) in

            if error == nil {
                if let uid = authDataResult?.user.uid {
                    let database = Database.database().reference().child(USERS_DATABASE_NAME)
                    let data = ["DisplayName": email]
                    database.child(uid).setValue(data)
                }
            }

            completion(authDataResult, error)
        }
    }

    static func getUsers(with: @escaping (User) -> Void) {
        let database = Database.database().reference().child(USERS_DATABASE_NAME)

        database.observe(.childAdded) {
            snapshot in

            let value = snapshot.value as! Dictionary<String, String>
            let uid = snapshot.key
            let displayName = value["DisplayName"] ?? ""
            with(User(uid: uid, displayName: displayName))
        }
    }
}
