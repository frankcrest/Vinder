//
//  CustomFlowLayout.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-20.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
  
  private var firstSetupDone = false
  
  override func prepare() {
    super.prepare()
    
    if !firstSetupDone{
      setup()
      firstSetupDone = true
    }
  }
  
  private func setup(){
    scrollDirection = .vertical
    minimumLineSpacing = 8
    minimumInteritemSpacing = 10
  }
}
