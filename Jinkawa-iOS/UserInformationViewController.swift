//
//  UserInformationViewController.swift
//  Jinkawa-iOS
//
//  Created by Hironari Matsui on 2017/11/14.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit

class UserInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userInformationTable: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var userInformation = UserDefaults.standard.dictionary(forKey: "userInformation")
    let userInformationCategory = ["名前","性別","年齢","電話番号","住所"]
    let userInformationOrder = ["NameRowTag", "GenderRowTag", "AgeRowTag", "PhoneRowTag", "AddressRowTag"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        userInformationTable.delegate = self
        userInformationTable.dataSource = self
        
        userInformationTable.register(UINib(nibName:"EventDetailTableViewCell", bundle:nil), forCellReuseIdentifier: "detailCell")
        
        userInformationTable.tableFooterView = UIView(frame: .zero)
        
        userInformationTable.estimatedRowHeight = 40
        userInformationTable.rowHeight = UITableViewAutomaticDimension
        
        titleLabel.text = "入力情報の確認"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton(sender:)), for: .touchUpInside)
        
        let userAge = userInformation!["AgeRowTag"] as! Int
        userInformation!["AgeRowTag"] = String(userAge)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            if tag == 1 {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! EventDetailTableViewCell
        cell.category.text = userInformationCategory[indexPath.row]
        //cell.category.textAlignment = .center
        cell.category.font = UIFont.boldSystemFont(ofSize: 16.0)
        print("\(String(describing: userInformation![userInformationOrder[indexPath.row]]))")
        cell.content.text = userInformation![userInformationOrder[indexPath.row]] as? String
        
        return cell
    }
    
    func didTapDeleteButton(sender:UIButton){
        let alertController = UIAlertController(title: "入力情報の消去", message: "入力情報を消去しますか", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default){ (action: UIAlertAction) in
            //入力情報の消去
            UserDefaults.standard.removeObject(forKey: "userInformation")
            
            let alertController = UIAlertController(title: "入力情報の消去", message: "入力情報を消去しました", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default){ (action: UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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
