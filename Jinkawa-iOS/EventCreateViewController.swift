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
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }

        form
            +++ Section("イベント情報")
            <<< TextRow("EventNameRowTag") {
                $0.title = "イベント名"
            }
            <<< PickerInlineRow<String>("DepartmentNameRowTag") {
                $0.title = "部署"
                $0.options = ["役員","総務部","青少年育成部","女性部","福祉部","Jバス部","環境部","交通部","防火防犯部"]
                $0.value = "総務部"    // initially selected
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
            <<< TextRow("CapacityRowTag"){
                $0.title = "定員"
                $0.placeholder = "(例)20"
        }
            <<< DateInlineRow("DeadlineRowTag"){
                $0.title = "締切日"
            }
            <<< SwitchRow("OfficerRowTag"){
                $0.title = "役員のみに公開"
                $0.value = false
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
        let capacity: String = values["CapacityRowTag"] as! String + "名"
        let officer: Bool = values["OfficerRowTag"] as! Bool
        let deadline: Date = values["DeadlineRowTag"] as! Date
        
        let message: String =
            "イベント名:" + name + "\n" +
                "発行部署:" + department + "\n" +
                "開催日:" + day.description + "\n" +
                "場所" + location + "\n" +
        "定員" + capacity + "\n" +
        "締切日" + deadline.description
        
        let alert = UIAlertController(title: "この内容で申し込みます",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: {(UIAlertAction)-> Void in
                                        let event = Event(name:name, descriptionText:description, day:day.description, location: location, departmentName: department, capacity: capacity, officer: officer, deadline: deadline.description)
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
