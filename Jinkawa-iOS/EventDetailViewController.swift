//
//  EventDetailViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/13.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import NCMB
import SKPhotoBrowser
import Alamofire
import AlamofireImage

class EventDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var event:Event = Event() // イベントオブジェクトの保持
    var detailListOrder: Array = ["開始日", "開始時間", "終了日", "終了時間", "場所", "定員", "締切日", "本文"]
    var detailList: Dictionary<String, String> = [:]
    let actionSheet = UIAlertController(
        title:nil,
        message:nil,
        preferredStyle: .actionSheet)
    
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var eventDetailImage: UIImageView!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(event.name)
        
        detailTable.delegate = self
        detailTable.dataSource = self
        
        let imageURL:String = "https://mb.api.cloud.nifty.com/2013-09-01/applications/zUockxBwPHqxceBH/publicFiles/" + event.id + ".png"
        let url = URL(string: imageURL)!
        self.eventDetailImage.af_setImage(
            withURL: url,
            placeholderImage: UIImage(named: "iron.png")
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title:"イベントを編集する",
                style: .default,
                handler:{(action)-> Void in
                    self.toEventEditView()
            })
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title:"イベントを削除する",
                style: .destructive,
                handler: {(action) -> Void in
                    self.eventDelete()
            })
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title:"イベント参加者一覧を見る",
                style: .default,
                handler: {(action) -> Void in
                    self.toParticipantListView()
            })
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .cancel,
                handler: nil
            )
        )
        
        detailList["開始日"] = event.dateStart
        detailList["開始時間"] = event.timeStart
        detailList["終了日"] = event.dateEnd
        detailList["終了時間"] = event.timeEnd
        detailList["場所"] = event.location
        detailList["定員"] = event.capacity + "名"
        detailList["締切日"] = event.deadline
        detailList["本文"] = event.descriptionText
        
        // Labelの設定
        departmentLabel.text = event.departmentName
        departmentLabel.textColor = UIColor.white
        switch event.departmentName {
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
        
        // 日付のフォーマット設定
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // 日付文字列をDate型に変更
        let d:Date = formatter.date(from: event.updateDate)!
        
        //フォーマット変更
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let updateDate = formatter.string(from: d)
        
        updateDateLabel.text = "最終更新日 \(updateDate)"
        updateDateLabel.textColor = UIColor.white
        updateDateLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        updateDateLabel.textAlignment = .center
        
        //CustomCellの登録
        detailTable.register(UINib(nibName:"EventDetailTableViewCell", bundle:nil), forCellReuseIdentifier: "detailCell")
        
        //空のcellの境界線を消す
        detailTable.tableFooterView = UIView(frame: .zero)
        
        //cellの高さを動的に変更する
        detailTable.estimatedRowHeight = 40
        detailTable.rowHeight = UITableViewAutomaticDimension
        
        //navigationbarの設定
        navigationItem.title = event.name
        
        if(UserManager.sharedInstance.getState() == .admin){
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                                target: self,
                                                                action: #selector(showAlert))
            navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else if(UserManager.sharedInstance.getState() == .officer){
            for department in LoginViewController.userAuth{
                if(event.departmentName == department){
                    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                                        target: self,
                                                                        action: #selector(showAlert))
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func showAlert(){
        self.present(
            self.actionSheet,
            animated: true,
            completion:nil)
    }
    
    func toParticipantListView(){
        performSegue(withIdentifier: "toParticipantList", sender: nil)
    }
    
    func toEventEditView(){
        performSegue(withIdentifier: "toEventEdit", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailListOrder.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! EventDetailTableViewCell
        cell.category.text = detailListOrder[indexPath.row]
        cell.category.textAlignment = .center
        cell.category.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell.content.text = detailList[detailListOrder[indexPath.row]]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEntry" {
            let entryViewController = segue.destination as! EntryViewController
            entryViewController.event_id = event.id
        }
        if segue.identifier == "toParticipantList" {
            let participantViewController = segue.destination as! PartisipantViewController
            participantViewController.event = event
        }
        if segue.identifier == "toEventEdit" {
            let EventEditViewController = segue.destination as! EventEditViewController
            EventEditViewController.event = event
        }
    }
    
    func eventDelete(){
        let obj = NCMBObject(className: "Event")
        // objectIdプロパティを設定
        obj?.objectId = self.event.id
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
                            
                            //ファイルストアから画像を削除する
                            // ファイルストアを検索するクエリを作成
                            let imageQuery = NCMBFile.query()
                            // 検索するファイル名を設定
                            imageQuery?.whereKey("fileName", equalTo: self.event.id + ".png")
                            // ファイルストアの検索を実行
                            imageQuery?.findObjectsInBackground({ (files, error) in
                                if error != nil {
                                    // 検索失敗時の処理
                                } else {
                                    // 検索成功時の処理
                                    for file in files! as! [NCMBFile] {
                                        file.getDataInBackground({ (data, error) in
                                            if error != nil {
                                                // ファイル取得失敗時の処理
                                                print("画像が見つかりませんでした")
                                            } else {
                                                // ファイル取得成功時の処理
                                                file.deleteInBackground(nil)
                                            }
                                        })
                                    }
                                }
                            })
                            
                            //データストアから該当する参加者を削除する
                            let participantsQuery = NCMBQuery(className: "Participants")
                            //削除する参加者を絞り込むための条件
                            participantsQuery?.whereKey("eventID", equalTo: self.event.id)
                            // データストアの検索を実施
                            participantsQuery?.findObjectsInBackground({(files, error) in
                                if (error != nil){
                                    // 検索失敗時の処理
                                }else{
                                    // 検索成功時の処理
                                    for file in files! as! [NCMBObject] {
                                        file.deleteInBackground({ (error) in
                                            if error != nil {
                                                // 削除に失敗した場合の処理
                                                print("削除に失敗しました")
                                            }else{
                                                // 削除に成功した場合の処理
                                                print("削除に成功しました")
                                            }
                                        })
                                    }
                                }
                            })
                            
                            let alertAfter = UIAlertController(title: "イベントが削除されました",
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
    
    
    @IBAction func photoUp(_ sender: Any) {
        // 1. create SKPhoto Array from UIImage
        let imageURL:String = "https://mb.api.cloud.nifty.com/2013-09-01/applications/zUockxBwPHqxceBH/publicFiles/" + event.id + ".png"
        // 1. create URL Array
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(imageURL)
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        
        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: {})
        
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



