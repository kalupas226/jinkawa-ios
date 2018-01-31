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
                if UserDefaults.standard.object(forKey: "userInformation") != nil {
                    $0.value = UserDefaults.standard.dictionary(forKey: "userInformation")?["NameRowTag"] as? String
                }
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
                if UserDefaults.standard.object(forKey: "userInformation") != nil {
                    $0.value = UserDefaults.standard.dictionary(forKey: "userInformation")?["GenderRowTag"] as? String
                }
            }
            <<< IntRow("AgeRowTag") {
                $0.title = "年齢"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                if UserDefaults.standard.object(forKey: "userInformation") != nil {
                    $0.value = UserDefaults.standard.dictionary(forKey: "userInformation")?["AgeRowTag"] as? Int
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
                if UserDefaults.standard.object(forKey: "userInformation") != nil {
                    $0.value = UserDefaults.standard.dictionary(forKey: "userInformation")?["PhoneRowTag"] as? String
                }
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
                if UserDefaults.standard.object(forKey: "userInformation") != nil {
                    $0.value = UserDefaults.standard.dictionary(forKey: "userInformation")?["AddressRowTag"] as? String
                }
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
            +++ Section()
                <<< ButtonRow() {
                    $0.title = "申し込む"
                    }.onCellSelection { cell, row in
                        let errors = self.form.validate()
                        guard errors.isEmpty else {
                            print("validate errors:", errors)
                            return
                        }
                        
                        
                        // Get the value of all rows which have a Tag assigned
                        let values = self.form.values()
                        
                        let name:String = values["NameRowTag"] as! String
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
                        
                        
                        //アラート
                        let alert = UIAlertController(title: "この内容で申し込みます", message: message, preferredStyle: .alert)
                        
                        //確定ボタン
                        let confirmAction = UIAlertAction(title: "確定", style: .default){ (action: UIAlertAction) in
                            let participant = Participant(name: name, gender: gender, age: age.description, tell: tell, address: address, event_id:self.event_id)
                            participant.save()
                            print("participant data was saved")
                            
                            //ユーザー情報の保存
                            UserDefaults.standard.set(values, forKey: "userInformation")
                            
                            let confirmAlert = UIAlertController(title: "申し込みが確定されました", message: nil, preferredStyle: .alert)
                            let okAction = UIKit.UIAlertAction(title: "OK", style: .default){ (action: UIAlertAction) in
                                print("OK")
                                //前の画面に遷移する
                                self.navigationController?.popViewController(animated: true)
                            }
                            confirmAlert.addAction(okAction)
                            self.present(confirmAlert, animated: true, completion: nil)
                        }
                        
                        //キャンセルボタン
                        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel){ (action: UIAlertAction) in
                            print("Cancel")
                            let cancelAlert = UIAlertController(title: "キャンセルされました", message: nil, preferredStyle: .alert)
                            let okAction: UIAlertAction = UIKit.UIAlertAction(title: "OK", style: .default){ (action: UIAlertAction) in
                                print("OK")
                            }
                            cancelAlert.addAction(okAction)
                            self.present(cancelAlert, animated: true, completion: nil)
                        }
                        
                        alert.addAction(confirmAction)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
        }
        }
        
        
        // If you don't want to use Eureka custom operators ...
        //        let row = NameRow("NameRow") { $0.title = "name" }
        //        let section = Section()
        //        section.append(row)
        //        form.append(section)
        //
    
    }

