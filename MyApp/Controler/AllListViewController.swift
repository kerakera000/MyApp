//
//  AllListViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.

import UIKit
import RealmSwift

class AllListViewController: UIViewController, CatchProtocol{
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var NewListButton: UIButton!
    @IBOutlet weak var TitleLabel: UILabel!
    
    let realm = try! Realm()
    var list: List<Memos>!
    var memomodel = [MemoModel]()
    let memos = Memos()
    
    var checklist = "今日"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        NewListButton.layer.cornerRadius = 28.0
        
        list = realm.objects(Itemlist.self).first?.list
        TitleLabel.text = checklist
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        TitleLabel.text = checklist
        
        self.tableview.reloadData()
        loaddata()
        print("viewwill回しますー")
        print("checklist確認しますー", checklist)
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        if checklist == "今日"{
            loaddata()
        }
        if checklist == "全部" {
            Allloaddata()
        }
        if checklist == "達成"{
            CheckLoadData()
        }
    }
    
    func loaddata(){
        var date = GetdayModel.getTodayDate(slash: true)
        TitleLabel.text = checklist
        //2021/08/01
        for _ in 0...1{
            if let slash = date.range(of: "/"){
                date.replaceSubrange(slash, with: "")
            }
        }
        //最初の六文字
        let colectionID = date

        let filter = realm.objects(Memos.self).filter("YearMount == %@", colectionID)
        // 取得件数の表示
        memomodel = []
        for memos in filter {
            let memo = MemoModel(postDateID: memos.PostDateID!, Comments: memos.Comments!, capital: memos.CheckBool, YearMount: memos.YearMount!)
            self.memomodel.append(memo)
        }
        tableview.reloadData()
    }
    
    func Allloaddata(){
        memomodel = []
        TitleLabel.text = checklist
        
        for memos in list {
            let memo = MemoModel(postDateID: memos.PostDateID!, Comments: memos.Comments!, capital: memos.CheckBool, YearMount: memos.YearMount!)
            self.memomodel.append(memo)
        }
        
        self.tableview.reloadData()
    }
    
    func CheckLoadData(){
        memomodel = []
        TitleLabel.text = checklist
        
        for memos in list {
            if memos.CheckBool == true{
                let memo = MemoModel(postDateID: memos.PostDateID!, Comments: memos.Comments!, capital: memos.CheckBool, YearMount: memos.YearMount!)
                self.memomodel.append(memo)
            }
        }
        self.tableview.reloadData()
    }
    
    func catchData(moji: String) {
        checklist = ""
        checklist = moji
        print("キャッチしたぞ",checklist)
        
        if checklist == "今日"{
            loaddata()
        }
        if checklist == "全部" {
            Allloaddata()
        }
        if checklist == "達成"{
            CheckLoadData()
        }
    }
    @IBAction func gocheckList(_ sender: Any) {
        self.performSegue(withIdentifier: "next", sender: nil)
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
        }else if segue.identifier == "next" {
            let nextvc = segue.destination as! ListViewController
            nextvc.delegate = self
        }
    }
    @IBAction func checkbutton(_ sender: UIButton) {
        // UITableView内の座標に変換
        let point = self.tableview.convert(sender.center, from: sender)
        // 座標からindexPathを取得
        if let indexPath = self.tableview.indexPathForRow(at: point) {
            
            let datasets = memomodel[indexPath.row]
            let ID = memomodel[indexPath.row].postDateID
            
            let filter = realm.objects(Memos.self).filter("PostDateID == %@", ID).first
            
            print("うんこ",filter as Any)
            //firestore内のBool値の情報を更新
            if datasets.capital == false {
                
                do{
                  try realm.write{
                      filter?.CheckBool = true
                  }
                }catch {
                  print("Error \(error)")
                }
            } else if datasets.capital == true{
                
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
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memomodel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        tableview.rowHeight = 65
        
        let button = cell.checkButton
        let datasets = memomodel[indexPath.row]

        button!.isCheck = datasets.capital
        
        cell.MemoLabel.numberOfLines = 0
        cell.MemoLabel?.text = datasets.Comments
        return cell
    }

    //cell選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルの選択解除
        tableview.deselectRow(at: indexPath, animated: true)
    }
    //=================================================================
    //スワイプしたセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let ID = memomodel[indexPath.row].postDateID
        
        if editingStyle == .delete {
            
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
//    //tableviewのcellの並び替え
//    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        try! realm.write {
//            let listItem = list[fromIndexPath.row]
//            list.remove(at: fromIndexPath.row)
//            list.insert(listItem, at: to.row)
//        }
//    }
}
