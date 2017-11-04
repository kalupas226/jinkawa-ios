//
//  InformationDetailViewController.swift
//  Jinkawa-iOS
//
//  Created by narihiro on 2017/10/22.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit

class InformationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var imformation: Information = Information()
    var detailList:[String] = []
    
    @IBOutlet weak var detailTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        //空のセルの境界線を消す
        detailTable.tableFooterView = UIView(frame: .zero)
        
        detailTable.delegate = self
        detailTable.dataSource = self
        
        detailList.append(imformation.title)
        detailList.append(imformation.date)
        detailList.append(imformation.descriptionText)
        
        detailTable.register(UINib(nibName:"EventDetailTableViewCell", bundle:nil), forCellReuseIdentifier: "detailCell")
        
        //cellの高さを動的に変更する
        detailTable.estimatedRowHeight = 40
        detailTable.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! EventDetailTableViewCell
        cell.content.text = detailList[indexPath.row]
        cell.content.sizeToFit()
        
        return cell
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
