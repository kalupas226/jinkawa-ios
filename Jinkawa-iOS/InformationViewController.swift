//
//  InfomationListViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/07/09.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import NCMB

class InformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var informationListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        informationListView.delegate = self
        informationListView.dataSource = self
        
        InformationManager.sharedInstance.loadList()
        
        informationListView.register(UINib(nibName:"InformationItemViewCell", bundle:nil), forCellReuseIdentifier: "informationItem")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(toEventCreateView))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // Do any additional setup after loading the view.
    }
    
    func toEventCreateView(){
        performSegue(withIdentifier: "toInformationCreate", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "toEventDetail", sender: EventManager.sharedInstance.getList()[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InformationManager.sharedInstance.getList().count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationItem", for: indexPath) as! InformationItemViewCell
        let information:Information = InformationManager.sharedInstance.getList()[indexPath.row]
        
        cell.title.text = information.title
        cell.date.text = information.date
        cell.publisher.text = information.departmentName
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
