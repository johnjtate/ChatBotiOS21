//
//  ChatController.swift
//  ChatbotiOS21
//
//  Created by John Tate on 9/5/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import Foundation

// 1) Know what you are completing with for your function signature (the function declaration)
// 2) URLSession
// 3) ^ Get your baseURL
// 4) ^ Build that url
// 5) Data or Error from URLSession

class ChatController {
    
    // MARK: - Properties
    var chats: [Chat] = []
    let baseURL = URL(string: "https://messageing-app-f734a.firebaseio.com/")
    
    enum HttpProtocol: String {
        case put = "PUT"
        case get = "GET"
    }
    
    func putChat(message: String, completion: @escaping (_ success: Bool) -> Void) {
        // create an instance of chat
        let chat = Chat(message: message)
        guard let url = baseURL?.appendingPathComponent(chat.uuid).appendingPathExtension("json") else {
            fatalError("bad built url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpProtocol.put.rawValue

        let jsonEncoder = JSONEncoder()
        do {
            // Encoding our instance into data
            let data = try jsonEncoder.encode(chat)
            // now our request has data
            // This is a protocol that defines what we want to do with our data
            request.httpBody = data
        } catch let error {
            print("Error with JSONEncoder for chat: \(error) \(error.localizedDescription)")
        }
        
        // DataTask with urlRequest DOES NOT have a defined HTTP protocol
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error with PUT request: \(error) \(error.localizedDescription)")
                completion(false); return
            }
            
            // THIS IS JUST FOR THE DEVELOPER.  We don't have to do this, but it's very good error handling.
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else { completion(false); return }
            print(responseString)
            
            // This will connect our local array (SOURCE OF TRUTH) to the instance that we sent up to Firebase.
            print("Is this chat on the main thread? \(Thread.isMainThread)")
            self.chats.append(chat)
            
            // @escaping is going to escape out of the function and complete at a later time.  It completes when the information comes back.
            completion(true)
    
        }.resume()
    }
    
    func fetchChat(completion: @escaping (_ success: Bool) -> Void) {
        
        guard let url = baseURL else {
            fatalError("bad base url")
        }
        
        let builtURL = url.appendingPathExtension("json")
        
        var request = URLRequest(url: builtURL)
        request.httpMethod = HttpProtocol.get.rawValue
        // because we are not posting a body to a server
        request.httpBody = nil
        
        // Because we are fetching, dataTask with URL has GET built in it.  So USE it.  Right now this is how we do 'GET' (more practice - go team).
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error fetching with dataTask \(error) \(error.localizedDescription)")
                completion(false); return
            }
            
            guard let data = data else { completion(false); return }
            
            do {
                let jsonDecoder = JSONDecoder()
                let chatsDictionary = try jsonDecoder.decode([String : Chat].self, from: data)
                
                let chats = chatsDictionary.compactMap({$0.value})
                // connect the chats that came back to OUR SOURCE OF TRUTH
                self.chats = chats
                completion(true)
                
            } catch let error {
                print("Error decoding chats \(error) \(error.localizedDescription)")
                completion(false); return
            }
        }.resume()
    }
}
