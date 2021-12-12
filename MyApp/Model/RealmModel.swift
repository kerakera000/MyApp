//
//  RealmModel.swift
//  MyApp
//
//  Created by kerakera on 2021/12/12.
//

import UIKit
import RealmSwift

class Memos: Object{
    //これを元に並び順を変えて、識別する
    @objc dynamic var PostDateID: String?
    @objc dynamic var Comments: String?
    @objc dynamic var CheckBool = Bool()
    //これを元にリスト作成
    @objc dynamic var YearMount: String?
    
}
class Itemlist: Object {
    let list = List<Memos>()
}
