//
//  AuthManager.swift
//  Spotify Clone
//
//  Created by Ryan Adi Putra on 07/12/22.
//

import Foundation

class AuthManager {
    
    struct Constants {
        static let clientID = "90de14dfa1604f849548f23807e55afe"
        static let clientSecret = "b6e7109b4f8945a48b8d7edf661a6778"
    }
    
    static let shared = AuthManager()
    var isSignedIn: Bool {
        return false
    }
        
    private init() {}
    
    public var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let scope = "user-read-private"
        let redirectURI = "https://github.com/ryanadiputraa"
        let stringURL = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(scope)&redirect_uri=\(redirectURI)&show_dialog=TRUE"
        return URL(string: stringURL)
    }
    
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
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        // get access token
    }
    
    public func refreshAccessToken() {}
    
    public func cacheToken() {}
    
}
