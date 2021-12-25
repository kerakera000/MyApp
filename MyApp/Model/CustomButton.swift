//
//  CustomButton.swift
//  MyApp
//
//  Created by kerakera on 2021/12/20.
//

import UIKit

class CustomButton: UIButton {

    let checkImage = UIImage(named:"mark")! as UIImage
    let uncheckImage = UIImage(named:"unmark")! as UIImage
    
    var isCheck: Bool = false {
        didSet{
            if isCheck == true {
                self.setImage(checkImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckImage, for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
    }
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isCheck = !isCheck
        }
    }
}
