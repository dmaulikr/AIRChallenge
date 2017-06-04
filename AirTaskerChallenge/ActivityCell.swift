//
//  ActivityCell.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 3/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ActivityCell: UITableViewCell {
  
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subTitleLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    avatarImageView.layer.masksToBounds = true
    avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
  }
  
  static func nib() -> UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
  
  static func reuseId() -> String {
    return String(describing: self)
  }

  func setup(_ activity: Activity) {
    
    if let avatarImage = activity.runner?.avatarMiniUrl {
      avatarImageView.sd_setImage(with: Utilities.imageFullURLWithImage(avatarImage), placeholderImage: UIImage(named: "placeholder"))
    } else {
      avatarImageView.image = UIImage(named: "placeholder")
    }

    var desc = activity.message
    if let profileName = activity.runner?.firstName, let taskName = activity.task?.name {
      desc = desc.replacingOccurrences(of: "{profileName}", with: profileName)
      desc = desc.replacingOccurrences(of: "{taskName}", with: taskName)
    }
    
    descriptionLabel.text = desc
    typeLabel.text = activity.event
  }

}
