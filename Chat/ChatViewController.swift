//
//  ChatViewController.swift
//  Chat
//
//  Created by Nyein Ei Ei Zin on 12/06/2020.
//  Copyright © 2020 Nyein Ei Ei Zin. All rights reserved.
//

import UIKit
import SocketIO

class ChatViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    var messageArray: [Message] = []
    var myName: String!
    let manager = SocketManager(socketURL: URL(string: "https://socketio-chat-h9jt.herokuapp.com")!)
    var socket: SocketIOClient!
    var userCount: Int = 0
    var currentUserName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.textField.delegate = self
        self.textField.becomeFirstResponder()
        self.socket = manager.defaultSocket
        self.registerSocketEvents()
        self.socket.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.socket.emit("disconnect")
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        sendMessage(text: textField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage(text: textField.text!)
        return true
    }
    
    func sendMessage(text: String) {
        self.socket.emit("new message", text)
        let previousUserName = messageArray.count == 0 ? nil : messageArray[0].userName
        let message = Message(userName: myName, message: textField.text!, previousUserName: previousUserName)
        message.isMe = true
        self.messageArray.insert(message, at: 0)
        tableView.reloadData()
        textField.text = ""
    }
    
    func registerSocketEvents() {
        self.socket.on(clientEvent: .connect) { data,_ in
            self.socket.emit("add user", self.myName)
        }
        
        self.socket.on("user joined") { data,_ in
            self.onUserJoinedOrLeft(data: data)
        }
        
        self.socket.on("user left") { data,_ in
            self.onUserJoinedOrLeft(data: data)
        }
        
        self.socket.on("new message") { data,_ in
            let responseMessage = data[0] as! Dictionary<String, String>
            let previousUserName = self.messageArray.count == 0 ? nil : self.messageArray[0].userName
            let message = Message(
            userName: responseMessage["username"]!, message: responseMessage["message"]!, previousUserName: previousUserName)
            message.isMe = false
            self.messageArray.insert(message, at: 0)
            self.tableView.reloadData()
        }
    }
    
    func onUserJoinedOrLeft(data: [Any]) {
        let responseData = data[0] as! Dictionary<String, Any>
        self.userCount = responseData["numUsers"] as! Int
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentMessage = messageArray[indexPath.row]
        if !currentMessage.isMe {
            let cell = tableView.dequeueReusableCell(withIdentifier: "receivedMessageCell", for: indexPath) as! ReceivedMessageCell
            cell.userName.text = currentMessage.userName
            cell.userName.isHidden = currentMessage.userName == currentMessage.previousUserName
//            cell.userName.heightAnchor.constraint(equalToConstant: cell.userName.isHidden ? 0.0 : 15.0).isActive = true
            cell.message.text = currentMessage.message
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "sendMessageCell", for: indexPath) as! SendMessageCell
        cell.message.text = currentMessage.message
        cell.userName.text = currentMessage.userName
        cell.userName.isHidden = currentMessage.userName == currentMessage.previousUserName
//        cell.userName.heightAnchor.constraint(equalToConstant: cell.userName.isHidden ? 0.0 : 15.0).isActive = true
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class ReceivedMessageCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var userNameHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        messageView.layer.cornerRadius = 20
    }
}

class SendMessageCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var userNameHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        messageView.layer.cornerRadius = 20
    }
}
