//
//  ChatTableViewController.swift
//  ChatbotiOS21
//
//  Created by John Tate on 9/5/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        chatController.fetchChat { (success) in
            if success {
                // if it does work, we want to reload the data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.navigationController?.title = "No Chats"
                }
            }
        }
    }
    
    let chatController = ChatController()
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatController.chats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        
        let chat = chatController.chats[indexPath.row]
        cell.textLabel?.text = chat.message
        

        return cell
    }
}
