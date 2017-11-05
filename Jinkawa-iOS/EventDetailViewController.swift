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

class EventDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var event:Event = Event() // イベントオブジェクトの保持
    var detailListOrder: Array = ["日程", "場所", "定員", "締切日", "本文"]
    var detailList: Dictionary<String, String> = [:]
    
    @IBOutlet weak var detailTable: UITableView!
    @IBOutlet weak var eventDetailImage: UIImageView!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        }
        
        print(event.name)
        
        detailTable.delegate = self
        detailTable.dataSource = self
        
        let fileData = NCMBFile.file(withName: event.id + ".png" , data: nil) as! NCMBFile
        fileData.getDataInBackground { (data, error) in
            if error != nil {
                // ファイル取得失敗時の処理
            } else {
                // ファイル取得成功時の処理
                let image = UIImage.init(data: data!)
                self.eventDetailImage.image = image
            }
        }
        
        detailList["日程"] = event.day
        detailList["場所"] = event.location
        detailList["定員"] = event.capacity
        detailList["締切日"] = event.deadline
        detailList["本文"] = event.descriptionText
        
        // Labelの設定
        departmentLabel.text = event.departmentName
        departmentLabel.textColor = UIColor.white
        departmentLabel.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        departmentLabel.textAlignment = .center
        updateDateLabel.text = "最終更新日 \(event.updateDate)"
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
        
        //navigationbarの設定
        navigationItem.title = event.name
        if(UserManager.sharedInstance.getState() != .common){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(toParticipantListView))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        // Do any additional setup after loading the view.
    }
    
    func toParticipantListView(){
        performSegue(withIdentifier: "toParticipantList", sender: nil)
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
    }
    
    
    @IBAction func photoUp(_ sender: Any) {
    // 1. create SKPhoto Array from UIImage
    let fileData = NCMBFile.file(withName: event.id + ".png" , data: nil) as! NCMBFile
    fileData.getDataInBackground { (data, error) in
    if error != nil {
    // ファイル取得失敗時の処理
    } else {
    // ファイル取得成功時の処理
    let image = UIImage.init(data: data!)
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(image!)// add some UIImage
        images.append(photo)
        // 2. create PhotoBrowser Instance, and present from your viewController.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        self.present(browser, animated: true, completion: {})
        }
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
