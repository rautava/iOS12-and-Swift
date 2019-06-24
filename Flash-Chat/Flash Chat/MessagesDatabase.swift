//
//  MessagesDatabase.swift
//  Flash Chat
//
//  Created by Tommi Rautava on 28/06/2019.
//  Copyright © 2019 Tommi Rautava. All rights reserved.
//

import FirebaseDatabase
import Foundation

fileprivate let MESSAGES_DATABASE_NAME = "Messages"

enum MessageEventType {
    case Added
    case Removed
}

protocol MessagesDatabaseDelegate {
    func messageChanged(eventType: MessageEventType, message: Message)
}

class MessagesDatabase {
    private var db: DatabaseReference?
    private var childAddedHandle: UInt?
    private var childRemovedHandle: UInt?

    var delegate: MessagesDatabaseDelegate?

    init() {
        db = Database.database().reference().child(MESSAGES_DATABASE_NAME)
        childAddedHandle = db?.observe(.childAdded, with: onChildAdded)
        childRemovedHandle = db?.observe(.childRemoved, with: onChildRemoved)
    }

    deinit {
        db?.removeObserver(withHandle: childAddedHandle!)
        db?.removeObserver(withHandle: childRemovedHandle!)
    }

    private func onChildAdded(snapshot: DataSnapshot)
    {
        let value = snapshot.value as! Dictionary<String, String>
        let messageId = snapshot.key
        let senderUid = value["uid"]
        let messageBody = value["MessageBody"]

        let message = Message(messageId: messageId, senderUid: senderUid, messageBody: messageBody)

        delegate?.messageChanged(eventType: .Added, message: message)
    }

    private func onChildRemoved(snapshot: DataSnapshot) {
        let message = Message(messageId: snapshot.key)

        delegate?.messageChanged(eventType: .Removed, message: message)
    }

    func sendMessage(
        senderUid: String,
        messageBody: String,
        completion: @escaping (Error?, DatabaseReference) -> Void
    ) {
        let data = ["uid": senderUid, "MessageBody": messageBody]

        db?.childByAutoId().setValue(data, withCompletionBlock: completion)
    }

    func deleteMessage(messageId: String) {
        db?.child(messageId).setValue(nil)
    }
}
