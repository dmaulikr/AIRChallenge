//
//  LocationModel.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 3/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Location {
  var id: Int
  var displayName: String
  var lat: String
  var lng: String
}

extension Location {
  
  init?(json: JSON) {
    guard let id = json["id"].int,
      let displayName = json["display_name"].string,
      let lat = json["latitude"].string,
      let lng = json["longitude"].string
      else {
        return nil
    }
    
    self.id = id
    self.displayName = displayName
    self.lat = lat
    self.lng = lng
  }
}
