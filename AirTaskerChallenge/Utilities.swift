//
//  Utilities.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 3/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import Foundation
import SwiftyJSON

class Utilities {
  
  class func imageFullURLWithImage(_ imageName: String?) -> URL? {
    let baseURLString: String = "https://s3-ap-southeast-2.amazonaws.com/ios-code-test/ios-code-test"
    
    if let imageName = imageName {
      return URL(string: baseURLString + imageName)
    }
    return nil
  }
  
  class func loadLocationsFromJSON(json: JSON) -> [Location] {
      var dataArray: [Location] = []
      
      guard let locationsArray = json.array else {
          print("No array")
          return []
      }
      
      for j in locationsArray {
        if let location = Location(json: j) {
          dataArray.append(location)
        }
      }
      
      return dataArray
  }
  
  class func loadActivityFromJSON(json: JSON) -> [Activity] {
    var dataArray: [Activity] = []
    
    guard let array = json["recent_activity"].array else {
      print("No array")
      return []
    }
    
    for j in array {
      if let activity = Activity(json: j) {
        dataArray.append(activity)
      }
    }
    
    return dataArray
  }
  
}
