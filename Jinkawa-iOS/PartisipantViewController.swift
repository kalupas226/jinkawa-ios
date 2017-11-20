//
//  PartisitantViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/15.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import NCMB

class PartisipantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var participantTable: UITableView!
    var event: Event = Event()
    lazy var participantList:[Participant] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        
        participantTable.delegate = self
        participantTable.dataSource = self
        
        ParticipantManager.sharedInstance.loadList()
        participantList = ParticipantManager.sharedInstance.getList(event_id: self.event.id)
        print(participantList)
        
        participantTable.register(UINib(nibName: "ParticipantTableViewCell", bundle: nil), forCellReuseIdentifier: "participantCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize,
                                                            target: self,
                                                            action: #selector(uploadCSV))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = participantTable.dequeueReusableCell(withIdentifier: "participantCell") as! ParticipantTableViewCell
        let participant = participantList[indexPath.row]
        
        cell.nameLabel.text = "氏名:" + participant.name + " " + participant.gender
        cell.phoneLabel.text = "電話番号:" + participant.tell
        cell.addressLabel.text = "住所:" + participant.address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participantList.count;
    }
    
    func uploadCSV(){
        var data = event.name + "," + event.dateStart + "," + event.location + "," + event.departmentName
        data += "\r\n"
        data += " "
        data += "\r\n"
        data += "氏名,年齢,性別,電話番号,住所"
        data += "\r\n"
        
        participantList.forEach {
            var sep:String  = ""
            data += sep + $0.name
            sep = ","
            data += sep + $0.age
            data += sep + $0.gender
            data += sep + $0.tell
            data += sep + $0.address
            data += "\r\n"
        }
        
        let file = NCMBFile.file(withName: event.id + ".csv", data: data.data(using: String.Encoding.utf8)) as! NCMBFile
        file.save(nil)
        print("File Saved.")
        tapShare(fileName: event.id)
    }
    
    func tapShare(fileName: String) {
        // 共有する項目
        let shareTitle = "こちらのURLからCSVファイルをダウンロードすることができます。"
        let shareURL = NSURL(string: "https://mb.api.cloud.nifty.com/2013-09-01/applications/zUockxBwPHqxceBH/publicFiles/" + fileName + ".csv")
        let shareItems = [shareTitle,shareURL!] as [Any]
        
        let avc = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivityType.postToWeibo,
            UIActivityType.saveToCameraRoll,
            UIActivityType.print,
            UIActivityType.copyToPasteboard,
            UIActivityType.assignToContact,
            UIActivityType.addToReadingList
        ]
        avc.excludedActivityTypes = excludedActivityTypes
        
        present(avc, animated: true, completion: nil)
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
