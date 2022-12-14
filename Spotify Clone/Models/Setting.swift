//
//  Settings.swift
//  Spotify Clone
//
//  Created by Ryan Adi Putra on 14/12/22.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
