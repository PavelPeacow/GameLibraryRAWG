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
import FirebaseStorage

class FirebaseManager {
    static let shared = FirebaseManager()
    
    let auth = FirebaseAuth.Auth.auth()
    let firestore = Firestore.firestore()
    let storage = FirebaseStorage.Storage.storage()
    
    func createUser(email: String, password: String, onCompletion: @escaping (Result<FirebaseResults, FirebaseErrors>) -> Void) {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                onCompletion(.failure(.ErrorCreateUser))
                return
            }
            
            onCompletion(.success(.UserCreated))
        }
    }
    
    func authUser(email: String, password: String, onCompletion: @escaping (Result<FirebaseResults, FirebaseErrors>) -> Void) {
        
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
 
            guard error == nil else {
                onCompletion(.failure(.UserNotFound))
                return
            }
            
            onCompletion(.success(.UserSigned))
        }
    }
    
    func addImageToStorage(imageData: Data, onCompletion: @escaping (Result<FirebaseResults, FirebaseErrors>) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            onCompletion(.failure(.UserNotFound))
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        FirebaseManager.shared.storage.reference().child("Users Images/\(uid)/userAvatar.jpg").putData(imageData, metadata: metadata) { metadata, error in
            guard error == nil else {
                onCompletion(.failure(.ErrorPutImageToStorage))
                return
            }
            
            onCompletion(.success(.UserImageUploaded))
        }
    }
    
    func createUserName(displayName: String, onCompletion: @escaping (Result<FirebaseResults, FirebaseErrors>) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            onCompletion(.failure(.UserNotFound))
            return
        }
        
        FirebaseManager.shared.firestore.collection("Users").document(uid).setData(["user_name": displayName]) { error in
            guard error == nil else {
                onCompletion(.failure(.ErrorCreateDocument))
                return
            }
            
            onCompletion(.success(.UserNameUploaded))
        }
    }
        
    func fetchFirestoreData(onCompletion: @escaping (Result<[Game], FirebaseErrors>) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            onCompletion(.failure(.UserNotFound))
            return
        }
        
        FirebaseManager.shared.firestore.collection("Users").document(uid).collection("Games").getDocuments { snapshot, error in
            guard error == nil, snapshot == snapshot else {
                onCompletion(.failure(.ErrorGetUserDocuments))
                return
            }
            
            var results = [Game]()
            
            results = snapshot!.documents.map { doc in
                return Game(name: doc["name"] as? String ?? "",
                            slug: doc["slug"] as? String ?? "",
                            background_image: doc["background_image"] as? String ?? "",
                            metacritic: doc["metacritic"] as? Int)
            }
            
            onCompletion(.success(results))
        }
    }
    
    func fetchUserImage(onCompletion: @escaping (Result<URL, FirebaseErrors>) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            onCompletion(.failure(.UserNotFound))
            return
        }
        
        FirebaseManager.shared.storage.reference().child("Users Images/\(uid)/userAvatar.jpg").downloadURL { url, error in
            
            guard error == nil, url == url else {
                onCompletion(.failure(.ErrorGetUserDocuments))
                return
            }
            
            onCompletion(.success(url!))
        }
    }
    
    func fetchUserNameDisplay(onCompletion: @escaping (Result<String, FirebaseErrors>) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            onCompletion(.failure(.UserNotFound))
            return
        }
        
        FirebaseManager.shared.firestore.collection("Users").document(uid).getDocument { snapshot, error in
            guard error == nil, snapshot == snapshot else {
                onCompletion(.failure(.ErrorGetUserDocuments))
                return
            }
            
            var data: String = ""
            
            data = snapshot!.get("user_name") as? String ?? "Unknown"
            
            onCompletion(.success(data))
        }
    }
    
}
