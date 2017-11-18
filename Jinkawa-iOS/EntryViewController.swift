//
//  EntryViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/13.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import Eureka

class EntryViewController: FormViewController {
    var event_id = ""
    
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
            +++ Section("申し込み情報")
            <<< NameRow("NameRowTag") {
                $0.title = "氏名"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
                }.onChange {
                    print("Name changed:", $0.value ?? "");
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, _) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = "氏名を入力してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< SegmentedRow<String>("GenderRowTag") {
                $0.title = "性別　　　　　"
                $0.options = ["男", "女"]
                $0.value = "男"    // initially selected
            }
            <<< IntRow("AgeRowTag") {
                $0.title = "年齢"
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
                                $0.title = "年齢を入力してください"
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
            <<< PhoneRow("PhoneRowTag") {
                $0.title = "電話番号"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .cellUpdate{ cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, _) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = "電話番号を入力してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< TextRow("AddressRowTag") {
                $0.title = "住所"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .cellUpdate{ cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, _) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = "住所を入力してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
        }
        
        // If you don't want to use Eureka custom operators ...
        //        let row = NameRow("NameRow") { $0.title = "name" }
        //        let section = Section()
        //        section.append(row)
        //        form.append(section)
        //
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(didTapSaveButton(sender:)))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func didTapSaveButton(sender: UIBarButtonItem) {
        let errors = form.validate()
        guard errors.isEmpty else {
            print("validate errors:", errors)
            return
        }
        
        // Get the value of a single row
        let nameRow = form.rowBy(tag: "NameRowTag") as! NameRow
        let name = nameRow.value!
        
        // Get the value of all rows which have a Tag assigned
        let values = form.values()
        
        let gender:String = values["GenderRowTag"] as! String
        let age:Int = values["AgeRowTag"] as! Int
        let tell:String = values["PhoneRowTag"] as! String
        let address:String = values["AddressRowTag"] as! String
        
        let message: String =
            "名前:" + name + "\n" +
                "性別:" + gender + "\n\n" +
                "年齢:" + age.description + "\n" +
                "電話番号:" + tell + "\n" +
                "住所:" + address
        
        let alert = UIAlertController(title: "この内容で申し込みます",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定",
                                      style: .default,
                                      handler: {(UIAlertAction)-> Void in
                                        let participant = Participant(name: name, gender: gender, age: age.description, tell: tell, address: address, event_id:self.event_id)
                                        participant.save()
                                        
                                        let alertAfter = UIAlertController(title: "申し込みが確定されました",
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
}
