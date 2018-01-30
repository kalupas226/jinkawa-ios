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
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.title = "お知らせ"
        if(UserManager.sharedInstance.getState() != .common){
            tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector(toEventCreateView))
            tabBarController?.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
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
        
        cell.title.text = cutString(str: information.title, maxLength: 8)
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
        
        // タイムゾーンを言語設定にあわせる
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // 上記の形式の日付文字列から日付データを取得します。
        let d:Date = formatter.date(from: information.updateDate)!
        
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
    
    //下に画面を引っ張り続けると、画面を更新する関数
    func refreshTable()
    {
        InformationManager.sharedInstance.loadList()
        refresh.endRefreshing()
        self.informationListView.reloadData()
    }
    
    //長すぎる文字をカットするための関数
    func cutString(str: String, maxLength: Int) -> String {
        if str.count > maxLength {
            // 最大文字数をオーバーする場合
            // 省略する範囲を作成する
            let start = str.index(str.startIndex, offsetBy: maxLength)  // 開始位置
            let end = str.endIndex                                      // 終了位置
            // 開始位置と終了位置からRangeを作成
            let range = start..<end
            
            // 作成した範囲(最大文字数をオーバーする範囲)を「…」に置き換えて表示
            return str.replacingCharacters(in: range, with: "…")
            
        } else {
            // 最大文字数をオーバーしない場合は、そのまま表示
            return str
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
