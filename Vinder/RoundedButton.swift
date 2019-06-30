//
//  RoundedButton.swift
//  
//
//  Created by Dayson Dong on 2019-06-28.
//

import UIKit

class RoundedButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height / 2.0
        clipsToBounds = true
        imageView?.bounds.size.height = bounds.size.height * 0.75
        imageView?.bounds.size.width = bounds.size.width * 0.75
        
    }

}
