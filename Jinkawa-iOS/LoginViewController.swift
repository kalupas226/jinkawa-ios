//
//  LoginViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/17.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {


    @IBOutlet weak var psTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    var idTextString = ""
    var psTextString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idTextField.placeholder = "ユーザーID"
        psTextField.placeholder = "パスワード"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(_ sender: Any) {
        idTextString = idTextField.text!
        psTextString = psTextField.text!
        UserManager.sharedManager.login(id:idTextString, pass:psTextString)
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
