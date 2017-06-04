//
//  Runner.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 3/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Runner: NearbyDisplayDataProtocol {
  var id: Int
  var locationId: Int
  var firstName: String
  var rating: Int
  var description: String
  var avatarMiniUrl: String
  
  // MARK: comform to NearbyDisplayDataProtocol
  var imageUrl: String?
  var title: String?
  var subTitle: String?
  var body: String?
}

// MARK: - init with json

extension Runner {
  
  init?(json: JSON) {
    guard let id = json["id"].int,
      let locationId = json["location_id"].int,
      let firstName = json["first_name"].string,
      let rating = json["rating"].int,
      let description = json["description"].string,
      let avatarMiniUrl = json["avatar_mini_url"].string
      else {
        return nil
    }
    
    self.id = id
    self.locationId = locationId
    self.firstName = firstName
    self.rating = rating
    self.description = description
    self.avatarMiniUrl = avatarMiniUrl
    
    self.imageUrl = self.avatarMiniUrl
    self.title = self.firstName
    self.subTitle = "Rating: "+String(self.rating)
    self.body = self.description
  }
}




