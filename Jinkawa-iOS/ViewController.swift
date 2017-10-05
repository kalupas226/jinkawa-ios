//
//  ViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/06/23.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startButtonDidTapped(_ sender: Any) {
        performSegue(withIdentifier: "showTabView", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let event = Event(eventName: "testName2", updateAt: "2:00", description: "testDescription")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backToHome(segue: UIStoryboardSegue){
        
    }
}

