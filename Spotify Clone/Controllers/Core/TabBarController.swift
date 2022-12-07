//
//  TabBarController.swift
//  Spotify Clone
//
//  Created by Ryan Adi Putra on 07/12/22.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let vc1: UINavigationController = {
        let vc = HomeViewController()
        vc.title = "Browse"
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav.navigationItem.largeTitleDisplayMode = .always
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }()
    
    private let vc2: UINavigationController = {
        let vc = SearchViewController()
        vc.title = "Search"
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        nav.navigationItem.largeTitleDisplayMode = .always
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }()
    
    private let vc3: UINavigationController = {
        let vc = LibraryViewController()
        vc.title = "Library"
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 3)
        nav.navigationItem.largeTitleDisplayMode = .always
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers([vc1, vc2, vc3], animated: true)
    }
    
}
