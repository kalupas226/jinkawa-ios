//
//  EventViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/06/28.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import NCMB
import AlamofireImage

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var eventListView: UITableView!
    //リフレッシュコントロールを作成する。
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //インジケーターの下に表示する文字列を設定する。
        refresh.attributedTitle = NSAttributedString(string: "読込中")
        //インジケーターの色を設定する。
        refresh.tintColor = UIColor.blue
        //テーブルビューを引っ張ったときの呼び出しメソッドを登録する。
        refresh.addTarget(self, action: #selector(EventViewController.refreshTable), for: UIControlEvents.valueChanged)
        //テーブルビューコントローラーのプロパティにリフレッシュコントロールを設定する。
        eventListView.refreshControl = refresh
        
        eventListView.delegate = self
        eventListView.dataSource = self
        
        EventManager.sharedInstance.loadList()
        
        eventListView.register(UINib(nibName:"EventItemViewCell", bundle:nil), forCellReuseIdentifier: "eventItem")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.title = "イベント"
        if(UserManager.sharedInstance.getState() != .common){
            tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                                  target: self,
                                                                                  action: #selector(toEventCreateView))
            tabBarController?.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    func toEventCreateView(){
        performSegue(withIdentifier: "toEventCreate", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toEventDetail", sender: EventManager.sharedInstance.getList()[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventManager.sharedInstance.getList().count
        
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            array.remove(at: indexPath.row)
    //            tableView.deleteRows(at: [indexPath], with: .fade)
    //        }
    //    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventItem", for: indexPath) as! EventItemViewCell
        let event = EventManager.sharedInstance.getList()[indexPath.row]
        
        cell.title.text = event.name
        cell.title.sizeToFit()
        cell.date.text = "開始日 \(event.dateStart)"
        cell.location.text = event.location
        cell.publisher.text = event.departmentName
        switch event.departmentName {
        case "役員": cell.publisher.backgroundColor = UIColor.colorWithHexString("ce1d1c")
        case "総務部": cell.publisher.backgroundColor = UIColor.colorWithHexString("cc4454")
        case "青少年育成部": cell.publisher.backgroundColor = UIColor.colorWithHexString("4b93bc")
        case "女性部": cell.publisher.backgroundColor = UIColor.colorWithHexString("d45273")
        case "福祉部": cell.publisher.backgroundColor = UIColor.colorWithHexString("d96047")
        case "環境部": cell.publisher.backgroundColor = UIColor.colorWithHexString("3ba88d")
        case "防火防犯部": cell.publisher.backgroundColor = UIColor.colorWithHexString("1e2952")
        case "交通部": cell.publisher.backgroundColor = UIColor.colorWithHexString("00913a")
        case "Jバス部": cell.publisher.backgroundColor = UIColor.colorWithHexString("4cacd9")
        default:
            cell.publisher.backgroundColor = UIColor.colorWithHexString("ce1d1c")
        }
        
        cell.publisher.sizeToFit()
        cell.publisher.layer.cornerRadius = 3
        cell.publisher.clipsToBounds = true
        
        // タイムゾーンを言語設定にあわせる
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // 上記の形式の日付文字列から日付データを取得します。
        let d:Date = formatter.date(from: event.updateDate)!
        
        let dateFrt = DateFormatter()
        dateFrt.setTemplate(.yer)
        let updateYear = dateFrt.string(from: d)
        dateFrt.setTemplate(.mon)
        let updateMonth = dateFrt.string(from: d)
        dateFrt.setTemplate(.day)
        let updateDay = dateFrt.string(from: d)
        
        let updateDate = updateYear + updateMonth + updateDay
        
        cell.updateDate.text = "最終更新日 \(updateDate)"
        
        //役員専用のセルを隠す
        if(UserManager.sharedInstance.getState() == .common){
            if(event.officer == true){
                cell.isHidden = true
            }
        }
        
        let imageURL:String = "https://mb.api.cloud.nifty.com/2013-09-01/applications/zUockxBwPHqxceBH/publicFiles/" + event.id + ".png"
        let url = URL(string: imageURL)!
        cell.eveImage.af_setImage(
            withURL: url,
            placeholderImage: UIImage(named: "iron.png")
        )
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEventDetail"{
            let eventDetailViewController = segue.destination as! EventDetailViewController
            eventDetailViewController.event = sender as! Event
        }
    }
    
    //役員専用のセルの高さを0にする
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let event:Event = EventManager.sharedInstance.getList()[indexPath.row]
        if(UserManager.sharedInstance.getState() == .common){
            if(event.officer == true){
                return 0
            }else{
                return 121.5
            }
        }else{
            return 121.5
        }
    }
    
    func refreshTable()
    {
        EventManager.sharedInstance.loadList()
        refresh.endRefreshing()
        self.eventListView.reloadData()
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
