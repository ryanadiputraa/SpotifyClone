//
//  AuthManager.swift
//  Spotify Clone
//
//  Created by Ryan Adi Putra on 07/12/22.
//

import Foundation

class AuthManager {
    
    static let shared = AuthManager()

    struct Constants {
        static let clientID = "90de14dfa1604f849548f23807e55afe"
        static let clientSecret = "b6e7109b4f8945a48b8d7edf661a6778"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://github.com/ryanadiputraa"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
        
    private init() {}
    
    public var signInURL: URL? {
        let baseURL = "https://accounts.spotify.com/authorize"
        let stringURL = "\(baseURL)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: stringURL)
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        return currentDate.addingTimeInterval(TimeInterval(300)) >= expirationDate
    }
    
    public func exchangeCodeForToken(
        code: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        let basicToken = "\(Constants.clientID):\(Constants.clientSecret)"
        let data = basicToken.data(using: .utf8)
        guard let base64Token = data?.base64EncodedString() else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64Token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        let basicToken = "\(Constants.clientID):\(Constants.clientSecret)"
        let data = basicToken.data(using: .utf8)
        guard let base64Token = data?.base64EncodedString() else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64Token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("refreshing token...")
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    public func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationData")
    }
    
}
