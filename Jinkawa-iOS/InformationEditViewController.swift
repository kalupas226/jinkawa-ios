//
//  InformationEditViewController.swift
//  Jinkawa-iOS
//
//  Created by Kenta Aikawa on 2017/11/18.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//


import UIKit
import Eureka
import NCMB

class InformationEditViewController: FormViewController {
    
    var information:Information = Information()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .right
            
        }
        
        TextRow.defaultCellUpdate = { cell, row in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        
        form
            +++ Section("お知らせの内容")
            <<< TextRow("TitleRowTag") {
                $0.title = "タイトル"
                $0.value = information.title
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, _) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = "タイトルを入力してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
                }
                .cellUpdate{ cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< PickerInlineRow<String>("DepartmentNameRowTag") {
                $0.title = "部署"
                if(UserManager.sharedInstance.getState() == .admin){
                    $0.options = ["役員","総務部","青少年育成部","女性部","福祉部","Jバス部","環境部","交通部","防火防犯部"]
                }else{
                    $0.options = LoginViewController.userAuth
                }
                $0.value = information.departmentName   // initially selected
            }
            <<< PickerInlineRow<String>("TypeRowTag") {
                $0.title = "お知らせ種類"
                $0.options = ["注意","買い物","告知","緊急","バス"]
                $0.value = information.type    // initially selected
            }
            <<< DateInlineRow("DateRowTag") {
                $0.title = "日付"
                //日付関連を日本標準時にするためのformatter
                let dateFrt = DateFormatter()
                dateFrt.setTemplate(.full)
                $0.value = dateFrt.date(from: information.date)
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, _) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = "日付を選択してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            
            <<< TextAreaRow("DescriptionRowTag") {
                $0.placeholder = "説明文"
                $0.value = information.descriptionText
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, _) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = "説明文を入力してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< SwitchRow("OfficerRowTag"){
                $0.title = "役員のみに公開"
                $0.value = information.officer
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(didTapSaveButton(sender:)))
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapSaveButton(sender: UIBarButtonItem) {
        let errors = form.validate()
        guard errors.isEmpty else {
            print("validate errors:", errors)
            let alert: UIAlertController = UIAlertController(title: "エラー", message: "入力または選択されていない\n項目があります", preferredStyle:  UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Get the value of all rows which have a Tag assigned
        let values = form.values()
        
        //日付関連を日本標準時にするためのformatter
        let dateFrt = DateFormatter()
        dateFrt.setTemplate(.full)
        
        let title:String = values["TitleRowTag"] as! String
        let department:String = values["DepartmentNameRowTag"] as! String
        let description:String = values["DescriptionRowTag"] as! String
        let type:String = values["TypeRowTag"] as! String
        let date = dateFrt.string(from:values["DateRowTag"] as! Date)
        let officer:Bool = values["OfficerRowTag"] as! Bool
        
        var message: String =
            "タイトル:" + title + "\n" +
                "発行部署:" + department + "\n" +
                "日付:" + date.description + "\n" +
                "お知らせ種類:" + type
        
        if(officer == true){
            message = message + "\n\n" + "役員のみに公開する"
        }
        let alert = UIAlertController(title: "この内容で更新します",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定",
                                      style: .default,
                                      handler: {(UIAlertAction)-> Void in
                                        /** オブジェクトの更新**/
                                        // クラスのNCMBObjectを作成
                                        let obj = NCMBObject(className: "Information")
                                        // objectIdプロパティを設定
                                        obj?.objectId = self.information.id
                                        // 設定されたobjectIdを元にデータストアからデータを取得
                                        obj?.fetchInBackground({ (error) in
                                            if error != nil {
                                                // 取得に失敗した場合の処理
                                            }else{
                                                // 取得に成功した場合の処理
                                                obj?.setObject(title, forKey: "title")
                                                obj?.setObject(date, forKey: "date")
                                                obj?.setObject(type, forKey: "type")
                                                obj?.setObject(department, forKey: "department_name")
                                                obj?.setObject(description, forKey: "info")
                                                obj?.setObject(officer, forKey: "officer_only")
                                                
                                                obj?.saveInBackground({ (error) in
                                                    if error != nil {
                                                        // 更新に失敗した場合の処理
                                                    }else{
                                                        // 更新に成功した場合の処理
                                                        // (例)更新したデータの出力
                                                        print(obj! as NCMBObject)
                                                    }
                                                })
                                            }
                                        })
                                        
                                        let alertAfter = UIAlertController(title: "更新が確定されました",
                                                                           message: nil,
                                                                           preferredStyle: .alert)
                                        let defaultAction: UIAlertAction = UIKit.UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                                            // ボタンが押された時の処理を書く（クロージャ実装）
                                            (action: UIAlertAction!) -> Void in
                                            print("OK")
                                            let push = NCMBPush()
                                            let data_iOS = ["contentAvailable" : false, "badgeIncrementFlag" : true, "sound" : "default"] as [String : Any]
                                            push.setData(data_iOS)
                                            push.setPushToIOS(true)
                                            push.setTitle(title)
                                            push.setMessage("お知らせが更新されました！")
                                            push.setImmediateDeliveryFlag(true) // 即時配信
                                            let query = NCMBInstallation.query()
                                            query?.whereKey("channels", equalTo: ["on"])
                                            push.setSearchCondition(query)
                                            push.sendInBackground { (error) in
                                                if error != nil {
                                                    // プッシュ通知登録に失敗した場合の処理
                                                    print("NG:\(String(describing: error))")
                                                } else {
                                                    // プッシュ通知登録に成功した場合の処理
                                                    print("OK")
                                                }
                                            }
                                            
                                            let pushA = NCMBPush()
                                            let data_Android = ["action" : "ReceiveActivity", "title" : "testPush"] as [String : Any]
                                            pushA.setData(data_Android)
                                            pushA.setDialog(true)
                                            pushA.setPushToAndroid(true)
                                            pushA.setTitle(title)
                                            pushA.setMessage("お知らせが更新されました!")
                                            pushA.setImmediateDeliveryFlag(true) // 即時配信
                                            pushA.setSearchCondition(query)
                                            pushA.sendInBackground { (error) in
                                                if error != nil {
                                                    // プッシュ通知登録に失敗した場合の処理
                                                    print("NG:\(String(describing: error))")
                                                } else {
                                                    // プッシュ通知登録に成功した場合の処理
                                                    print("OK")
                                                }
                                            }
                                            //2つ前の画面に遷移する
                                            self.navigationController?.popToRootViewController(animated: true)
                                        })
                                        
                                        alertAfter.addAction(defaultAction)
                                        self.present(alertAfter, animated: true, completion: nil)
                                        
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
            let alertCancel = UIAlertController(title: "キャンセルされました",
                                                message: nil,
                                                preferredStyle: .alert)
            let defaultAction: UIAlertAction = UIKit.UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            
            alertCancel.addAction(defaultAction)
            self.present(alertCancel, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
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

