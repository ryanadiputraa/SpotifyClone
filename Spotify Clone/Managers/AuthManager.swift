//
//  AuthManager.swift
//  Spotify Clone
//
//  Created by Ryan Adi Putra on 07/12/22.
//

import Foundation

class AuthManager {
    
    static let shared = AuthManager()
    var isSignedIn: Bool {
        return false
    }
        
    private init() {}
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var expirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
    
}
