//
//  LoginViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/17.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import NCMB

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
        UserManager.sharedInstance.login(id: idTextString, pass: psTextString)
        loginAlert()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func loginAlert(){
        //アラートの表示
        let alert: UIAlertController = UIAlertController(title: nil, message: "aaa", preferredStyle:  UIAlertControllerStyle.alert)
        // Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(defaultAction)
        //Alertを表示
        self.present(alert, animated: true, completion: nil)
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
