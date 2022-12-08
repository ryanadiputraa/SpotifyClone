//
//  AuthViewController.swift
//  Spotify Clone
//
//  Created by Ryan Adi Putra on 07/12/22.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {

    private let webView: WKWebView = {
        let pref = WKWebpagePreferences()
        pref.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = pref
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
        
        webView.navigationDelegate = self
        view.addSubview(webView)
        guard let authURL = AuthManager.shared.signInURL else { return }
        webView.load(URLRequest(url: authURL))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
}

extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        // exchange code for access token
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        print("Code: \(code)")
    }
    
}
