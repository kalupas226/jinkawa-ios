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
        refresh.addTarget(self, action: #selector(InformationViewController.refreshTable), for: UIControlEvents.valueChanged)
        //テーブルビューコントローラーのプロパティにリフレッシュコントロールを設定する。
        informationListView.refreshControl = refresh
        
        informationListView.delegate = self
        informationListView.dataSource = self
        
        InformationManager.sharedInstance.loadList()
        
        informationListView.register(UINib(nibName:"InformationItemViewCell", bundle:nil), forCellReuseIdentifier: "informationItem")
        
        if(UserManager.sharedInstance.getState() != .common){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(toEventCreateView))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        // Do any additional setup after loading the view.
    }
    
    func toEventCreateView(){
        performSegue(withIdentifier: "toInformationCreate", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toInformationDetail", sender: InformationManager.sharedInstance.getList()[indexPath.row])
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
        cell.publisher.sizeToFit()
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInformationDetail"{
            let imformationDetailViewController = segue.destination as! InformationDetailViewController
            imformationDetailViewController.imformation = sender as! Information
        }
    }
    
    func refreshTable()
    {
        InformationManager.sharedInstance.loadList()
        refresh.endRefreshing()
        self.informationListView.reloadData()
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
