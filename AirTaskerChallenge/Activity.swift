//
//  Runner.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 3/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Activity: NearbyDisplayDataProtocol {
  var taskId: Int
  var profileId: Int
  var message: String
  var createdAt: String?
  var event: String
  
  var task: Task?
  var runner: Runner?
  
  // MARK: comform to NearbyDisplayDataProtocol
  var imageUrl: String?
  var title: String?
  var subTitle: String?
  var body: String?
}

// MARK: - init with json

extension Activity {
  
  init?(json: JSON) {
    guard let taskId = json["task_id"].int,
      let profileId = json["profile_id"].int,
      let message = json["message"].string,
      let event = json["event"].string
      else {
        return nil
    }
    
    self.taskId = taskId
    self.profileId = profileId
    self.message = message
    self.event = event
    if let createdAt = json["created_at"].string {
      self.createdAt = createdAt
    }
  }
  
  // MARK: update activity after getting the Task and Runner detail info
  mutating func setupActivity() {
    if let avatarImage = self.runner?.avatarMiniUrl {
      self.imageUrl = avatarImage
    }
    
    var desc = self.message
    if let profileName = self.runner?.firstName, let taskName = self.task?.name {
      desc = desc.replacingOccurrences(of: "{profileName}", with: profileName)
      desc = desc.replacingOccurrences(of: "{taskName}", with: taskName)
      
      self.title = desc
    }
    
    self.subTitle = self.event
  }
}
