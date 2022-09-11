//
//  FirebaseManager.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 10.09.2022.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager {
    static let shared = FirebaseManager()
    
    let auth = FirebaseAuth.Auth.auth()
    let firestore = Firestore.firestore()
}
