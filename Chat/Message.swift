//
//  Message.swift
//  Chat
//
//  Created by Nyein Ei Ei Zin on 12/06/2020.
//  Copyright © 2020 Nyein Ei Ei Zin. All rights reserved.
//

import Foundation

class Message {
    var userName: String
    var message: String
    var device: String
    var previousMessage: Message?
    
    init(userName: String, message: String, device: String) {
        self.userName = userName
        self.message = message
        self.device = device
    }
    
    func setDefaultPreviousMessage() {
        self.previousMessage = Message(userName: "\(userName)-", message: "", device: "other device")
    }
    
    func shouldHideUsername() -> Bool {
        return userName == previousMessage?.userName && device == previousMessage?.device
    }
}
