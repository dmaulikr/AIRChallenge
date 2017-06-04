//
//  NearbyViewModel.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 3/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RxSwift

class NearbyViewModel: NSObject {
  
  fileprivate let networkManager = NetworkManager()
  fileprivate let concurrentQueue = DispatchQueue(label: "jing.luo.concurrent", attributes: .concurrent)
  fileprivate let group = DispatchGroup()

  fileprivate var exsitRunner: Set<Int>?

  var numOfTopRunner = 0
  var locationId: Int?
  var runnerDataArray = Variable([Runner]())
  var activityDataArray = Variable([Activity]())

  // MARK: init
  override init() {
    super.init()
    
    // record runnerIds to make sure the same runner doesn't insert to the TopRunner array many times
    exsitRunner = Set<Int>()
  }
  
  // MARK: fetch Recent activity data with "locationId"
  func startFetchData() {
    if let locationId = locationId {
      networkManager.getDataWithFile("location/\(locationId).json", completionHandler: { (data, error) in
        if error != nil {
          print("Error: \(String(describing: error))")
        }
        
        guard let data = data else {
          print("Error: No data")
          return
        }
        let json = JSON(data)
        self.activityDataArray.value = Utilities.loadActivityFromJSON(json: json)
      })
    }
  }
  
  // MARK: update TopRunners array, because you didn't require how many top runners should show up, I use variable "numOfTopRunner" to indicate
  func updateTopRunners(_ runner: Runner) {
    if runnerDataArray.value.count == 0 {
      runnerDataArray.value.insert(runner, at: 0)
      return
    }
    for i in 0 ..< runnerDataArray.value.count {
      let r = runnerDataArray.value[i]
      if i >= numOfTopRunner {
        break
      }
      // always keep the top Rating runners on the list
      if runner.rating >= r.rating {
        runnerDataArray.value.insert(runner, at: i)
        break
      } else {
        runnerDataArray.value.insert(runner, at: i)
      }
    }
  }
}

// MARK: - conform to CellRepresentable protocol

extension NearbyViewModel: CellRepresentable {
  
  func numberOfSections() -> Int {
    return 2
  }

  func titleForSection(_ tableView: UITableView, section: Int) -> String {
    return (section == 0) ? "Top Runners" : "Recent Activity"
  }

  func registerCell(_ tableView: UITableView) {
    tableView.register(NearbyCell.nib(), forCellReuseIdentifier: NearbyCell.reuseId())
  }
  
  func numberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
    if section == 0 {
      return runnerDataArray.value.count >= numOfTopRunner ? numOfTopRunner : runnerDataArray.value.count
    } else if section == 1 {
      return activityDataArray.value.count
    }
    return 0
  }
  
  func cellInstance(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: NearbyCell.reuseId(), for: indexPath) as! NearbyCell
    
    // runner cell
    if indexPath.section == 0 {
      let data = runnerDataArray.value[indexPath.row] as Runner
      cell.setup(data)
    }
    
    // recent activity cell
    if indexPath.section == 1 {
      var data = activityDataArray.value[indexPath.row] as Activity
      
      // for each activity, we just have the task_id and profile_id, 
      // we didn't get detail info about Task and Runner, 
      // so we have to fetch for those data based on the task_id and profile_id,
      // I create a Dispatch Group to make sure update cell after both Task and Runner info are fetched,
      // after get the full info of Task and Runner, set them into Activity and update cell
      
      // fetch Runner detail
      group.enter()
      var runner: Runner?
      concurrentQueue.async {
        self.networkManager.getDataWithFile("profile/\(data.profileId).json", completionHandler: { (data, error) in
          if error != nil {
            print("Error: \(String(describing: error))")
          }
          
          guard let data = data else {
            print("Error: No data")
            return
          }
          let json = JSON(data)
          runner = Runner(json: json)
          self.group.leave()
        })
      }
    
      // fetch Task detail
      var task: Task?
      group.enter()
      concurrentQueue.async {
        self.networkManager.getDataWithFile("task/\(data.taskId).json", completionHandler: { (data, error) in
          if error != nil {
            print("Error: \(String(describing: error))")
          }
          
          guard let data = data else {
            print("Error: No data")
            return
          }
          let json = JSON(data)
          task = Task(json: json)
          self.group.leave()
        })
      }
      
      // notify after both Runner and Task details has been fetched
      group.notify(queue: DispatchQueue.main) {
        if let runner = runner {
          data.runner = runner
          
          // For each time we get a new runner's info and it's never been fetched before, update it to runnerDataArray
          if var exsitRunner = self.exsitRunner, let id = data.runner?.id {
            if !exsitRunner.contains(id) {
              exsitRunner.insert(id)
              self.exsitRunner = exsitRunner
              if let runner = data.runner {
                self.updateTopRunners(runner)
              }
            }
          }
        }
        
        if let task = task {
          data.task = task
        }
        
        data.setupActivity()
        cell.setup(data)
      }
    }
    
    return cell
  }
}
