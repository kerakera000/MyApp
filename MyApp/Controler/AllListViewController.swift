//
//  AllListViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.

import UIKit
import RealmSwift

class AllListViewController: UIViewController{
    
    @IBOutlet weak var tableview: UITableView!
    
    let realm = try! Realm()
    let db = Firestore.firestore()
    var list: List<Memos>!
    var memomodel = [MemoModel]()
    let uid = Auth.auth().currentUser?.uid
    let memos = Memos()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableview.reloadData()
        loaddata()
        print("あああああ")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func loaddata(){
        var date = GetdayModel.getTodayDate(slash: true)
        //2021/08/01
        for _ in 0...1{
            if let slash = date.range(of: "/"){
                date.replaceSubrange(slash, with: "")
            }
        }
        //最初の六文字
        let colectionID = date

        let testfilter = realm.objects(Memos.self).filter("YearMount == %@", colectionID)
        // 取得件数の表示
        memomodel = []
        for memos in testfilter {
            let memo = MemoModel(postDateID: memos.PostDateID!, Comments: memos.Comments!, capital: memos.CheckBool, YearMount: memos.YearMount!)
                print(memos)
            self.memomodel.append(memo)
        }
        tableview.reloadData()
    }
    
    
    @IBAction func NewList(_ sender: Any) {
        self.performSegue(withIdentifier: "ToNewmemo", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var date = GetdayModel.getTodayDate(slash: true)
        //2021/08/01
        for _ in 0...1{
            if let slash = date.range(of: "/"){
                date.replaceSubrange(slash, with: "")
            }
        }
        //最初の六文字
        let colectionID = date
        
        if segue.identifier == "ToNewmemo" {
            let CreateMemoViewController = segue.destination as! NewListViewController
            CreateMemoViewController.day = colectionID
        }
    }
    @IBAction func checkbutton(_ sender: UIButton) {
        // UITableView内の座標に変換
        let point = self.tableview.convert(sender.center, from: sender)
        let uid = (Auth.auth().currentUser?.uid)!
        // 座標からindexPathを取得
        if let indexPath = self.tableview.indexPathForRow(at: point) {
            
            let datasets = memomodel[indexPath.row]
            let ID = memomodel[indexPath.row].postDateID
            
            let filter = realm.objects(Memos.self).filter("PostDateID == %@", ID).first
            
            print("うんこ",filter as Any)
            //firestore内のBool値の情報を更新
            if datasets.capital == false {
                db.collection("newuser").document(uid).collection("memo").document(ID).updateData(["capital": true]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("trueに更新")
                        }
                    }
                do{
                  try realm.write{
                      filter?.CheckBool = true
                  }
                }catch {
                  print("Error \(error)")
                }
            } else if datasets.capital == true{
                db.collection("newuser").document(uid).collection("memo").document(ID).updateData(["capital": false]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("falseに更新")
                        }
                    }
                do{
                  try realm.write{
                      filter?.CheckBool = false
                  }
                }catch {
                  print("Error \(error)")
                }
                }
        } else {
            //ここには来ないはず
            print("indexPath not found.")
        }
        loaddata()
    }
    
}

extension AllListViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memomodel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableview.rowHeight = 70
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        let button = cell.checkButton
        let datasets = memomodel[indexPath.row]

        button!.isCheck = datasets.capital
        
        cell.MemoLabel.numberOfLines = 0
        cell.MemoLabel?.text = datasets.Comments
        return cell
    }
    
    //=================================================================
    //cell選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルの選択解除
        tableview.deselectRow(at: indexPath, animated: true)
    }
    //=================================================================
    //スワイプしたセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ID = memomodel[indexPath.row].postDateID
        
        if editingStyle == .delete {
            //firebase消去
            db.collection("newuser").document(uid).collection("memo").document(ID).delete(){ err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            //realm消去
            try! realm.write {
                let item = realm.objects(Memos.self).filter("PostDateID == %@", ID)
                realm.delete(item)
            }
            memomodel.remove(at: indexPath.row)
            tableview.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
        //tableviewの中身をリロード
        tableview.reloadData()
    }
    //tableviewのcellの並び替え
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        try! realm.write {
            let listItem = list[fromIndexPath.row]
            list.remove(at: fromIndexPath.row)
            list.insert(listItem, at: to.row)
        }
    }
}
