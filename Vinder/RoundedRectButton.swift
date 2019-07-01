//
//  RoundedRectButton.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-07-01.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation
import UIKit

class RoundedRectButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.size.height / 2.0
        clipsToBounds = true
//        imageView?.bounds.size.height = bounds.size.height * 0.75
//        imageView?.bounds.size.width = bounds.size.width * 0.75
        translatesAutoresizingMaskIntoConstraints = false
    }
}
