//
//   DateFormat.swift
//  Jinkawa-iOS
//
//  Created by Kenta Aikawa on 2017/11/05.
//  Copyright © 2017年 Taro Sato. All rights reserved.
//
import UIKit

extension DateFormatter {
    // テンプレートの定義(例)
    enum Template: String {
        case date = "yMd"     // 2017/1/1
        case time = "Hm"     // 12:39
        case full = "yMdkHm" // 2017/1/1 12:39
        case day = "d"
        case mon = "M"
        case yer = "y"
        case onlyHour = "k"   // 17時
        case era = "GG"       // "西暦" (default) or "平成" (本体設定で和暦を指定している場合)
        case weekDay = "EEEE" // 日曜日
    }
    // 冗長な関数のためラップ
    func setTemplate(_ template: Template) {
        // optionsは拡張のためにあるが使用されていない引数
        // localeは省略できないがほとんどの場合currentを指定する
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: .current)
    }
}



