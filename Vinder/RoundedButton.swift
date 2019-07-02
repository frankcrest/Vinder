//
//  RoundedButton.swift
//  
//
//  Created by Dayson Dong on 2019-06-28.
//

import UIKit

class RoundedButton: UIButton {
    
  override init(frame: CGRect) {
    super.init(frame: frame)

    self.layer.cornerRadius = bounds.size.height / 2.0
    self.clipsToBounds = true
    self.translatesAutoresizingMaskIntoConstraints = false
    self.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.fill
    self.contentVerticalAlignment =  UIControl.ContentVerticalAlignment.fill
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

}
