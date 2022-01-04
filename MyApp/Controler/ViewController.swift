//
//  ViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()
    var list: List<Memos>!
    var memomodel = [MemoModel]()
    let memos = Memos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list = realm.objects(Itemlist.self).first?.list
        print("temporaのメールチェックviewdidload")
        if list == nil {
            let item = Memos()
            
            let memodate = Date().timeIntervalSince1970
            let postDateID = String( memodate )
            
            var date = GetdayModel.getTodayDate(slash: true)
            //2021/08/01
            for _ in 0...1{
                if let slash = date.range(of: "/"){
                    date.replaceSubrange(slash, with: "")
                }
            }
            //最初の六文字
            let colectionID = date
            
                item.Comments = "今日の予定を立てよう！"
                item.PostDateID = postDateID
                item.CheckBool = false
                item.YearMount = colectionID
                    try! self.realm.write() {
                        if self.list == nil {
                            let itemList = Itemlist()
                            itemList.list.append(item)
                            self.realm.add(itemList)
                            self.list = self.realm.objects(Itemlist.self).first?.list
                        } else {
                            self.list.append(item)
                        }
                    }
        }
    }
    @IBAction func Gonext(_ sender: Any) {
        self.performSegue(withIdentifier: "next", sender: nil)
    }
    
}

