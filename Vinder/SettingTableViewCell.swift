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
    l.font = UIFont.systemFont(ofSize: 16)
    l.textColor = .lightGray
    l.translatesAutoresizingMaskIntoConstraints = false
    return l
  }()
  
  let subtitleLabel : UILabel = {
    let l = UILabel()
    l.font = UIFont.systemFont(ofSize: 20)
    l.translatesAutoresizingMaskIntoConstraints = false
    return l
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
    
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
      
      subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
      subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
      subtitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
      subtitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
      ])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
