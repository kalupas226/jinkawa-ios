//
//  InformationDetailViewController.swift
//  Jinkawa-iOS
//
//  Created by Hironari Matsui on 2017/10/22.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import NCMB

class InformationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var information: Information = Information()
    var detailListOrder: Array = ["本文"]
    var detailList: Dictionary<String, String> = [:]
    let actionSheet = UIAlertController(
        title:nil,
        message:nil,
        preferredStyle: .actionSheet)
    
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTable.delegate = self
        detailTable.dataSource = self
        
        detailList["本文"] = information.descriptionText
        
        // Labelの設定
        departmentLabel.text = information.departmentName
        departmentLabel.textColor = UIColor.white
        switch information.departmentName {
        case "役員": departmentLabel.backgroundColor = UIColor.colorWithHexString("ce1d1c")
        case "総務部": departmentLabel.backgroundColor = UIColor.colorWithHexString("cc4454")
        case "青少年育成部": departmentLabel.backgroundColor = UIColor.colorWithHexString("4b93bc")
        case "女性部": departmentLabel.backgroundColor = UIColor.colorWithHexString("d45273")
        case "福祉部": departmentLabel.backgroundColor = UIColor.colorWithHexString("d96047")
        case "環境部": departmentLabel.backgroundColor = UIColor.colorWithHexString("3ba88d")
        case "防火防犯部": departmentLabel.backgroundColor = UIColor.colorWithHexString("1e2952")
        case "交通部": departmentLabel.backgroundColor = UIColor.colorWithHexString("00913a")
        case "Jバス部": departmentLabel.backgroundColor = UIColor.colorWithHexString("4cacd9")
        default:
            departmentLabel.backgroundColor = UIColor.colorWithHexString("ce1d1c")
        }
        departmentLabel.sizeToFit()
        departmentLabel.textAlignment = .center
        
        // タイムゾーンを言語設定にあわせる
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // 上記の形式の日付文字列から日付データを取得します。
        let d:Date = formatter.date(from: information.updateDate)!
        print(d)
        
        let dateFrt = DateFormatter()
        dateFrt.setTemplate(.yer)
        let updateYear = dateFrt.string(from: d)
        dateFrt.setTemplate(.mon)
        let updateMonth = dateFrt.string(from: d)
        dateFrt.setTemplate(.day)
        let updateDay = dateFrt.string(from: d)
        dateFrt.setTemplate(.time)
        let updateTime = dateFrt.string(from: d)
        
        print(updateYear + "/" + updateMonth + "/" + updateDay + " " + updateTime)
        
        let updateDate = updateYear + updateMonth + updateDay + updateTime
        
        updateDateLabel.text = "最終更新日 \(updateDate)"
        updateDateLabel.textColor = UIColor.white
        updateDateLabel.backgroundColor = UIColor.gray
        updateDateLabel.textAlignment = .center
        
        //CustomCellの登録
        detailTable.register(UINib(nibName:"EventDetailTableViewCell", bundle:nil), forCellReuseIdentifier: "detailCell")
        
        //空のcellの境界線を消す
        detailTable.tableFooterView = UIView(frame: .zero)
        
        //cellの高さを動的に変更する
        detailTable.estimatedRowHeight = 40
        detailTable.rowHeight = UITableViewAutomaticDimension
        
        actionSheet.addAction(
            UIAlertAction(
                title:"お知らせを編集する",
                style: .default,
                handler:{(action)-> Void in
                    self.toInformationEditView()
            })
        )
        
        switch information.type{
        case "注意": infoImage.image = UIImage(named:"caution.png")
        case "買い物": infoImage.image = UIImage(named:"shopping.png")
        case "緊急": infoImage.image = UIImage(named:"alert.png")
        case "告知": infoImage.image = UIImage(named:"info.png")
        case "バス": infoImage.image = UIImage(named:"bus.png")
        default: infoImage.image = UIImage(named:"info.png")
        }
        
        actionSheet.addAction(
            UIAlertAction(
                title:"お知らせを削除する",
                style: .destructive,
                handler: {(action) -> Void in
                    self.infomationDelete()
            })
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .cancel,
                handler: nil
            )
        )
        //navigationbarの設定
        navigationItem.title = information.title
        
        if(UserManager.sharedInstance.getState() == .admin){
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                                target: self,
                                                                action: #selector(showAlert))
            navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else if(UserManager.sharedInstance.getState() == .officer){
            for department in LoginViewController.userAuth{
                if(information.departmentName == department){
                    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                                        target: self,
                                                                        action: #selector(showAlert))
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailListOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! EventDetailTableViewCell
        cell.category.text = detailListOrder[indexPath.row]
        cell.category.textAlignment = .center
        cell.category.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell.content.text = detailList[detailListOrder[indexPath.row]]
        
        return cell
    }
    
    func showAlert(){
        self.present(
            self.actionSheet,
            animated: true,
            completion:nil)
    }
    
    func infomationDelete(){
        let obj = NCMBObject(className: "Information")
        // objectIdプロパティを設定
        obj?.objectId = self.information.id
        // 設定されたobjectIdを元にデータストアからデータを取得
        obj?.fetchInBackground({ (error) in
            if error != nil {
                // 取得に失敗した場合の処理
            }else{
                let alert = UIAlertController(title: "本当に削除しても良いですか",
                                              message: nil,
                                              preferredStyle: .alert)
                let defaultAction: UIAlertAction = UIKit.UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    // 取得に成功した場合の処理
                    obj?.deleteInBackground({ (error) in
                        if error != nil {
                            // 削除に失敗した場合の処理
                        }else{
                            // 削除に成功した場合の処理
                            let alertAfter = UIAlertController(title: "お知らせが削除されました",
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
                        }
                    })
                }
                )
                let cancelAction: UIAlertAction = UIKit.UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                    (action: UIAlertAction!) -> Void in
                    print("cancel")
                })
                alert.addAction(defaultAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func toInformationEditView(){
        performSegue(withIdentifier: "toInformationEdit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInformationEdit" {
            let InformationEditViewController = segue.destination as! InformationEditViewController
            InformationEditViewController.information = information
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
