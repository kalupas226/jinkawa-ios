//
//  InformationCreateViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/16.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import Eureka

class InformationCreateViewController: FormViewController {

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
                $0.options = ["役員","総務部","青少年育成部","女性部","福祉部","Jバス部","環境部","交通部","防火防犯部"]
                $0.value = "総務部"    // initially selected
            }
            <<< PickerInlineRow<String>("TypeRowTag") {
                $0.title = "お知らせ種類"
                $0.options = ["注意","買い物","告知","緊急","バス"]
                $0.value = "告知"    // initially selected
            }
            <<< DateInlineRow("DateRowTag") {
                $0.title = "日付"
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
                $0.value = false
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
        
        let message: String =
            "タイトル:" + title + "\n" +
                "発行部署:" + department + "\n" +
                "開催日:" + date.description + "\n"
        
        let alert = UIAlertController(title: "この内容で作成します",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定",
                                      style: .default,
                                      handler: {(UIAlertAction)-> Void in
                                        let information = Information(title: title, descriptionText: description, date:date.description, type:type, departmentName: department, officer: officer)
                                        information.save()
                                        
                                        let alertAfter = UIAlertController(title: "作成が確定されました",
                                                                           message: nil,
                                                                           preferredStyle: .alert)
                                        let defaultAction: UIAlertAction = UIKit.UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                                            // ボタンが押された時の処理を書く（クロージャ実装）
                                            (action: UIAlertAction!) -> Void in
                                            print("OK")
                                            //前の画面に遷移する
                                            self.navigationController?.popViewController(animated: true)
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
