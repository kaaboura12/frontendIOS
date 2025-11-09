//
//  ChatMessage.swift
//  weldiwinfrontend
//
//  Created by sayari amin on 9/11/2025.
//


import Foundation

struct ChatMessage: Identifiable, Codable {
    let id: String
    let text: String
    let senderId: String
    let senderName: String
    let timestamp: Date
    var isFromCurrentUser: Bool = false

    init(id: String = UUID().uuidString,
         text: String,
         senderId: String,
         senderName: String,
         timestamp: Date = Date(),
         isFromCurrentUser: Bool = false) {
        self.id = id
        self.text = text
        self.senderId = senderId
        self.senderName = senderName
        self.timestamp = timestamp
        self.isFromCurrentUser = isFromCurrentUser
    }
}