//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import ChameleonFramework
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD
import UIKit

class ChatViewController: UIViewController {
    var userDict: Dictionary<String, User> = [:]
    var messagesDatabase: MessagesDatabase?
    var messageArray: [Message] = []

    // We've pre-linked the IBOutlets
    @IBOutlet var composeViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var messageTableViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // messageTableView.delegate = self
        messageTableView.dataSource = self

        messageTextfield.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        let uiNib = UINib(nibName: "MessageCell", bundle: nil)
        messageTableView.register(uiNib, forCellReuseIdentifier: "customMessageCell")

        configureTableView()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)

        User.getUsers(with: onUser)

        messagesDatabase = MessagesDatabase()
        messagesDatabase?.delegate = self
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }

    func configureTableView() {
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120
        messageTableView.separatorStyle = .none
        messageTableView.scrollToBottomRow()
    }

    // MARK: - Send & Receive from Firebase

    @IBAction func sendPressed(_: AnyObject) {
        sendMessage()
    }

    func sendMessage() {
        SVProgressHUD.show()

        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false

        let senderUid = Auth.auth().currentUser?.uid ?? ""
        let messageBody = messageTextfield.text ?? ""

        messagesDatabase?.sendMessage(senderUid: senderUid, messageBody: messageBody) {
            error, _ in

            SVProgressHUD.dismiss()

            if let error = error {
                print(error.localizedDescription)
            } else {
                self.messageTextfield.text = ""
            }

            self.messageTextfield.isEnabled = true
            self.sendButton.isEnabled = true
        }
    }

    func onUser(_ user: User) {
        userDict[user.uid] = user
        messageTableView.reloadData()
        // print("\(user.uid)=\(user.displayName)")
    }

    func onMessageAdded(_ message: Message) {
        messageArray.append(message)
        configureTableView()
        messageTableView.reloadData()
        // print(message.messageBody)
    }

    func onMessageRemoved(_ removedMessage: Message) {
        let index = messageArray.firstIndex { (message) -> Bool in
            return message.messageId == removedMessage.messageId
        }

        if let index = index {
            messageArray.remove(at: index)
            configureTableView()
            messageTableView.reloadData()
        }
    }

    @IBAction func logOutPressed(_: AnyObject) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Sign out failed")
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell

        cell.delegate = self

        let message = messageArray[indexPath.row]
        cell.messageBody.text = message.messageBody

        let user = userDict[message.uid!]
        cell.senderUsername.text = user?.displayName ?? message.uid

        cell.avatarImageView.image = user?.avatarImage

        cell.messageId = message.messageId

        if message.uid == Auth.auth().currentUser?.uid {
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } else {
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
}

extension ChatViewController: UITextFieldDelegate {
    /**
     Adjust the compose area position when the keyboard is shown/hidden.

     - Parameter notification: keyboardWillShowNotification / keyboardWillHideNotification

     - SeeAlso: [Source](https://stackoverflow.com/a/29488420/3174423)
     */
    @objc func keyboardNotification(notification: NSNotification) {
        let isShowing = notification.name == UIResponder.keyboardWillShowNotification

        var tabbarHeight: CGFloat = 0

        if tabBarController != nil {
            tabbarHeight = tabBarController!.tabBar.frame.height
        }

        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0

            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)

            composeViewBottomConstraint?.constant = isShowing ? (endFrame!.size.height - tabbarHeight) : 0

            UIView.animate(
                withDuration: duration,
                delay: TimeInterval(0),
                options: animationCurve,
                animations: {
                    self.view.layoutIfNeeded()
                    self.messageTableView.scrollToBottomRow()
                },
                completion: nil)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .send {
            sendMessage()
            return false
        }

        return true
    }
}

extension ChatViewController: MessagesDatabaseDelegate {
    func messageChanged(eventType: MessageEventType, message: Message) {
        switch eventType {
        case .Added:
            onMessageAdded(message)
        case .Removed:
            onMessageRemoved(message)
        }
    }
}

extension ChatViewController: CustomMessageCellDelegate {
    func deleteMessage(messageId: String) {
        messagesDatabase?.deleteMessage(messageId: messageId)
    }
}

/**
 Scroll to bottom of a UI table view.

 - SeeAlso: [Source](https://stackoverflow.com/a/51940222/3174423)
 */
extension UITableView {
    func scrollToBottomRow() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }

            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)

            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)

                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }

            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            guard self.indexPathIsValid(indexPath) else { return }

            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < numberOfSections && row < numberOfRows(inSection: section)
    }
}
