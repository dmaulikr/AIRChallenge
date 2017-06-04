//
//  RunnerCell.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 3/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class NearbyCell: UITableViewCell {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subTitleLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func layoutSubviews() {
    self.contentView.setNeedsLayout()
    self.contentView.layoutIfNeeded()

    avatarImageView.layer.masksToBounds = true
    avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
    
    super.layoutSubviews()
  }
  
  static func nib() -> UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }

  static func reuseId() -> String {
    return String(describing: self)
  }
  
  func setup(_ nearby: NearbyDisplayDataProtocol) {
    
    avatarImageView.sd_setImage(with: Utilities.imageFullURLWithImage(nearby.imageUrl), placeholderImage: UIImage(named: "placeholder"))
    titleLabel.text = nearby.title
    subTitleLabel.text = nearby.subTitle
    bodyLabel.text = nearby.body
  }

}
