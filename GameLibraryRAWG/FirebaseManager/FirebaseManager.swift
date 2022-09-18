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
    
    func fetchFirestoreData(onCompletion: @escaping (Result<[Game], Error>) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            onCompletion(.failure(FirebaseErrors.UserNotFound))
            return
        }
        
        FirebaseManager.shared.firestore.collection("Users").document(uid).collection("Games").getDocuments { snapshot, error in
            guard error == nil, snapshot == snapshot else {
                print(FirebaseErrors.ErrorGetUserDocuments)
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
    
    func fetchUserImage(onCompletion: @escaping (Result<URL, Error>) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            onCompletion(.failure(FirebaseErrors.UserNotFound))
            return
        }
        
        FirebaseManager.shared.storage.reference().child("Users Images/\(uid)/userAvatar.jpg").downloadURL { url, error in
            
            guard error == nil, url == url else {
                onCompletion(.failure(FirebaseErrors.ErrorGetUserDocuments))
                return
            }
            
            onCompletion(.success(url!))
        }
    }
    
    func fetchUserNameDisplay(onCompletion: @escaping (Result<String, Error>) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            onCompletion(.failure(FirebaseErrors.UserNotFound))
            return
        }
        
        FirebaseManager.shared.firestore.collection("Users").document(uid).getDocument { snapshot, error in
            guard error == nil, snapshot == snapshot else {
                onCompletion(.failure(FirebaseErrors.ErrorGetUserDocuments))
                return
            }
            
            var data: String = ""
            
            data = snapshot!.get("user_name") as? String ?? "Unknown"
            
            onCompletion(.success(data))
        }
    }
    
    func createUser(email: String, password: String, onCompletion: @escaping (Result<FirebaseUploadResults, FirebaseErrors>) -> Void) {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                onCompletion(.failure(.ErrorCreateUser))
                return
            }
            
            onCompletion(.success(.UserCreated))
        }
    }
    
    func addImageToStorage(imageData: Data, onCompletion: @escaping (Result<FirebaseUploadResults, FirebaseErrors>) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            onCompletion(.failure(FirebaseErrors.UserNotFound))
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        FirebaseManager.shared.storage.reference().child("Users Images/\(uid)/userAvatar.jpg").putData(imageData, metadata: metadata) { metadata, error in
            guard error == nil else {
                onCompletion(.failure(.ErrorPutImageToStorage))
                return
            }
            
            onCompletion(.success(.UserNameUploaded))
        }
    }
    
    func createUserName(displayName: String, onCompletion: @escaping (Result<FirebaseUploadResults, FirebaseErrors>) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            onCompletion(.failure(FirebaseErrors.UserNotFound))
            return
        }
        
        FirebaseManager.shared.firestore.collection("Users").document(uid).setData(["user_name": displayName]) { error in
            guard error == nil else {
                onCompletion(.failure(FirebaseErrors.ErrorCreateDocument))
                return
            }
            
            onCompletion(.success(.UserNameUploaded))
        }
    }
    
}
