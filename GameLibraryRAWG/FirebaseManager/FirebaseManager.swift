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
    
    func getUserProfileData(onCompletion: @escaping (Result<GameFavouritesProfileViewModel, Error>) -> Void) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            onCompletion(.failure(FirebaseErrors.UserNotFound))
            return
        }
        
        FirebaseManager.shared.firestore.collection("Users").document(uid).getDocument { snapshot, error in
            guard error == nil, snapshot == snapshot else {
                onCompletion(.failure(FirebaseErrors.ErrorGetUserDocuments))
                return
                
            }
            
            
            print("loh test 228")
            let dataName = snapshot!.get("user_name") as? String ?? "Unknown"
            
            FirebaseManager.shared.storage.reference().child("Users Images/\(uid)/userAvatar.jpg").downloadURL { url, error in
                
                guard error == nil else { print("error url"); return }
                
                let model = GameFavouritesProfileViewModel(profileName: dataName, gamesCount: 0, imageData: url!)
                
                onCompletion(.success(model))
            }
        }
    }
    
}




