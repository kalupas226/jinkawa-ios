//
//  EventViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/06/28.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import NCMB

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var eventListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventListView.delegate = self
        eventListView.dataSource = self
        
        EventManager.sharedInstance.loadList()
        
        eventListView.register(UINib(nibName:"EventItemViewCell", bundle:nil), forCellReuseIdentifier: "eventItem")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(toEventCreateView))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
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
        cell.date.text = event.day
        cell.location.text = event.location
        cell.publisher.text = event.departmentName
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
