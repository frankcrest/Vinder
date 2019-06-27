//
//  Messages.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-24.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation
import UIKit

class Messages {
    
    var sender = String()
    var messageID = String()
    var senderID = String()
    var messageURL = String()
    var timestamp = Date()
    var imageURL = String()
    var thumbnail: UIImage?
    
    init(messageID: String, senderID: String, messageURL: String, sender: String, timestamp: Date, imageURL: String) {
        
        self.messageID = messageID
        self.senderID = senderID
        self.messageURL = messageURL
        self.sender = sender
        self.timestamp = timestamp
        self.imageURL = imageURL
    }
    
}
