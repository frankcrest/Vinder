//
//  SettingTableViewCell.swift
//  Vinder
//
//  Created by Frances ZiyiFan on 6/21/19.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    
    let titleLabel : UILabel = {
       let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let subtitleLabel : UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 17)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let actionButton : UIButton = {
        let b = UIButton()
        b.setTitle("Change", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
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
        
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            
            actionButton.topAnchor.constraint(equalTo: self.topAnchor),
            actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            actionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            actionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 330)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
