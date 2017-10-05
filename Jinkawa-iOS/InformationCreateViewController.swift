//
//  InformationCreateViewController.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/16.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import UIKit
import Eureka

class InformationCreateViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        form
            +++ Section("お知らせの内容")
            <<< TextRow("TitleRowTag") {
                $0.title = "タイトル"
            }
            <<< TextRow("DepartmentNameRowTag") {
                $0.title = "部署"
            }
            <<< TextRow("DescriptionRowTag") {
                $0.title = "説明文"
            }
            <<< DateInlineRow("DateRowTag") {
                $0.title = "日付"
            }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(didTapSaveButton(sender:)))
        
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
        
        let title:String = values["TitleRowTag"] as! String
        let department:String = values["DepartmentNameRowTag"] as! String
        let description:String = values["DescriptionRowTag"] as! String
        let date:Date = values["DateRowTag"] as! Date
        
        let message: String =
            "タイトル:" + title + "\n" +
                "発行部署:" + department + "\n" +
                "開催日:" + date.description + "\n"
        
        let alert = UIAlertController(title: "この内容で申し込みます",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: {(UIAlertAction)-> Void in
                                        let information = Information(title: title, descriptionText: description, date:date.description, departmentName: department)
                                        information.save()
                                        
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
