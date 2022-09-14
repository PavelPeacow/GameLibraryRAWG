//
//  FirebaseErrors.swift
//  GameLibraryRAWG
//
//  Created by Павел Кай on 12.09.2022.
//

import Foundation

enum FirebaseErrors: Error {
    case UserNotFound
    case ErrorCreateDocument
    case ErrorDeleteDocument
    case ErrorCreateUser
    case ErrorGetUserDocuments
    case ErrorChangeDisplayName
}
