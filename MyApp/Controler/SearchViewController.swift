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
        filterArray = []
        
        if textField.text == "" {
            return
        }else {
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
    
    
    
    
}
