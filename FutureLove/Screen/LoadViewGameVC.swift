//
//  LoadViewGameVC.swift
//  FutureLove
//
//  Created by khongtinduoc on 6/23/24.
//

import UIKit
import WebKit

class LoadViewGameVC: UIViewController , WKNavigationDelegate,WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if (message.name == "callbackHandler"){
            print("\(message.body)")
        }
    }
    
    var gameProWebkit: WKWebView?
    var linkHD:String = ""
    var sizeWeb = 100
    var statusBarHeightServer = 35
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
      }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        if statusBarHeight == 0{
            statusBarHeight = CGFloat(statusBarHeightServer)
        }
        let myBlog = linkHD
        let url = NSURL(string: myBlog)
        let request = NSURLRequest(url: url! as URL)
        self.tabBarController?.tabBar.isHidden = true
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "callbackHandler")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        configuration.allowsInlineMediaPlayback = true
        var framePro:CGRect!
        if self.view.frame.width <= 736{ // iphone 7 plus
            framePro = CGRect(x: 0, y: 0, width: self.view.frame.width  , height: (self.view.frame.height ) )
        }else{
            framePro = CGRect(x: -100, y: 0, width: self.view.frame.width  + CGFloat(200) , height: (self.view.frame.height + statusBarHeight) )
        }
         
        print("______________________")
        print(self.view.frame.width)
        print(self.view.frame.height)
        print(statusBarHeight)
        print("______________________")
        self.gameProWebkit = WKWebView(frame: framePro, configuration: configuration)
        self.view.addSubview(self.gameProWebkit!)
        
        gameProWebkit?.navigationDelegate = self
        gameProWebkit?.load(request as URLRequest)
        self.view.addSubview(gameProWebkit!)
        self.view.sendSubviewToBack(gameProWebkit!)
    }
}
