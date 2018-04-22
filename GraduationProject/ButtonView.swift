//
//  LogInButtonView.swift
//  NoteWork
//
//  Created by OMER BUKTE on 5/4/17.
//  Copyright © 2017 Omer Bukte. All rights reserved.
//

import UIKit

let SHADOW_GREY: CGFloat = 120.0 / 255.0

class ButtonView: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor.init(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        layer.cornerRadius = 2.0
    }

}
