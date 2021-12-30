//
//  ListViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit
import RealmSwift

protocol CatchProtocol {
    func catchData(moji: String)
}

class ListViewController: UIViewController {
    
    @IBOutlet weak var NowDayCount: UILabel!
    @IBOutlet weak var AlllistCount: UILabel!
    @IBOutlet weak var CheckListCount: UILabel!
    
    let realm = try! Realm()
    var moji:String = ""
    var delegate:CatchProtocol?
    var list: List<Memos>!
    
    var nowDayModel = [MemoModel]()
    var alllistModel = [MemoModel]()
    var checkListModel = [MemoModel]()
    
    var nowDayCount = Int()
    var alllistCount = Int()
    var checkListCount = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        list = realm.objects(Itemlist.self).first?.list
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewwillきてるきてる！")
        loaddata()
        Allloaddata()
        CheckLoadData()
    }
    
    @IBAction func nowDayList(_ sender: Any) {
        moji = ""
        moji = "今日"
        delegate?.catchData(moji: moji)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func Alllist(_ sender: Any) {
        moji = ""
        moji = "全部"
        delegate?.catchData(moji: moji)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func ClearList(_ sender: Any) {
        moji = ""
        moji = "達成"
        delegate?.catchData(moji: moji)
        self.dismiss(animated: true, completion: nil)
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

        let filter = realm.objects(Memos.self).filter("YearMount == %@", colectionID)
        // 取得件数の表示
        nowDayModel = []
        for memos in filter {
            let memo = MemoModel(postDateID: memos.PostDateID!, Comments: memos.Comments!, capital: memos.CheckBool, YearMount: memos.YearMount!)
            self.nowDayModel.append(memo)
        }
        
        nowDayCount = nowDayModel.count
        NowDayCount.text = String(nowDayCount)
    }

    func Allloaddata(){
        alllistModel = []

        for memos in list {
            let memo = MemoModel(postDateID: memos.PostDateID!, Comments: memos.Comments!, capital: memos.CheckBool, YearMount: memos.YearMount!)
            self.alllistModel.append(memo)
        }
        alllistCount = alllistModel.count
        AlllistCount.text = String(alllistCount)
    }

    func CheckLoadData(){
        checkListModel = []

        for memos in list {
            if memos.CheckBool == true{
                let memo = MemoModel(postDateID: memos.PostDateID!, Comments: memos.Comments!, capital: memos.CheckBool, YearMount: memos.YearMount!)
                self.checkListModel.append(memo)
            }
        }
        checkListCount = checkListModel.count
        CheckListCount.text = String(checkListCount)
    }
}
