//
//  EventDetailViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/13.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import NCMB

class EventDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var event:Event = Event() // イベントオブジェクトの保持
    var detailList:[String] = []
    
    @IBOutlet weak var detailTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(event.name)
        
        detailTable.delegate = self
        detailTable.dataSource = self
        
        detailList.append(event.name)
        detailList.append(event.day)
        detailList.append(event.location)
        
        // Do any additional setup after loading the view.
        detailTable.register(UINib(nibName:"EventDetailTableViewCell", bundle:nil), forCellReuseIdentifier: "detailCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(toParticipantListView))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func toParticipantListView(){
        performSegue(withIdentifier: "toParticipantList", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailList.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! EventDetailTableViewCell
        cell.title.text = detailList[indexPath.row]

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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
