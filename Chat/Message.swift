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
    var previousUserName: String?
    var message: String
    var isMe: Bool = false
    
    init(userName: String, message: String, previousUserName: String? = nil) {
        self.userName = userName
        self.message = message
        self.previousUserName = previousUserName
    }
}
