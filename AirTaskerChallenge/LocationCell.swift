//
//  LocationCell.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 3/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import Foundation
import UIKit

class LocationCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    nameLabel.layer.masksToBounds = true
    nameLabel.layer.cornerRadius = 10
  }
  
  static func nib() -> UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }

  static func reuseId() -> String {
    return String(describing: self)
  }
  
  func setup(_ location: Location) {
    
    nameLabel.text = location.displayName
  }

}
