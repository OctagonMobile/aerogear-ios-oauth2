/*
* JBoss, Home of Professional Open Source.
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation

import WebKit
import UIKit
/**
OAuth2WebViewController is a UIViewController to be used when the Oauth2 flow used an embedded view controller
rather than an external browser approach.
*/
open class OAuth2WebViewController: UIViewController {
    /// Login URL for OAuth.
    var targetURL: URL!
    /// WebView instance used to load login page.
    var webView: WKWebView = WKWebView()

    /// Override of viewDidLoad to load the login page.
    override open func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = UIScreen.main.bounds
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        loadAddressURL()
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.webView.frame = self.view.bounds
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadAddressURL() {
        let req = URLRequest(url: targetURL)
        webView.load(req)
    }
}

extension OAuth2WebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {

        guard let urlString = (error as NSError).userInfo[NSURLErrorFailingURLStringErrorKey] as? String,
        let url = URL(string: urlString) else {
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
}
