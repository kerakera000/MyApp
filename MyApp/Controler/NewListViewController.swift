//
//  NewListViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit
import RealmSwift

class NewListViewController: UIViewController {
    
    let realm = try! Realm()
    var list: List<Memos>!
    var day = ""

    @IBOutlet weak var textField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list = realm.objects(Itemlist.self).first?.list
        
    }
    @IBAction func backlist(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func NewMemo(_ sender: Any) {
        newmemoFirebase()
    }
    func newmemoFirebase() {
        print("func")
        if textField.text == ""{
            //画面遷移
            self.dismiss(animated: true, completion: nil)
        }else{
            
            let memodate = Date().timeIntervalSince1970
            let postDateID = String( memodate )
            
            let item = Memos()
            
                item.Comments = textField.text!
                item.PostDateID = postDateID
                item.CheckBool = false
                item.YearMount = day
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
            //画面遷移
            self.dismiss(animated: true, completion: nil)
        }
    }
}
