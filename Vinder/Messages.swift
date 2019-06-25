//
//  Messages.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-24.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation

class Messages {
    
    var sender = String()
    var messageID = String()
    var senderID = String()
    var messageURL = String()
    
    init(messageID: String, senderID: String, messageURL: String, sender: String) {
        self.messageID = messageID
        self.senderID = senderID
        self.messageURL = messageURL
        self.sender = sender
    }
    
    
}
