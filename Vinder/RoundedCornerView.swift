//
//  RoundedCornerView.swift
//  Vinder
//
//  Created by Dayson Dong on 2019-07-01.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class RoundedCornerView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 25
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }

}
