//
//  Messages.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-06-24.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation

class Messages {
    
    var recieverID = String()
    var messageID = String()
    var senderID = String()
    var messageURL = String()
    
    init(recieverID: String, messageID: String, senderID: String, messageURL: String) {
        self.recieverID = recieverID
        self.messageID = messageID
        self.senderID = senderID
        self.messageURL = messageURL
    }
    
    
}
