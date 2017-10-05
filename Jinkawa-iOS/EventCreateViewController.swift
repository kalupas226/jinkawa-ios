//
//  EventCreateViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/16.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import Eureka

class EventCreateViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        form
            +++ Section("イベント情報")
            <<< TextRow("EventNameRowTag") {
                $0.title = "イベント名"
            }
            <<< TextRow("DepartmentNameRowTag") {
                $0.title = "部署"
            }
            <<< TextRow("DescriptionRowTag") {
                $0.title = "説明文"
            }
            <<< DateInlineRow("DayRowTag") {
                $0.title = "開催日"
            }
            <<< TextRow("LocationRowTag") {
                $0.title = "開催場所"
                
            }
        
        
        // If you don't want to use Eureka custom operators ...
        //        let row = NameRow("NameRow") { $0.title = "name" }
        //        let section = Section()
        //        section.append(row)
        //        form.append(section)
        //
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(didTapSaveButton(sender:)))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapSaveButton(sender: UIBarButtonItem) {
        let errors = form.validate()
        guard errors.isEmpty else {
            print("validate errors:", errors)
            return
        }
        
        // Get the value of all rows which have a Tag assigned
        let values = form.values()
        
        let name:String = values["EventNameRowTag"] as! String
        let department:String = values["DepartmentNameRowTag"] as! String
        let description:String = values["DescriptionRowTag"] as! String
        let day:Date = values["DayRowTag"] as! Date
        let location: String = values["LocationRowTag"] as! String
        
        let message: String =
            "イベント名:" + name + "\n" +
                "発行部署:" + department + "\n" +
                "開催日:" + day.description + "\n" +
                "場所" + location
        
        let alert = UIAlertController(title: "この内容で申し込みます",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: {(UIAlertAction)-> Void in
                                        let event = Event(name:name, descriptionText:description, day:day.description, location: location, departmentName: department)
                                        event.save()
        }))
        present(alert, animated: true, completion: nil)
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
