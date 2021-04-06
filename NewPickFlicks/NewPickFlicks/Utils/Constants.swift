//
//  Constants.swift
//  NewPickFlicks
//
//  Created by John Padilla on 3/17/21.
//

import Firebase
import FirebaseFirestore

let COLLECTION_USERS = Firestore.firestore().collection("Users")

let COLLECTION_FOLLOWERS = Firestore.firestore().collection("Followers")
let COLLECTION_FOLLOWINGS = Firestore.firestore().collection("Followings")

let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("Notifications")

let COLLECTION_SESSION =    Firestore.firestore().collection("Session")
