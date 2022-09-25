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
    
    //MARK: User registration and changing
    func createUser(email: String, password: String) async throws -> FirebaseResults {
        
        return try await withCheckedThrowingContinuation { continuation in
            auth.createUser(withEmail: email, password: password) { result, error in
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
            auth.signIn(withEmail: email, password: password) { result, error in
                
                guard error == nil else {
                    continuation.resume(with: .failure(FirebaseErrors.UserNotFound))
                    return
                }
                
                continuation.resume(with: .success(FirebaseResults.UserSigned))
            }
        }
    }
    
    func addImageToStorage(imageData: Data) async throws -> FirebaseResults {
        guard let uid = auth.currentUser?.uid else {
            throw FirebaseErrors.UserNotFound
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        return try await withCheckedThrowingContinuation { continuation in
            storage.reference().child("Users Images/\(uid)/userAvatar.jpg").putData(imageData, metadata: metadata) { metadata1, error in
                guard error == nil else {
                    continuation.resume(with: .failure(FirebaseErrors.ErrorUploadImageToStorage))
                    return
                }
                
                continuation.resume(with: .success(FirebaseResults.UserImageUploaded))
            }
        }
    }
    
    func createUserName(displayName: String) async throws -> FirebaseResults {
        guard let uid = auth.currentUser?.uid else {
            throw FirebaseErrors.UserNotFound
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            firestore.collection("Users").document(uid).setData(["user_name": displayName]) { error in
                guard error == nil else {
                    continuation.resume(with: .failure(FirebaseErrors.ErrorUploadDisplayName))
                    return
                }
                
                continuation.resume(with: .success(FirebaseResults.UserNameUploaded))
            }
        }
    }
    
    //MARK: User add and delete game
    func addGameToFavourite(add game: Game) async throws -> FirebaseResults {
        guard let uid = auth.currentUser?.uid else {
            throw FirebaseErrors.UserNotFound
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            try? firestore.collection("Users").document(uid).collection("Games").document(game.name).setData(from: game) { error in
                guard error == nil else {
                    continuation.resume(with: .failure(FirebaseErrors.ErrorAddGame))
                    return
                }
                
                continuation.resume(with: .success(FirebaseResults.GameAdded))
            }
        }
    }
    
    func deleteGameFromFavourite(delete game: Game) async throws -> FirebaseResults {
        guard let uid = auth.currentUser?.uid else {
            throw FirebaseErrors.UserNotFound
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            firestore.collection("Users").document(uid).collection("Games").document(game.name).delete() { error in
                guard error == nil else {
                    continuation.resume(with: .failure(FirebaseErrors.ErrorDeleteGame))
                    return
                }
                
                continuation.resume(with: .success(FirebaseResults.GameDeleted))
            }
        }
    }
    
    //MARK: check game existing in firestore
    func fetchGameFromFirestore(game: Game) async throws -> Bool {
        guard let uid = auth.currentUser?.uid else {
            throw FirebaseErrors.UserNotFound
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            firestore.collection("Users").document(uid).collection("Games").document(game.name).getDocument { snapshot, error in
                guard error == nil else {
                    continuation.resume(with: .failure(FirebaseErrors.ErrorWhenFindindGame))
                    return
                }
                
                if let snapshot = snapshot {
                    if snapshot.exists {
                        continuation.resume(with: .success(true))
                    } else {
                        continuation.resume(with: .success(false))
                    }
                }
            }
        }
    }
    
    //MARK: Fetch firestore data
    func fetchFirestoreData() async throws -> [Game] {
        guard let uid = auth.currentUser?.uid else {
            throw FirebaseErrors.UserNotFound
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            firestore.collection("Users").document(uid).collection("Games").getDocuments { snapshot, error in
                guard error == nil, snapshot == snapshot else {
                    continuation.resume(with: .failure(FirebaseErrors.ErrorGetGames))
                    return
                }
                
                let results = snapshot!.documents.map { doc in
                    return Game(name: doc["name"] as? String ?? "",
                                slug: doc["slug"] as? String ?? "",
                                background_image: doc["background_image"] as? String ?? "",
                                metacritic: doc["metacritic"] as? Int)
                }
                
                continuation.resume(with: .success(results))
            }
        }
        
    }
    
    func fetchUserImage() async throws -> Data {
        guard let uid = auth.currentUser?.uid else {
            throw FirebaseErrors.UserNotFound
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let tenMB = 10 * 1024 * 1024
            storage.reference().child("Users Images/\(uid)/userAvatar.jpg").getData(maxSize: Int64(tenMB)) { data, error in
                guard error == nil, data == data else {
                    continuation.resume(with: .failure(FirebaseErrors.ErrorGetUserImage))
                    return
                }
                
                continuation.resume(with: .success(data ?? Data()))
            }
        }
    }
    
    func fetchUserNameDisplay() async throws -> String {
        guard let uid = auth.currentUser?.uid else {
            throw FirebaseErrors.UserNotFound
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            firestore.collection("Users").document(uid).getDocument { snapshot, error in
                guard error == nil, snapshot == snapshot else {
                    continuation.resume(with: .failure(FirebaseErrors.ErrorGetUserName))
                    return
                }
                
                let data = snapshot!.get("user_name") as? String ?? "Unknown"
                
                continuation.resume(with: .success(data))
            }
        }
    }
    
}
