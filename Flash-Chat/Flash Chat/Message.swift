//
//  Message.swift
//  Flash Chat
//
//  This is the model class that represents the blueprint for a message

class Message {
    var messageId: String = ""
    var uid: String?
    var messageBody: String?

    init(messageId: String, senderUid: String? = nil, messageBody: String? = nil) {
        self.messageId = messageId
        self.uid = senderUid
        self.messageBody = messageBody
    }
}
