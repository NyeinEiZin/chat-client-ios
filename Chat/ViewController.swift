//
//  ViewController.swift
//  Chat
//
//  Created by Nyein Ei Ei Zin on 11/06/2020.
//  Copyright © 2020 Nyein Ei Ei Zin. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.nameTextField.delegate = self
        self.nameTextField.becomeFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chatVC = segue.destination as! ChatViewController
        chatVC.myName = nameTextField.text!
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        performSegue(withIdentifier: "chat", sender: self)
        return true
    }
}

