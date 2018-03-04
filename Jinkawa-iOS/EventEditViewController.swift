//
//  EventEditViewController.swift
//  Jinkawa-iOS
//
//  Created by Kenta Aikawa on 2017/11/19.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import Eureka
import NCMB
import Alamofire
import AlamofireImage
import SVProgressHUD

class EventEditViewController: FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var image:UIImage? = nil
    var event: Event = Event()
    //日付関連を日本標準時にするためのformatter
    let dateFrt = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                $0.value = event.name
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
                if(UserManager.sharedInstance.getState() == .admin){
                    $0.options = ["役員","総務部","青少年育成部","女性部","福祉部","Jバス部","環境部","交通部","防火防犯部"]
                }else{
                    $0.options = LoginViewController.userAuth
                }
                $0.value = event.departmentName   // initially selected
            }
            <<< SwitchRow("OfficerRowTag"){
                $0.title = "役員のみに公開"
                $0.value = event.officer
            }
            +++ Section("イベント日程")
            <<< DateInlineRow("DateStartRowTag") {
                $0.title = "開始日"
                dateFrt.setTemplate(.date)
                $0.value = dateFrt.date(from:event.dateStart)
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
                dateFrt.setTemplate(.time)
                $0.value = dateFrt.date(from:event.timeStart)
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
                dateFrt.setTemplate(.date)
                $0.value = dateFrt.date(from:event.dateEnd)
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
                dateFrt.setTemplate(.time)
                $0.value = dateFrt.date(from:event.timeEnd)
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
                $0.title = "申し込み締切日"
                dateFrt.setTemplate(.date)
                $0.value = dateFrt.date(from:event.deadline)
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
                                $0.title = "申し込み締切日を選択してください"
                                $0.cell.height = { 30 }
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            +++ Section ("イベント詳細情報")
            <<< TextAreaRow("DescriptionRowTag") {
                $0.placeholder = "イベント説明文"
                $0.value = event.descriptionText
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
            <<< ImageRow("ImageRowTag") { row in
                row.title = "イベント画像"
                let imageURL:String = "https://mb.api.cloud.nifty.com/2013-09-01/applications/81CA63sCDMxLez1p/publicFiles/" + event.id + ".png"
                let url = URLRequest(url: URL(string: imageURL)!)
                Alamofire.request(url).responseData(completionHandler: { response in
                    if let imageData = response.data
                    {
                        let image = UIImage(data: imageData)
                        row.value = image
                    }
                })
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnBlur
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
                $0.value = event.location
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
            <<< IntRow("CapacityRowTag"){
                $0.title = "定員"
                $0.value = Int(event.capacity)
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
        let capacity: Int = values["CapacityRowTag"] as! Int
        let officer: Bool = values["OfficerRowTag"] as! Bool
        let deadline = dateFrt.string(from:values["DeadlineRowTag"] as! Date)
        
        var message: String =
            "イベント名:" + name + "\n" +
                "発行部署:" + department + "\n" +
                "開始日:" + dateStart.description + "\n" +
                "開始時間:" + timeStart.description + "\n" +
                "終了日:" + dateEnd.description + "\n" +
                "終了時間:" + timeEnd.description + "\n" +
                "場所:" + location + "\n" +
                "定員:" + capacity.description + "\n" +
                "締切日:" + deadline.description
        
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
                                        let obj = NCMBObject(className: "Event")
                                        // objectIdプロパティを設定
                                        obj?.objectId = self.event.id
                                        // 設定されたobjectIdを元にデータストアからデータを取得
                                        obj?.fetchInBackground({ (error) in
                                            if error != nil {
                                                // 取得に失敗した場合の処理
                                            }else{
                                                // 取得に成功した場合の処理
                                                obj?.setObject(name, forKey: "name")
                                                obj?.setObject(description, forKey: "description")
                                                obj?.setObject(dateStart, forKey: "date_start")
                                                obj?.setObject(dateEnd, forKey: "date_end")
                                                obj?.setObject(timeStart, forKey: "start_time")
                                                obj?.setObject(timeEnd, forKey: "end_time")
                                                obj?.setObject(location, forKey: "location")
                                                obj?.setObject(department, forKey: "department")
                                                obj?.setObject(capacity.description, forKey: "capacity")
                                                obj?.setObject(officer, forKey: "officer_only")
                                                obj?.setObject(deadline, forKey: "deadline_day")
                                                
                                                obj?.saveInBackground({ (error) in
                                                    if error != nil {
                                                        // 更新に失敗した場合の処理
                                                    }else{
                                                        // 更新に成功した場合の処理
                                                        EventManager.sharedInstance.loadList()
                                                        self.saveImage(id: self.event.id)
                                                        self.af_setImageIgnoreCache(string: "https://mb.api.cloud.nifty.com/2013-09-01/applications/zUockxBwPHqxceBH/publicFiles/" + self.event.id + ".png")
                                                        //プッシュ通知の処理
                                                        let push = NCMBPush()
                                                        let data_iOS = ["contentAvailable" : false, "badgeIncrementFlag" : true, "sound" : "default"] as [String : Any]
                                                        push.setData(data_iOS)
                                                        push.setPushToIOS(true)
                                                        push.setTitle(name)
                                                        push.setMessage("イベントが更新されました!")
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
                                                        pushA.setTitle(name)
                                                        pushA.setMessage("イベントが更新されました!")
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
                                                        
                                                        
                                                        // (例)更新したデータの出力
                                                        print(obj! as NCMBObject)
                                                    }
                                                })
                                            }
                                        })
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
        var pngData: NSData
        // 画像をリサイズする(任意)
        /* Basic会員は５MB、Expert会員は100GBまでのデータを保存可能です */
        /* 上限を超えてしまうデータの場合はリサイズが必要です */
        let imgData: NSData = NSData(data: UIImageJPEGRepresentation((image)!, 1)!)
        let imageSize: Int = imgData.length
        print(imageSize)
        print("size of image in KB: %f ", Double(imageSize) / 1024.0)
        //もしファイルサイズが大きすぎれば
        if(Double(imageSize)/1024.0>2000){
            let imageW : Int = Int(image!.size.width*0.2) /* 20%に縮小 */
            let imageH : Int = Int(image!.size.height*0.2) /* 20%に縮小 */
            let resizeImage = resize(image: image!, width: imageW, height: imageH)
            // 画像をNSDataに変換
            pngData = NSData(data: UIImagePNGRepresentation(resizeImage)!)
        }else{
            pngData = NSData(data: UIImagePNGRepresentation(image!)!)
        }
        let fileName = id + ".png"
        let file = NCMBFile.file(withName: fileName, data: pngData as Data!) as! NCMBFile
        
        // ファイルストアへ画像のアップロード
        file.saveInBackground({ (error) in
            if error != nil {
                // 保存失敗時の処理
            } else {
                // 保存成功時の処理
            }
        }) { (int) in
            var sw = 0
            // 進行状況を取得するためのBlock
            /* 1-100のpercentDoneを返す */
            /* このコールバックは保存中何度も呼ばれる */
            /*例）*/
            SVProgressHUD.show(withStatus: String(int) + "%")
            //アップロード完了したら終了
            if(int == 100){
                sw = 1
                SVProgressHUD.dismiss()
            }
            if(sw == 1){
                let alertAfter = UIAlertController(title: "更新が確定されました",
                                                   message: nil,
                                                   preferredStyle: .alert)
                let defaultAction: UIAlertAction = UIKit.UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    print("OK")
                    //一覧画面に遷移する
                    self.navigationController?.popToViewController(self.navigationController!.viewControllers[2], animated: true)
                })
                
                alertAfter.addAction(defaultAction)
                self.present(alertAfter, animated: true, completion: nil)
            }
            print("\(int)%")
        }
        
    }
    
    // 画像をリサイズする処理
    func resize (image: UIImage, width: Int, height: Int) -> UIImage {
        let size: CGSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizeImage!
    }
    
    // 更新した画像のキャッシュを削除する処理
    func af_setImageIgnoreCache(string: String?) {
        guard let url = string, let nsurl = URL(string: url) else { return }
        let urlRequest = URLRequest(url: nsurl, cachePolicy: .reloadIgnoringCacheData)
        
        let imageDownloader = ImageDownloader.default
        if let imageCache = imageDownloader.imageCache as? AutoPurgingImageCache, let urlCache = imageDownloader.sessionManager.session.configuration.urlCache {
            _ = imageCache.removeImages(matching: urlRequest)
            urlCache.removeCachedResponse(for: urlRequest)
        }
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



