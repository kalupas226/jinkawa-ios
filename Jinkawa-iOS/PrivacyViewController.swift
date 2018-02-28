//
//  PrivacyViewController.swift
//  Jinkawa-iOS
//
//  Created by 相川健太 on 2018/02/28.
//  Copyright © 2018年 Taro Sato. All rights reserved.
//

import UIKit
import WebKit

class PrivacyViewController: UIViewController {
    
    @IBOutlet weak var privacyWebView: UIView!
    
    @IBAction func agreeButton(_ sender: Any) {
        let userDefault = UserDefaults.standard
        userDefault.set(false, forKey: "firstPrivacy")
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "startView")
        present(nextView, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBar = UIView(frame:CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIApplication.shared.statusBarFrame.height))
        statusBar.backgroundColor = UIColor.colorWithHexString("2E2E2E")
        view.addSubview(statusBar)
        showBrowser()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showBrowser() {
        
        // サイズを指定してブラウザ作成
        let webView = WKWebView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: privacyWebView.frame.height - UIApplication.shared.statusBarFrame.height))
        
        // ローカルのHTMLを読み込む
        if let htmlData = Bundle.main.path(forResource: "index", ofType: "html") {
            webView.load(URLRequest(url: URL(fileURLWithPath: htmlData)))
            privacyWebView.addSubview(webView)
        } else {
            print("file not found")
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
