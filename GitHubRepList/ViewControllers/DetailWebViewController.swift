//
//  DetailWebViewController.swift
//  GitHubRepList
//
//  Created by Mihael Matyatsko on 22.07.2021.
//

import UIKit
import WebKit
import CoreData

class DetailWebViewController: UIViewController {

    @IBOutlet weak var detailWebView: WKWebView!
    var httpsAdress: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpsAdress = GitHubOpenReposViewController.chosenCellurl
        openURL(stringURL: httpsAdress)
        
    }
    
    func openURL(stringURL: String?){
        guard let adress = stringURL,
              let url = URL(string: adress)
        else {
            print("Error: no avaliable adress link!")
            return
        }
        detailWebView.load(URLRequest(url: url))
    }
    
}
