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
    var movie: MovieViewModelProtocol!
    
    var webView = WKWebView()
    
    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
//        let myURL = URL(string: Routes.buyTicketURL)!
//        let myRequest = URLRequest(url: myURL)
        // TODO: UNCOMMENT this
//        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true
//        print(webView.url!)
        SVProgressHUD.dismiss()
    }
    // TODO: delete this method
    override func viewDidAppear(_ animated: Bool) {
        performSegueToCompletedPurchase()
    }
    
    func performSegueToCompletedPurchase() {
        performSegue(withIdentifier: "purchaseCompleted", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "purchaseCompleted" {
            let buyTicketCompleteViewController = segue.destination as! BuyTicketCompleteViewController
            buyTicketCompleteViewController.movie = movie
        }
    }
    
}
