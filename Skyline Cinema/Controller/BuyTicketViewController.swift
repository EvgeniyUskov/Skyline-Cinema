//
//  BuyTicketViewController.swift
//  Skyline Cinema
//
//  Created by Evgeniy Uskov on 17.01.2020.
//  Copyright © 2020 Evgeniy Uskov. All rights reserved.
//

import Foundation
import WebKit
import SVProgressHUD

class BuyTicketViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    //    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var movieTitle: String?
    var movieDate: String?
    var webView = WKWebView()
    
    let networkManager = NetworkManager()
    
    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        let myURL = URL(string: networkManager.buyTicketURL)!
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true
        print(webView.url!)
        SVProgressHUD.dismiss()
    }
    
}
