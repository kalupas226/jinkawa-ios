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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
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
        switch information.type {
        case "注意": cell.infoImage.image = UIImage(named:"caution.png")
        case "買い物": cell.infoImage.image = UIImage(named:"shopping.png")
        case "緊急": cell.infoImage.image = UIImage(named:"alert.png")
        case "告知": cell.infoImage.image = UIImage(named:"info.png")
        case "バス": cell.infoImage.image = UIImage(named:"bus.png")
        default: cell.infoImage.image = UIImage(named:"info.png")
        }
        switch information.departmentName {
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
        
        //役員専用のセルを隠す
        if(UserManager.sharedInstance.getState() == .common){
            if(information.officer == true){
                cell.isHidden = true
            }
        }
        return cell
    }
    
    //役員専用のセルの高さを0にする
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let information:Information = InformationManager.sharedInstance.getList()[indexPath.row]
        if(UserManager.sharedInstance.getState() == .common){
            if(information.officer == true){
                return 0
            }else{
                return 121.5
            }
        }else{
                return 121.5
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInformationDetail"{
            let informationDetailViewController = segue.destination as! InformationDetailViewController
            informationDetailViewController.information = sender as! Information
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
