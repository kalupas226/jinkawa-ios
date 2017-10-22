//
//  Notification.swift
//  Jinkawa-iOS
//
//  Created by Taro Sato on 2017/09/14.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//

import Foundation
import NCMB

class Information: NSObject{
    
    let title: String
    let date: String
    let departmentName: String
    let descriptionText: String

    override init(){
        title = ""
        date = ""
        departmentName = ""
        descriptionText = ""
    }
    
    init(information: NCMBObject) {
        title = information.object(forKey: "title") as! String
        date = information.object(forKey: "date") as! String
        departmentName = information.object(forKey: "department_name") as! String
        descriptionText = information.object(forKey: "info") as! String
    }
    
    init(title: String, descriptionText: String, date: String, departmentName:String) {
        self.title = title
        self.date = date
        self.departmentName = departmentName
        self.descriptionText = descriptionText
    }
    
    func save(){
        let informationObject = NCMBObject(className: "Information")
        informationObject?.setObject(title, forKey: "title")
        informationObject?.setObject(date, forKey: "date")
        informationObject?.setObject(departmentName, forKey: "department_name")
        informationObject?.setObject(descriptionText, forKey: "info")
        
        informationObject?.saveInBackground({(error) in
            if error != nil{
                print("Save error: ", error!)
            }
        })
        
    }
}
