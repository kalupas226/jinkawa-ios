//
//  SettingViewController.swift
//  Jinkawa-iOS
//
//  Created by Kenta Aikawa on 2017/10/21.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import Eureka
import NCMB
import UserNotifications

class SettingViewController: FormViewController {
    
    static var pushStr = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .white
            cell.textLabel?.textColor = .black
            cell.textLabel?.font = nil
            cell.textLabel?.textAlignment = .right
        }
        //プッシュ通知メッセージの更新
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            switch settings.authorizationStatus {
            case .authorized:
                SettingViewController.pushStr = "アプリを強制終了すると、通知が遅れたり、受信できない場合があります。"
                break
            case .denied:
                SettingViewController.pushStr = "端末のじぷりの通知設定がオフのようです。じぷりの通知設定を有効にするためには、端末の設定画面で「じぷり」の通知をオンにしてください。"
                break
            case .notDetermined:
                break
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .right
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        
        let statusBar = UIView(frame:CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        statusBar.backgroundColor = UIColor.colorWithHexString("2E2E2E")
        view.addSubview(statusBar)
        self.navigationController?.view.addSubview(statusBar)
        
        form
            +++ Section(header: "", footer: SettingViewController.pushStr)
            <<< SwitchRow() { row in
                row.title = "通知のオン／オフ"
                let currentInstallation = NCMBInstallation.current()
                if (currentInstallation?.deviceToken == nil) {
                    return
                }
                if(String(describing: currentInstallation?.channels[0]) == "Optional(on)"){
                    row.value = true
                }else{
                    row.value = false
                }
                }.onChange{ row in
                    let currentInstallation = NCMBInstallation.current()
                    if (currentInstallation?.deviceToken == nil) {
                        return
                    }
                    // installation class update
                    if(row.value == false){
                        currentInstallation?.setObject(["off"], forKey: "channels")
                    }else if(row.value == true){
                        currentInstallation?.setObject(["on"], forKey: "channels")
                    }
                    currentInstallation?.saveInBackground{(error) -> Void in
                        if ((error == nil)) {
                            print("updatechannels complete")
                        } else {
                            print("updatechannels error: \(String(describing: error))")
                        }
                    }
            }
            
            +++ Section(header: "", footer: "イベントへの参加申し込み時の入力情報の確認、削除を行うことができます。")
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
                }.onCellSelection{ cell, row in
                    self.performSegue(withIdentifier: "toContact", sender: nil)
            }
            +++ Section()
            <<< ButtonRow() {
                $0.title = "スタート画面へ戻る"
                }.onCellSelection { cell, row in
                    let storyboard: UIStoryboard = self.storyboard!
                    let nextView = storyboard.instantiateViewController(withIdentifier: "Top")
                    self.present(nextView, animated: true, completion: nil)
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

