//
//  SettingViewController.swift
//  Jinkawa-iOS
//
//  Created by Kenta Aikawa on 2017/10/21.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import Eureka

let sectionTitle = ["設定", "お問合わせ"]
let settingItem = ["通知のオン/オフ", "入力情報の確認"]
let contactItem = ["陣川あさひ町会"]

class SettingViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .white
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = nil
            cell.textLabel?.textAlignment = .right
        }
        
        form
            +++ Section("設定")
            <<< SwitchRow() {
                $0.title = "通知のオン/オフ"
            }
            <<< LabelRow() {
                $0.title = "入力情報の確認"
                }.onCellSelection{ cell, row in
                    if UserDefaults.standard.object(forKey: "userInformation") != nil {
                        self.performSegue(withIdentifier: "toUserInformation", sender: nil)
//                        let nvc = self.storyboard!.instantiateViewController(withIdentifier: "UserInformationView")
//                        nvc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
//                        self.present(nvc, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "入力情報の確認", message: "ユーザー情報がありません", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
            }
            +++ Section("アカウント"){ section in
                if UserManager.sharedInstance.getState() == .common {
                    section.hidden = true
                }
            }
            <<< ButtonRow() {
                $0.title = "パスワード変更"
                }.onCellSelection { cell, row in
                    self.performSegue(withIdentifier: "toPasswordChange", sender: nil)
            }
            <<< ButtonRow() {
                $0.title = "ログアウト"
                }.onCellSelection { cell, row in
                    let alertController = UIAlertController(title: "ログアウト", message: "ログアウトしますか", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "はい", style: .default){ (action: UIAlertAction) in
                        UserManager.sharedInstance.setState(state: .common)
                        let storyboard: UIStoryboard = self.storyboard!
                        let nextView = storyboard.instantiateViewController(withIdentifier: "Top")
                        self.present(nextView, animated: true, completion: nil)
                    }
                    let cancelAction = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
                    
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
            }
            +++ Section("お問い合わせ")
            <<< LabelRow() {
                $0.title = "陣川あさひ町会"
            }
            +++ Section()
            <<< ButtonRow() {
                $0.title = "ホーム画面へ戻る"
                }.onCellSelection { cell, row in
                    self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

