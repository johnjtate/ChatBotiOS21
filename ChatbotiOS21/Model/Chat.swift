//
//  Chat.swift
//  ChatbotiOS21
//
//  Created by John Tate on 9/5/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import Foundation

struct Chat: Codable {
    
    let message: String
    let uuid: String = UUID().uuidString
}
