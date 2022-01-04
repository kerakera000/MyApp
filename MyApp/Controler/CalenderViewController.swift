//
//  CalenderViewController.swift
//  MyApp
//
//  Created by kerakera on 2021/12/11.
//

import UIKit
import RealmSwift
import FSCalendar
import CalculateCalendarLogic

class CalenderViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    var realm = try! Realm()
    var list: List<Memos>!
    var memomodel = [MemoModel]()
    var eventCheck = [MemoModel]()
    //値渡し用
    var day = ""
    //選択日表示用
    var dataday = ""

    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var Tableview: UITableView!
    @IBOutlet weak var NewListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Tableview.dataSource = self
        Tableview.delegate = self
        
        calenderView.delegate = self
        calenderView.dataSource = self
        
        NewListButton.layer.cornerRadius = 28.0
        
        list = realm.objects(Itemlist.self).first?.list
        
        FSweekday()
    }
    
    func FSweekday(){
        calenderView.calendarWeekdayView.weekdayLabels[0].text = "日"
        calenderView.calendarWeekdayView.weekdayLabels[1].text = "月"
        calenderView.calendarWeekdayView.weekdayLabels[2].text = "火"
        calenderView.calendarWeekdayView.weekdayLabels[3].text = "水"
        calenderView.calendarWeekdayView.weekdayLabels[4].text = "木"
        calenderView.calendarWeekdayView.weekdayLabels[5].text = "金"
        calenderView.calendarWeekdayView.weekdayLabels[6].text = "土"
        
        
        
        calenderView.calendarWeekdayView.weekdayLabels[0].textColor = UIColor.red
        calenderView.calendarWeekdayView.weekdayLabels[1].textColor = UIColor.black
        calenderView.calendarWeekdayView.weekdayLabels[2].textColor = UIColor.black
        calenderView.calendarWeekdayView.weekdayLabels[3].textColor = UIColor.black
        calenderView.calendarWeekdayView.weekdayLabels[4].textColor = UIColor.black
        calenderView.calendarWeekdayView.weekdayLabels[5].textColor = UIColor.black
        calenderView.calendarWeekdayView.weekdayLabels[6].textColor = UIColor.blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(dataday)
        if dataday == ""{
            loadData()
            calenderView.reloadData()
        }else{
            clickday()
            calenderView.reloadData()
        }
    }
    
    func clickday() {
        print("clickdayだぜ")
        memomodel = []
        for memos in list {
            if memos.YearMount == dataday{
                let memo = MemoModel(postDateID: memos.PostDateID!, Comments: memos.Comments!, capital: memos.CheckBool, YearMount: memos.YearMount!)
                self.memomodel.append(memo)
            }
        }
        print(memomodel)
        self.Tableview.reloadData()
    }
    func loadData() {
        print("loaddataだぜ")
        var date = GetdayModel.getTodayDate(slash: true)
        //2021/08/01
        //年月と日に分ける
        for _ in 0...1{
            if let slash = date.range(of: "/"){
                date.replaceSubrange(slash, with: "")
                //2021/11/16 -> 20211116になる
            }
        }
        //最初の六文字
        let colectionID = date
        dataday = colectionID

        //tableview.isEditing.toggle()
        let testfilter = realm.objects(Memos.self).filter("YearMount == %@", colectionID)
        // 取得件数の表示
        print(testfilter)
        memomodel = []
        for memos in testfilter {
            let memo = MemoModel(postDateID: memos.PostDateID!, Comments: memos.Comments!, capital: memos.CheckBool, YearMount: memos.YearMount!)
            self.memomodel.append(memo)
        }
        Tableview.reloadData()
    }

    @IBAction func NewList(_ sender: Any) {
        self.performSegue(withIdentifier: "ToNewMemo", sender: nil)
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
        
        if day == ""{
            if segue.identifier == "ToNewMemo" {
                let CreateMemoViewController = segue.destination as! NewListViewController
                CreateMemoViewController.day = colectionID
            }
        }else{
            if segue.identifier == "ToNewMemo" {
                let CreateMemoViewController = segue.destination as! NewListViewController
                CreateMemoViewController.day = day
            }
        }
    }
    @IBAction func checkButton(_ sender: UIButton) {
        // UITableView内の座標に変換
        let point = self.Tableview.convert(sender.center, from: sender)
         
        // 座標からindexPathを取得
        if let indexPath = self.Tableview.indexPathForRow(at: point) {
            
//            var Datasets = memomodel[indexPath.row]
            
            let datasets = memomodel[indexPath.row]
            let ID = memomodel[indexPath.row].postDateID
            
            
//            Datasets.capital = !Datasets.capital
            let filter = realm.objects(Memos.self).filter("PostDateID == %@", ID).first
            
            print(filter!)
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
        clickday()
    }
    
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
        func judgeHoliday(_ date : Date) -> Bool {
            //祝日判定用のカレンダークラスのインスタンス
            let tmpCalendar = Calendar(identifier: .gregorian)
            // 祝日判定を行う日にちの年、月、日を取得
            let year = tmpCalendar.component(.year, from: date)
            let month = tmpCalendar.component(.month, from: date)
            let day = tmpCalendar.component(.day, from: date)
            
            // CalculateCalendarLogic()：祝日判定のインスタンスの生成
            let holiday = CalculateCalendarLogic()
            
            return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
        }
    // date型 -> 年月日をIntで取得
        func getDay(_ date:Date) -> (Int,Int,Int){
            let tmpCalendar = Calendar(identifier: .gregorian)
            let year = tmpCalendar.component(.year, from: date)
            let month = tmpCalendar.component(.month, from: date)
            let day = tmpCalendar.component(.day, from: date)
            return (year,month,day)
        }
    //曜日判定(日曜日:1 〜 土曜日:7)
        func getWeekIdx(_ date: Date) -> Int{
            let tmpCalendar = Calendar(identifier: .gregorian)
            return tmpCalendar.component(.weekday, from: date)
        }
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        if Calendar.current.compare(date, to: calendar.currentPage, toGranularity: .month) != .orderedSame {
                    return nil
                }
            //祝日判定をする（祝日は赤色で表示する）
            if self.judgeHoliday(date){
                return UIColor.red
            }
            //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
            let weekday = self.getWeekIdx(date)
            if weekday == 1 {   //日曜日
                return UIColor.red
            }
            else if weekday == 7 {  //土曜日
                return UIColor.blue
            }
            return nil
        }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //抽出データを指定してPrintで出す
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        var now = df.string(from: date)
        //forで/を消して年月、日で分ける
        for _ in 0...1{
            //varで取得したdateの中身のスラッシュの部分をfor文で消す...2個あるから2回まわる(2021/08/01)となる
            if let slash = now.range(of: "/"){
                now.replaceSubrange(slash, with: "")
            }
        }
        //全部
        let CreateDay = now
        //選択時拾った日付をそのままdayに入れる
        day = CreateDay
        dataday = ""
        dataday = CreateDay

        memomodel = []
        for memos in list {
            if memos.YearMount == CreateDay{
                let memo = MemoModel(postDateID: memos.PostDateID!, Comments: memos.Comments!, capital: memos.CheckBool, YearMount: memos.YearMount!)
                self.memomodel.append(memo)
            }
        }
        print(memomodel)
        self.Tableview.reloadData()
    }
    
    // 任意の日付に点マークをつける
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        var hasEvent = false
        var now = dateFormatter.string(from: date)
        //forで/を消して年月、日で分ける
        for _ in 0...1{
            //varで取得したdateの中身のスラッシュの部分をfor文で消す...2個あるから2回まわる(2021/08/01)となる
            if let slash = now.range(of: "/"){
                now.replaceSubrange(slash, with: "")
            }
        }
        //全部
        let CreateDay = now

        for dateStr in list{
            if dateStr.YearMount == CreateDay {
                print("点をつけるぜ！")
                hasEvent = true
            }
        }
        if hasEvent {
            return 1
        } else {
            return 0
        }
    }
}

extension CalenderViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memomodel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        Tableview.rowHeight = 65
        let cell = Tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        let button = cell.checkButton
        let datasets = memomodel[indexPath.row]

        button!.isCheck = datasets.capital
        
        cell.MemoLabel.numberOfLines = 0
        cell.MemoLabel?.text = datasets.Comments
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルの選択解除
        Tableview.deselectRow(at: indexPath, animated: true)
    }
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
            Tableview.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
        //tableviewの中身をリロード
        Tableview.reloadData()
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
