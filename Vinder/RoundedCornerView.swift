//
//  RoundedCornerView.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-07-01.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class RoundedCornerView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    layer.cornerRadius = 25
    clipsToBounds = true
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
