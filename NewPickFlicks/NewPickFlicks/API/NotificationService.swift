//
//  NotificationService.swift
//  NewPickFlicks
//
//  Created by John Padilla on 4/26/21.
//

import Firebase

struct NotificationService {
    
    static func uploadNotification(toUid uid: String, fromUser: User, type: NotificationType) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notification").document()
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "uid": fromUser.uid,
                                   "type": type.rawValue,
                                   "id": docRef.documentID,
                                   "userProfileImageUrl": fromUser.profileImageUrl,
                                   "username": fromUser.username]
        docRef.setData(data)
    }
    
    static func deleteNotification(toUid uid: String, type: NotificationType, postId: String? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NOTIFICATIONS.document(uid).collection("user-notification").whereField("uid", isEqualTo: currentUid).getDocuments { snapshot, _ in
            snapshot?.documents.forEach({ document in
                let notification = Notification(dictionary: document.data())
                guard notification.type == type else { return }
                
                document.reference.delete()
            })
        }
    }
    
    static func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query =  COLLECTION_NOTIFICATIONS.document(uid).collection("user-notification")
            .order(by: "timestamp", descending: true)
       
            query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let notifications = documents.map({ Notification(dictionary: $0.data()) })
            completion(notifications)
        }
    }
}
