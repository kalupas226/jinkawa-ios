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
    
    var accountsList:[Accounts] = []
    static var userId:String = ""
    static var userAuth:[String] = []
    static let sharedInstance = LoginViewController()
    @IBOutlet weak var psTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    var idTextString = ""
    var psTextString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idTextField.placeholder = "IDを入力してください"
        psTextField.placeholder = "パスワードを入力してください"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(id:String,pass:String){
        accountsList.removeAll()
        // AccountsClassクラスを検索するNCMBQueryを作成
        let query = NCMBQuery(className: "Accounts")
        var result:[NCMBObject] = []
        
        /** 条件を入れる場合はここに書きます **/
        query?.whereKey("userId", equalTo: id)
        query?.whereKey("password", equalTo: pass)
        // データストアの検索を実施
        query?.findObjectsInBackground({(objects, error) in
            if (error != nil){
                print("エラーが発生しました")
            }else{
                result = objects! as! [NCMBObject]
                //検索しても見つからなかった場合
                if(result.isEmpty == true){
                    self.loginAlert(loginMessage: "IDまたはパスワードが\n間違っています")
                    
                }else{
                    // 検索成功時の処理
                    if result.count > 0 {
                        result.forEach{ obj in
                            self.accountsList.append(Accounts(accounts: obj))
                        }
                        LoginViewController.userId = self.accountsList[0].id
                        LoginViewController.userAuth = self.accountsList[0].auth

                        print("アカウントリストが更新されました")
                    }
                    if self.accountsList[0].role == "admin" {
                        UserManager.sharedInstance.setState(state: .admin)
                        print(self.accountsList[0].role)
                        self.loginAlert(loginMessage: "管理者としてログインしました")
                    }else{
                        UserManager.sharedInstance.setState(state: .officer)
                        print(self.accountsList[0].role)
                        self.loginAlert(loginMessage: "役員としてログインしました")
                    }
                }
            }
        })
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        idTextString = idTextField.text!
        psTextString = psTextField.text!
        login(id: idTextString, pass: psTextString)
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func loginAlert(loginMessage:String){
        //アラートの表示
        let alert: UIAlertController = UIAlertController(title: nil, message: loginMessage, preferredStyle:  UIAlertControllerStyle.alert)
        // Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            if(loginMessage != "IDまたはパスワードが\n間違っています"){
                let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "eventListView")
                self.present(nextVC!, animated: true, completion: nil)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
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

