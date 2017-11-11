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
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        
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
        
        if(UserManager.sharedInstance.getState() != .common){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(toEventCreateView))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        // Do any additional setup after loading the view.
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventItem", for: indexPath) as! EventItemViewCell
        let event = EventManager.sharedInstance.getList()[indexPath.row]
        
        cell.title.text = event.name
        cell.title.sizeToFit()
        cell.date.text = event.dateStart
        cell.location.text = event.location
        cell.publisher.text = event.departmentName
        cell.publisher.sizeToFit()
        cell.publisher.layer.cornerRadius = 3
        cell.publisher.clipsToBounds = true
        
        //役員専用のセルを隠す
        if(UserManager.sharedInstance.getState() == .common){
            if(event.officer == true){
                cell.isHidden = true
            }
        }
        
        /*
        let fileData = NCMBFile.file(withName: event.id + ".png" , data: nil) as! NCMBFile
        fileData.getDataInBackground { (data, error) in
            if error != nil {
                // ファイル取得失敗時の処理
            } else {
                // ファイル取得成功時の処理
                let image = UIImage.init(data: data!)
                cell.eveImage.image = image
            }
        }
         */
        let imageURL:String = "https://mb.api.cloud.nifty.com/2013-09-01/applications/zUockxBwPHqxceBH/publicFiles/" + event.id + ".png"
        let url = URL(string: imageURL)!
        cell.eveImage.af_setImage(
            withURL: url
//            placeholderImage: UIImage(named: "event_sample")
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
