//
//  CellRepresentable.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 3/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import UIKit


@objc protocol CellRepresentable {
  
  @objc optional func numberOfSections() -> Int
  @objc optional func titleForSection(_ tableView: UITableView, section: Int) -> String
  @objc optional func sectionHeaderView(_ tableView: UITableView, indexPath: IndexPath) -> UIView?

  func registerCell(_ tableView: UITableView)
  func numberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int
  func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
}


protocol NearbyDisplayDataProtocol {
  
  var imageUrl: String? { get set }
  var title: String? { get set }
  var subTitle: String? { get set }
  var body: String? {get set }
  
}
