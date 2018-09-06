//
//  ChatViewController.swift
//  ChatbotiOS21
//
//  Created by John Tate on 9/5/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var chatTextField: UITextView!
    @IBOutlet weak var catLabel: UILabel!
    
    // We are not using a sharedInstance so we have to creat an instance outside of its class.  But within where we want to use it.
    let chatController = ChatController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    @IBAction func sendChatButtonTapped(_ sender: Any) {
        
        guard let message = chatTextField.text, message != "" else { return }
        
        chatController.putChat(message: message) { (success) in
            if success {
                // do something
                DispatchQueue.main.async {
                        self.chatTextField.text = ""
                        print("Went to firebase")
                }
            } else {
                DispatchQueue.main.async {
                        // do something else
                        self.catLabel.text = "🤮"
                }
            }
        }
    }
    
    
    
    
}
