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
    let type: String
    let departmentName: String
    let descriptionText: String
    let officer: Bool

    override init(){
        title = ""
        date = ""
        type = ""
        departmentName = ""
        descriptionText = ""
        officer = false
    }
    
    init(information: NCMBObject) {
        title = information.object(forKey: "title") as! String
        date = information.object(forKey: "date") as! String
        type = information.object(forKey: "type") as! String
        departmentName = information.object(forKey: "department_name") as! String
        descriptionText = information.object(forKey: "info") as! String
        officer = information.object(forKey: "officer_only") as! Bool
    }
    
    init(title: String, descriptionText: String, date: String, type: String, departmentName:String, officer:Bool) {
        self.title = title
        self.date = date
        self.type = type
        self.departmentName = departmentName
        self.descriptionText = descriptionText
        self.officer = officer
    }
    
    func save(){
        let informationObject = NCMBObject(className: "Information")
        informationObject?.setObject(title, forKey: "title")
        informationObject?.setObject(date, forKey: "date")
        informationObject?.setObject(type, forKey: "type")
        informationObject?.setObject(departmentName, forKey: "department_name")
        informationObject?.setObject(descriptionText, forKey: "info")
        informationObject?.setObject(officer, forKey: "officer_only")
        
        informationObject?.saveInBackground({(error) in
            if error != nil{
                print("Save error: ", error!)
            }
        })
        
    }
}
