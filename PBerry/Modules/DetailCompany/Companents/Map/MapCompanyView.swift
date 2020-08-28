//
//  MapCompanyView.swift
//  PBerry
//
//  Created by Роман on 26.08.2020.
//  Copyright © 2020 destplay. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapCompanyDataSource {
    func mapCompany(_ mapView: MKMapView) -> CLLocationCoordinate2D?
}

class MapCompanyView: UIViewController {

    @IBOutlet private var mapView: MKMapView!
    
    var dataSource: MapCompanyDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.configView()
    }
    
    func configView() {
        guard let location = self.dataSource?.mapCompany(self.mapView) else { return }
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
        self.addMarker(location)
    }
    
    private func addMarker(_ location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.title = "Your text here"
        annotation.subtitle = "One day I'll go here..."
        annotation.coordinate = location
        self.mapView.addAnnotation(annotation)
    }
}
