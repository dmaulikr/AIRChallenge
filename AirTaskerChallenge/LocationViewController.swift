//
//  ViewController.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 2/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import UIKit
import RxSwift

class LocationViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  fileprivate let disposeBag = DisposeBag()
  
  var viewModel = LocationViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setUp()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showNearby" {
      let controller = segue.destination as! NearbyViewController
      controller.location = sender as? Location
    }
  }
}

// MARK: - set up

extension LocationViewController {
  
  fileprivate func setUp() {
    
    setupTableView()
    
    bindViewModel()
    viewModel.startFetchData()
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = 80.0
  }
}

// MARK: - Bind to ViewModel

extension LocationViewController {
  
  func bindViewModel() {
    
    // config ViewModel
    viewModel.registerCell(tableView)
    
    // reload tableview when locationDataArray is updated
    viewModel.locationDataArray.asObservable()
      .subscribe(onNext: {
        if $0.count > 0 {
          self.tableView.reloadData()
        }
      })
    .addDisposableTo(disposeBag)
  }
}


// MARK: - UITableViewDataSource

extension LocationViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRowsInSection(tableView, section: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return viewModel.cellInstance(tableView, indexPath: indexPath)
  }
}


// MARK: - UITableViewDelegate

extension LocationViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "showNearby", sender: viewModel.fetchLocationWithIndex(indexPath))
  }
}

