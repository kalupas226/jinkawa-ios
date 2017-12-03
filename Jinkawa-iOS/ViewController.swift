//
//  ViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/06/23.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusBar = UIView(frame:CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        statusBar.backgroundColor = UIColor.colorWithHexString("2E2E2E")
        view.addSubview(statusBar)
        // Do any additional setup after loading the view, typically from a nib.
        //        let event = Event(eventName: "testName2", updateAt: "2:00", description: "testDescription")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButtonDidTapped(_ sender: Any) {
        performSegue(withIdentifier: "showTabView", sender: nil)
    }

    @IBAction func didTapToLoginButton(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: nil)
    }
}

