//
//  EventCreateViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/16.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import Eureka
import NCMB


class EventCreateViewController: FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var image:UIImage? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
            cell.height = ({return 100})
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
            +++ Section("イベント基本情報")
            <<< TextRow("EventNameRowTag") {
                $0.title = "イベント名"
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
                                $0.title = "イベント名を入力してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< PickerInlineRow<String>("DepartmentNameRowTag") {
                $0.title = "部署"
                $0.options = ["役員","総務部","青少年育成部","女性部","福祉部","Jバス部","環境部","交通部","防火防犯部"]
                $0.value = "総務部"    // initially selected
            }
            <<< SwitchRow("OfficerRowTag"){
                $0.title = "役員のみに公開"
                $0.value = false
            }
            +++ Section("イベント日程")
            <<< DateInlineRow("DateStartRowTag") {
                $0.title = "開始日"
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
                                $0.title = "開始日を選択してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< TimeInlineRow("TimeStartRowTag") {
                $0.title = "開始時間"
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
                                $0.title = "開始時間を選択してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< DateInlineRow("DateEndRowTag") {
                $0.title = "終了日"
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
                                $0.title = "終了日を選択してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< TimeInlineRow("TimeEndRowTag") {
                $0.title = "終了時間"
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
                                $0.title = "終了時間を選択してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< DateInlineRow("DeadlineRowTag"){
                $0.title = "締切日"
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
                                $0.title = "締切日を選択してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            +++ Section ("イベント詳細情報")
            <<< TextAreaRow("DescriptionRowTag") {
                $0.placeholder = "イベント説明文"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, _) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = "イベント説明文を入力してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< ImageRow("ImageRowTag") {
                $0.title = "イベント画像"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnBlur
            }
                .onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, _) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = "画像を選択してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }

            <<< TextRow("LocationRowTag") {
                $0.title = "開催場所"
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
                                $0.title = "開催場所を入力してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            <<< TextRow("CapacityRowTag"){
                $0.title = "定員"
                $0.placeholder = "(例)20"
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
                                $0.title = "定員を入力してください"
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
        
        image = (values["ImageRowTag"] as! UIImage)
        
        //日付関連を日本標準時にするためのformatter
        let dateFrt = DateFormatter()
        let timeFrt = DateFormatter()
        dateFrt.setTemplate(.date)
        timeFrt.setTemplate(.time)
        
        let name:String = values["EventNameRowTag"] as! String
        let department:String = values["DepartmentNameRowTag"] as! String
        let description:String = values["DescriptionRowTag"] as! String
        let dateStart = dateFrt.string(from:values["DateStartRowTag"] as! Date)
        let dateEnd = dateFrt.string(from:values["DateEndRowTag"] as! Date)
        let timeStart = timeFrt.string(from:values["TimeStartRowTag"] as! Date)
        let timeEnd = timeFrt.string(from:values["TimeEndRowTag"] as! Date)
        let location: String = values["LocationRowTag"] as! String
        let capacity: String = values["CapacityRowTag"] as! String + "名"
        let officer: Bool = values["OfficerRowTag"] as! Bool
        let deadline = dateFrt.string(from:values["DeadlineRowTag"] as! Date)
        
        let message: String =
            "イベント名:" + name + "\n" +
                "発行部署:" + department + "\n" +
                "開催日:" + dateStart.description + "\n" +
                "場所" + location + "\n" +
        "定員" + capacity + "\n" +
        "締切日" + deadline.description
        
        let alert = UIAlertController(title: "この内容で作成します",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定",
                                      style: .default,
                                      handler: {(UIAlertAction)-> Void in
                                        let event = Event(name:name, descriptionText:description, dateStart: dateStart.description, dateEnd: dateEnd.description, timeStart: timeStart.description, timeEnd: timeEnd.description, location: location, departmentName: department, capacity: capacity, officer: officer, deadline: deadline.description)
                                        event.save()
                                        //イベントリストが更新されるのを待つため
                                        sleep(2)
                                        EventManager.sharedInstance.loadList()
                                        //print(EventManager.sharedInstance.getList()[0].id)
                                        self.saveImage(id: EventManager.sharedInstance.getList()[0].id)
                                        
                                        let alertAfter = UIAlertController(title: "作成が確定されました",
                                                                           message: nil,
                                                                           preferredStyle: .alert)
                                        let defaultAction: UIAlertAction = UIKit.UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                                            // ボタンが押された時の処理を書く（クロージャ実装）
                                            (action: UIAlertAction!) -> Void in
                                            print("OK")
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
        
        // 保存ボタン押下時の処理
        func saveImage(id:String) {
            // 画像をリサイズする
//            let imageW : Int = Int(image!.size.width*0.2)
//            let imageH : Int = Int(image!.size.height*0.2)
//            let resizeImage = resize(image: image!, width: imageW, height: imageH)
            
            let fileName = id + ".png"
            
            // 画像をNSDataに変換
            let pngData = NSData(data: UIImagePNGRepresentation(image!)!)
            let file = NCMBFile.file(withName: fileName, data: pngData as Data!) as! NCMBFile
            
            // ファイルストアへ画像のアップロード
            file.saveInBackground({ (error) in
                if error != nil {
                    // 保存失敗時の処理
                } else {
                    // 保存成功時の処理
                }
            }) { (int) in
                // 進行状況を取得するためのBlock
                /* 1-100のpercentDoneを返す */
                /* このコールバックは保存中何度も呼ばれる */
                /*例）*/
                print("\(int)%")
            }

    }
        /*
        func resize (image: UIImage, width: Int, height: Int) -> UIImage {
            let size: CGSize = CGSize(width: width, height: height)
            UIGraphicsBeginImageContext(size)
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return resizeImage!
        }
 */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


