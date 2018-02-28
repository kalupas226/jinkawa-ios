//
//  SettingPrivacyViewController.swift
//  Jinkawa-iOS
//
//  Created by 相川健太 on 2018/02/28.
//  Copyright © 2018年 Taro Sato. All rights reserved.
//

import UIKit
import WebKit

class SettingPrivacyViewController: UIViewController {
    
    
    @IBOutlet weak var settingPrivacyWebView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        showBrowser()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showBrowser() {
        
        // サイズを指定してブラウザ作成
        let webView = WKWebView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: settingPrivacyWebView.frame.height - UIApplication.shared.statusBarFrame.height))
        
        // ローカルのHTMLを読み込む
        if let htmlData = Bundle.main.path(forResource: "index", ofType: "html") {
            webView.load(URLRequest(url: URL(fileURLWithPath: htmlData)))
            settingPrivacyWebView.addSubview(webView)
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
