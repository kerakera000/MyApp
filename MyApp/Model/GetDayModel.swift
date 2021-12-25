//
//  GetDayModel.swift
//  MyApp
//
//  Created by kerakera on 2021/12/20.
//

import Foundation

class GetdayModel {
    static func getTodayDate(slash:Bool)->String{
        //現在の日付を取得して返すメソッド
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .full
        
        //2021/8/01
        if slash == true{
            formatter.dateFormat = "yyyy/MM/dd"
            
        }
        formatter.locale = Locale(identifier: "ja_JP")
        //現在時刻の取得
        let now = Date()
        //取得した時刻内容をString型にしてformatterに入れる
        return formatter.string(from: now)
    }
}
