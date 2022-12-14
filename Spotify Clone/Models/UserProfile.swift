//
//  UserProfile.swift
//  Spotify Clone
//
//  Created by Ryan Adi Putra on 07/12/22.
//

import Foundation

struct UserProfile: Codable {
    let id: String
    let country: String
    let display_name: String
    let email: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
    let product: String
    let images: [UserImage]
}

struct UserImage: Codable {
    let url: String
}
