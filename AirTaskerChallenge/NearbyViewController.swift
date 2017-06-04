//
//  NearByViewController.swift
//  AirTaskerChallenge
//
//  Created by JINGLUO on 2/6/17.
//  Copyright © 2017 JINGLUO. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

class NearbyViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

  fileprivate let disposeBag = DisposeBag()
  
  var location: Location?
  var viewModel = NearbyViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUp()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

// MARK: - set up

extension NearbyViewController {
  
  fileprivate func setUp() {
    
    setupTableView()
    setupMapView()
    
    bindViewModel()
    activityIndicatorView.startAnimating()
    viewModel.startFetchData()
  }
  
  private func setupTableView() {
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 110.0
  }
  
  private func setupMapView() {
    guard let lat = location?.lat, let lng = location?.lng else {
      print("invalid latitude or longitude")
      return
    }
    
    if let lat = Double(lat), let lng = Double(lng) {
      let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)

      mapView.delegate = self
      mapView.setCenter(coordinate, animated: false)
      
      var region = MKCoordinateRegion()
      region.center = coordinate
      region.span.latitudeDelta = 0.02
      region.span.longitudeDelta = 0.02
      mapView.region = region
      
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      mapView.addAnnotation(annotation)
    }

  }
}

// MARK: - Bind to ViewModel

extension NearbyViewController {
  
  fileprivate func bindViewModel() {
    
    // config viewModel
    viewModel.locationId = location?.id
    viewModel.numOfTopRunner = 3 // how many runners I want to show on Top-Runners
    viewModel.registerCell(tableView)

    // reload "Top Runners" section of tableview when runnerDataArray is updated
    viewModel.runnerDataArray.asObservable()
      .subscribe(onNext: {
        if $0.count > 0 {
          self.tableView.reloadSections([0], with: UITableViewRowAnimation.automatic)
        }
      })
      .addDisposableTo(disposeBag)
    
    // reload "Recent Activity" section of tableview when activityDataArray is updated
    viewModel.activityDataArray.asObservable()
      .subscribe(onNext: {
        if $0.count > 0 {
          self.activityIndicatorView.stopAnimating()
          self.tableView.reloadSections([1], with: UITableViewRowAnimation.automatic)
        }
      })
      .addDisposableTo(disposeBag)
  }
}

// MARK: - MKMapViewDelegate

extension NearbyViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let identifier = "MapPin"
    var view: MKAnnotationView
    
    if let reusable = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
      view = reusable
    } else {
      view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      view.image = UIImage(named: "placeholder")
      view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
      view.canShowCallout = false
      view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.9)
    }
    
    return view
  }
}


// MARK: - UITableViewDataSource

extension NearbyViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRowsInSection(tableView, section: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return viewModel.cellInstance(tableView, indexPath: indexPath)
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return viewModel.titleForSection(tableView, section: section)
  }
}

