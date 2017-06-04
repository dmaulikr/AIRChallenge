//
//  LocationViewModel.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 3/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RxSwift

class LocationViewModel: NSObject {

  fileprivate let networkManager = NetworkManager()
  
  var locationDataArray = Variable([Location]())

  // MARK: init
  override init() {
    super.init()
  }
  
  // MARK: fetch locations data
  func startFetchData() {
    networkManager.getDataWithFile("locations.json") { (data, error) in
      if error != nil {
        print("Error: \(String(describing: error))")
      }
      
      guard let data = data else {
        print("Error: No data")
        return
      }
      let json = JSON(data)
      self.locationDataArray.value = Utilities.loadLocationsFromJSON(json: json)
    }
  }
  
  // MARK: fetch Location with cell index
  func fetchLocationWithIndex(_ index: IndexPath) -> Location {
    return locationDataArray.value[index.row]
  }
}

// MARK: - conform to CellRepresentable protocol

extension LocationViewModel: CellRepresentable {
  
  func registerCell(_ tableView: UITableView) {
    tableView.register(LocationCell.nib(), forCellReuseIdentifier: LocationCell.reuseId())
  }
  
  func numberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
    return locationDataArray.value.count
  }
  
  func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseId(), for: indexPath) as! LocationCell
    let data = locationDataArray.value[indexPath.row]
    cell.setup(data)
    
    return cell
  }
}
