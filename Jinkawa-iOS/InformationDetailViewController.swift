//
//  InformationDetailViewController.swift
//  Jinkawa-iOS
//
//  Created by Hironari Matsui on 2017/10/22.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import NCMB

class InformationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var imformation: Information = Information()
    var detailListOrder: Array = ["日程", "本文"]
    var detailList: Dictionary<String, String> = [:]
    let actionSheet = UIAlertController(
        title:nil,
        message:nil,
        preferredStyle: .actionSheet)
    
    @IBOutlet weak var detailTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        
        detailTable.delegate = self
        detailTable.dataSource = self
        
        detailList["日程"] = imformation.date
        detailList["本文"] = imformation.descriptionText
        
        //CustomCellの登録
        detailTable.register(UINib(nibName:"EventDetailTableViewCell", bundle:nil), forCellReuseIdentifier: "detailCell")
        
        //空のcellの境界線を消す
        detailTable.tableFooterView = UIView(frame: .zero)
        
        //cellの高さを動的に変更する
        detailTable.estimatedRowHeight = 40
        detailTable.rowHeight = UITableViewAutomaticDimension
        
        actionSheet.addAction(
            UIAlertAction(
                title:"お知らせを編集する",
                style: .default,
                handler:{(action)-> Void in
                    self.toInformationEditView()
            })
            )
        
        actionSheet.addAction(
            UIAlertAction(
                title:"お知らせを削除する",
                style: .destructive,
                handler: {(action) -> Void in
                    self.infomationDelete()
            })
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .cancel,
                handler: nil
            )
        )
        //navigationbarの設定
        navigationItem.title = imformation.title
        if(UserManager.sharedInstance.getState() != .common){
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                                target: self,
                                                                action: #selector(showAlert))
            navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailListOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! EventDetailTableViewCell
        cell.category.text = detailListOrder[indexPath.row]
        cell.category.textAlignment = .center
        cell.category.font = UIFont.boldSystemFont(ofSize: 16.0)
        cell.content.text = detailList[detailListOrder[indexPath.row]]
        
        return cell
    }
    
    func showAlert(){
        self.present(
            self.actionSheet,
            animated: true,
            completion:nil)
    }
    
    func infomationDelete(){
        let obj = NCMBObject(className: "Information")
        // objectIdプロパティを設定
        obj?.objectId = self.imformation.id
        // 設定されたobjectIdを元にデータストアからデータを取得
        obj?.fetchInBackground({ (error) in
            if error != nil {
                // 取得に失敗した場合の処理
            }else{
                let alert = UIAlertController(title: "本当に削除しても良いですか",
                                                   message: nil,
                                                   preferredStyle: .alert)
                let defaultAction: UIAlertAction = UIKit.UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                // 取得に成功した場合の処理
                obj?.deleteInBackground({ (error) in
                    if error != nil {
                        // 削除に失敗した場合の処理
                    }else{
                        // 削除に成功した場合の処理
                        let alertAfter = UIAlertController(title: "お知らせが削除されました",
                                                           message: nil,
                                                           preferredStyle: .alert)
                        let defaultAction: UIAlertAction = UIKit.UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                            // ボタンが押された時の処理を書く（クロージャ実装）
                            (action: UIAlertAction!) -> Void in
                            print("OK")
                            //前の画面に遷移する
                            self.navigationController?.popViewController(animated: true)
                        })
                        
                        alertAfter.addAction(defaultAction)
                        self.present(alertAfter, animated: true, completion: nil)
                    }
                })
                }
                )
                let cancelAction: UIAlertAction = UIKit.UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                    (action: UIAlertAction!) -> Void in
                    print("cancel")
                })
                alert.addAction(defaultAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func toInformationEditView(){
        performSegue(withIdentifier: "toInformationEdit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInformationEdit" {
            let InformationEditViewController = segue.destination as! InformationEditViewController
            InformationEditViewController.imformation = imformation
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
