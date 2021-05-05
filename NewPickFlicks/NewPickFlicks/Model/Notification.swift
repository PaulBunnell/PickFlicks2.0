//
//  Notification.swift
//  NewPickFlicks
//
//  Created by John Padilla on 4/23/21.
//

import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
        case .like: return " Like your post."
        case .follow: return " started following you."
        case .comment: return " commented on your post"
        }
    }
}

struct Notification {
    let uid: String
    
    var type: NotificationType
    let id: String
    let timestamp: Timestamp
    let username: String
    let userProfileImageUrl: String
    var userIsFollowed = false
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.id = dictionary["id"] as? String ?? ""
        self.userProfileImageUrl = dictionary["userProfileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
