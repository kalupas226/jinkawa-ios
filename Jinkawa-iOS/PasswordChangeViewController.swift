//
//  PasswordChangeViewController.swift
//  Jinkawa-iOS
//
//  Created by Kenta Aikawa on 2017/11/21.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import NCMB

class PasswordChangeViewController: UIViewController {
    
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    private var accountsList:[Accounts] = []
    var oldPasswordStr: String = ""
    var newPasswordStr: String = ""
    var confirmPasswordStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        id.text = "ユーザID: " + LoginViewController.userId
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeButton(_ sender: Any) {
        oldPasswordStr = oldPassword.text!
        newPasswordStr = newPassword.text!
        confirmPasswordStr = confirmPassword.text!
        self.view.endEditing(true)
        passChange(id: LoginViewController.userId, old: oldPasswordStr, new: newPasswordStr, confirm: confirmPasswordStr)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func passChange(id: String, old: String, new: String, confirm: String){
        accountsList.removeAll()
        // AccountsClassクラスを検索するNCMBQueryを作成
        let query = NCMBQuery(className: "Accounts")
        var result:[NCMBObject] = []
        /** 条件を入れる場合はここに書きます **/
        query?.whereKey("userId", equalTo: id)
        query?.whereKey("password", equalTo: old)
        // データストアの検索を実施
        query?.findObjectsInBackground({(objects, error) in
            if (error != nil){
                print("エラーが発生しました")
            }else{
                result = objects! as! [NCMBObject]
                //検索しても見つからなかった場合
                if(result.isEmpty == true){
                    print("アカウントが見つかりません")
                    let alert: UIAlertController = UIAlertController(title: nil, message: "現在のパスワードが\n間違っています", preferredStyle:  UIAlertControllerStyle.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                        // ボタンが押された時の処理を書く（クロージャ実装）
                        (action: UIAlertAction!) -> Void in
                        print("OK")
                        return;
                    })
                    alert.addAction(defaultAction)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    if(new == confirm){
                        // 検索成功時の処理
                        if result.count > 0 {
                            result.forEach{ obj in
                                self.accountsList.append(Accounts(accounts: obj))
                            }
                            print("アカウントリストが更新されました")
                        }
                        // クラスのNCMBObjectを作成
                        let obj = NCMBObject(className: "Accounts")
                        // objectIdプロパティを設定
                        print(self.accountsList[0].objId)
                        obj?.objectId = self.accountsList[0].objId
                        // 設定されたobjectIdを元にデータストアからデータを取得
                        obj?.fetchInBackground({ (error) in
                            if error != nil {
                                // 取得に失敗した場合の処理
                                print("取得失敗")
                            }else{
                                // 取得に成功した場合の処理
                                print("取得成功")
                                obj?.setObject(new, forKey: "password")
                                obj?.saveInBackground({ (error) in
                                    if error != nil {
                                        // 更新に失敗した場合の処理
                                    }else{
                                        // 更新に成功した場合の処理
                                        // (例)更新したデータの出力
                                        print(obj! as NCMBObject)
                                        let alert: UIAlertController = UIAlertController(title: nil, message: "パスワード変更が成功しました\nログアウトします", preferredStyle:  UIAlertControllerStyle.alert)
                                        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                                            // ボタンが押された時の処理を書く（クロージャ実装）
                                            (action: UIAlertAction!) -> Void in
                                            print("OK")
                                            UserManager.sharedInstance.setState(state: .common)
                                            let storyboard: UIStoryboard = self.storyboard!
                                            let nextView = storyboard.instantiateViewController(withIdentifier: "Top")
                                            self.present(nextView, animated: true, completion: nil)
                                            return
                                        })
                                        alert.addAction(defaultAction)
                                        self.present(alert, animated: true, completion: nil)
                                        print("パスワード更新成功")
                                    }
                                })
                            }
                        })
                    }else if(new != confirm){
                        print("一致しません")
                        let alert: UIAlertController = UIAlertController(title: nil, message: "新しいパスワードが\n一致しません", preferredStyle:  UIAlertControllerStyle.alert)
                        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action: UIAlertAction!) -> Void in
                            print("OK")
                        })
                        alert.addAction(defaultAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        })
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

