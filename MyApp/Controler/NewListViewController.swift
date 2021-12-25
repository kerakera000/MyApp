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
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        list = realm.objects(Itemlist.self).first?.list
    }
    @IBAction func NewMemo(_ sender: Any) {
        newmemoFirebase()
    }
    func newmemoFirebase() {
        print("func")
        //uid取得
//        guard let uid = Auth.auth().currentUser?.uid else {return}
        //1.作成日時を取得20211122 20:10まで取得する
        let memodate = Date().timeIntervalSince1970
        //2.作成日を文字列化
        let postDateID = String( memodate )
//        //保存箇所を作成
//        let memo = ["comments": textField.text!, "capital": false ,"postDateID": postDateID, "YearMount": day] as [String : Any]
//        //メモデータ保存用
//        let userRef = db.collection("newuser").document(uid).collection("memo").document(postDateID)
        
//        userRef.setData(memo)
        
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
