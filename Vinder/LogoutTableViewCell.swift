//
//  LogoutTableViewCell.swift
//  Vinder
//
//  Created by Frances ZiyiFan on 7/3/19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class LogoutTableViewCell: UITableViewCell {
    
    let logoutButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isUserInteractionEnabled = true
        b.setTitle("Logout", for: .normal)
        b.tintColor = UIColor(red: 36/255, green: 171/255, blue: 255/255, alpha: 1)
        b.setTitleColor(UIColor(red: 36/255, green: 171/255, blue: 255/255, alpha: 1), for: .normal)
        return b
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
                logoutButton.topAnchor.constraint(equalTo: self.topAnchor),
                logoutButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                logoutButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                logoutButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
