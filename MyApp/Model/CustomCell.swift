//
//  CustomCell.swift
//  MyApp
//
//  Created by kerakera on 2021/12/20.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell {
 
    
    @IBOutlet weak var MemoLabel: UILabel!
    @IBOutlet weak var checkButton: CustomButton!
    @IBOutlet weak var DayMemoLabel: UILabel!
    
    //継承クラスのメソッド(機能)を上書き
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
}
