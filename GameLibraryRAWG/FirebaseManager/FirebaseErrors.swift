//
//  FirebaseErrors.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 12.09.2022.
//

import Foundation

enum FirebaseErrors: Error {
    case UserNotFound
    case ErrorCreateUser
    
    case ErrorGetUserName
    case ErrorGetUserImage
    case ErrorGetGames
    
    case ErrorUploadDisplayName
    case ErrorUploadImageToStorage
    
    case ErrorAddGame
    case ErrorDeleteGame
}
