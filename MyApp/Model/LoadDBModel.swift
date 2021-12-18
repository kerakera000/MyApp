//
//  LoadDBModel.swift
//  MyApp
//
//  Created by kerakera on 2021/12/18.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore
import RealmSwift


class LoadDBModel {
    var realm = try! Realm()
    var list: List<Memos>!
    let db = Firestore.firestore()
    
    func realmset(){
        print("realmリセット")
        try! realm.write {
            realm.deleteAll()
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("newuser").document(uid).collection("memo").order(by: "postDateID").addSnapshotListener{(snapShot, error) in
            print("なぜ出ない",snapShot as Any)
            if error != nil{
                print("エラー")
                return
            }
            if let snapShotDoc = snapShot?.documents{
                print("配列〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜〜＾",snapShotDoc)
                for doc in snapShotDoc {
                    //配列化されたdocのdata内容だけを抽出してdataに入れる
                    let data = doc.data()
                    print("なぜ出ない",data)
                    if let comments = data["comments"] as? String,
                         let Capital = data["capital"] as? Bool,
                             let yearmount = data["YearMount"] as? String,
                                 let postDateId = data["postDateID"] as? String{
                                    
                                    let item = Memos()
                                        item.Comments = comments
                                        item.PostDateID = postDateId
                                        item.CheckBool = Capital
                                        item.YearMount = yearmount
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
            }
        }
    }
}
