//
//  Task.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 3/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Task {
  var id: Int
  var name: String
  var description: String
  var state: String
  var posterId: Int
  var workerId: Int?
}


extension Task {
  
  init?(json: JSON) {
    guard let id = json["id"].int,
      let name = json["name"].string,
      let description = json["description"].string,
      let state = json["state"].string,
      let posterId = json["poster_id"].int
      else {
        return nil
    }
    
    self.id = id
    self.name = name
    self.description = description
    self.state = state
    self.posterId = posterId
    if let workerId = json["worker_id"].int {
      self.workerId = workerId
    }
  }
}
