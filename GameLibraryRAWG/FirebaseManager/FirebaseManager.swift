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
    
    func createUser(email: String, password: String) async throws -> FirebaseResults {
        
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
                guard error == nil else {
                    continuation.resume(with: .failure(FirebaseErrors.ErrorCreateUser))
                    return
                }
                
                continuation.resume(with: .success(FirebaseResults.UserCreated))
            }
        }
    }
    
    func authUser(email: String, password: String) async throws -> FirebaseResults {
        
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
                
                guard error == nil else {
                    continuation.resume(with: .failure(FirebaseErrors.UserNotFound))
                    return
                }
                
                continuation.resume(with: .success(FirebaseResults.UserSigned))
            }
        }
    }
    
    func addImageToStorage(imageData: Data) async throws -> FirebaseResults {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            throw FirebaseErrors.UserNotFound
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseManager.shared.storage.reference().child("Users Images/\(uid)/userAvatar.jpg").putData(imageData, metadata: metadata) { metadata1, error in
                guard error == nil else {
                    continuation.resume(with: .failure(FirebaseErrors.ErrorPutImageToStorage))
                    return
                }
                
                continuation.resume(with: .success(FirebaseResults.UserImageUploaded))
            }
        }
    }
    
    func createUserName(displayName: String) async throws -> FirebaseResults {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            throw FirebaseErrors.UserNotFound
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            FirebaseManager.shared.firestore.collection("Users").document(uid).setData(["user_name": displayName]) { error in
                guard error == nil else {
                    continuation.resume(with: .failure(FirebaseErrors.ErrorCreateDocument))
                    return
                }
                
                continuation.resume(with: .success(FirebaseResults.UserNameUploaded))
            }
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
