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
        
        form
            +++ Section("設定")
            <<< SwitchRow() {
                $0.title = "通知のオン/オフ"
            }
            <<< LabelRow() {
                $0.title = "入力情報の確認"
            }
            +++ Section("アカウント")
            <<< LabelRow() {
                $0.title = "パスワード変更"
            }
            <<< LabelRow() {
                $0.title = "ログアウト"
            }
            +++ Section("お問い合わせ")
            <<< LabelRow() {
                $0.title = "陣川あさひ町会"
            }
            +++ Section()
            <<< LabelRow() {
                $0.title = "ホーム画面へ戻る"
                }.onCellSelection {cell, row in
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

