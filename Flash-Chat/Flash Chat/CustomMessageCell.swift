//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Angela Yu on 30/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

protocol CustomMessageCellDelegate {
    func deleteMessage(messageId: String)
}

class CustomMessageCell: UITableViewCell {
    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!

    var delegate: CustomMessageCellDelegate?
    var messageId: String?

    @IBAction func deleteButtonPushed(_ sender: UIButton) {
        if let messageId = messageId {
            delegate?.deleteMessage(messageId: messageId)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
    }
}
