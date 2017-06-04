//
//  NetworkManager.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 3/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager: NSObject {
  let baseURLString: String = "https://s3-ap-southeast-2.amazonaws.com/ios-code-test/ios-code-test/"
  
  func getDataWithFile(_ file: String, completionHandler:@escaping (_ data: Any?, _ error: NSError?) -> Void) {
    let requestURL: String = "\(baseURLString)\(file)"
    Alamofire.request(requestURL).responseJSON { (response) in
      switch response.result {
      case .success:
        guard let json = response.result.value else {
          return
        }
        completionHandler(json, nil)
      case .failure(let error):
        completionHandler(nil, error as NSError)
      }
    }
  }

}
