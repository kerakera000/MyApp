//
//  SearchViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    let realm = try! Realm()
    var list: List<Memos>!
    var memomodel = [MemoModel]()
    var filterArray = [MemoModel]()
    let memos = Memos()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        list = realm.objects(Itemlist.self).first?.list
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        Allloaddata()
        print("サーチview回す")
        print(memomodel)
    }
    func Allloaddata(){
        
        memomodel = []
        
        for memos in list {
            let memo = MemoModel(postDateID: memos.PostDateID!, Comments: memos.Comments!, capital: memos.CheckBool, YearMount: memos.YearMount!)
            self.memomodel.append(memo)
        }
    }
    

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func search(_ sender: Any) {
         serchlist()
    }
    @IBAction func checkBoolButton(_ sender: UIButton) {
        // UITableView内の座標に変換
        let point = self.tableview.convert(sender.center, from: sender)
        // 座標からindexPathを取得
        if let indexPath = self.tableview.indexPathForRow(at: point) {
            
            let datasets = filterArray[indexPath.row]
            let ID = filterArray[indexPath.row].postDateID
            
            let filter = realm.objects(Memos.self).filter("PostDateID == %@", ID).first
            
            print("うんこ",filter as Any)
            //firestore内のBool値の情報を更新
            if datasets.capital == false {
                
                do{
                  try realm.write{
                      filter?.CheckBool = true
                      print(filter as Any)
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
        Allloaddata()
        serchlist()
    }
    func serchlist() {
        filterArray = []
        
        if textField.text == "" {
            print("戻る")
            return
        }else {
            print("serch回す")
            let filterString = textField.text!
            
            let search = memomodel.filter{ (comment) in
                return comment.Comments.uppercased().hasPrefix(filterString.uppercased())
            }
            print("検索結果")
            print(search)
            for memos in search {
                let memo = MemoModel(postDateID: memos.postDateID, Comments: memos.Comments, capital: memos.capital, YearMount: memos.YearMount)
                print("検索結果2")
                print(memo)
                print(filterArray)
                self.filterArray.append(memo)
            }
        }
        tableview.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        tableview.rowHeight = 65
        
        let button = cell.checkButton
        let datasets = filterArray[indexPath.row]
        let Daylabel = cell.DayMemoLabel

        button!.isCheck = datasets.capital
        Daylabel?.text = datasets.YearMount
        
        cell.MemoLabel.numberOfLines = 0
        cell.MemoLabel?.text = datasets.Comments
        return cell
    }
    //cell選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルの選択解除
        tableview.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let ID = filterArray[indexPath.row].postDateID
        
        if editingStyle == .delete {
            
            //realm消去
            try! realm.write {
                let item = realm.objects(Memos.self).filter("PostDateID == %@", ID)
                realm.delete(item)
            }
            filterArray.remove(at: indexPath.row)
            tableview.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
        //tableviewの中身をリロード
        tableview.reloadData()
    }
    
    
}
