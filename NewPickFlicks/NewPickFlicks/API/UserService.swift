//
//  UserService.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/18/21.
//

import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct UserService {
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }

    static func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    private static func fetchUsers(fromCollection collection: CollectionReference, completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        collection.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            documents.forEach({ fetchUser(withUid: $0.documentID) { user in
                users.append(user)
                completion(users)
            }})
        }
    }
    
    static func fetchUsers(forConfig config: UserFilterConfig, completion: @escaping([User]) -> Void) {
        
        switch config {
        case .following(let uid):
            let ref = COLLECTION_FOLLOWINGS.document(uid).collection("user-following")
            fetchUsers(fromCollection: ref, completion: completion)
            
        case .followers(let uid):
            let ref = COLLECTION_FOLLOWERS.document(uid).collection("user-followers")
            fetchUsers(fromCollection: ref, completion: completion)
            
        case .all:
            COLLECTION_USERS.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else { return }

                let users = snapshot.documents.map ({ User(dictionary: $0.data())
                })
                completion(users)
            }
        case .messages:
            COLLECTION_USERS.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else { return }
                
                let users = snapshot.documents.map({ User(dictionary: $0.data()) })
                completion(users)
            }
        case .likes(_): break
            
        }
    }
    
    static func follow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWINGS.document(currentUid).collection("user-following").document(uid).setData([:]) { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unFollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWINGS.document(currentUid).collection("user-following").document(uid).delete { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
    
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWINGS.document(currentUid).collection("user-following").document(uid).getDocument { (snapshot, error) in
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }
    
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, _) in
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWINGS.document(uid).collection("user-following").getDocuments { (snapshot, _) in
                let following = snapshot?.documents.count ?? 0
                
//                COLLECTION_POTSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { (snapshot, _) in
//                    let posts = snapshot?.documents.count ?? 0
//                    completion(UserStats(followers: followers, following: following, posts: posts))
//                }
                completion(UserStats(followers: followers, following: following))

            }
        }
    }
    
    static func updateProfileImage(forUser user: User, image: UIImage, completion: @escaping(String?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Storage.storage().reference(withPath: user.profileImageUrl).delete(completion: nil)
        
        ImageUploader.uploadImage(image: image) { profileImageUrl in
            let data = ["profileImageUrl": profileImageUrl]
            
            COLLECTION_USERS.document(uid).updateData(data) { error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                completion(profileImageUrl, nil)
            }
        }
    }
    
    static func saveUserData(user: User,  completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = ["email": user.email, "fullname": user.fullname, "profileImageUrl1": user.profileImageUrl, "uid": uid, "username": user.username]
        COLLECTION_USERS.document(uid).setData(data, completion: completion)
    }
    
    static func setUserFCToken() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let fcmToken = Messaging.messaging().fcmToken else { return }

        COLLECTION_USERS.document(uid).updateData(["fcmToken": fcmToken])
    }
}
