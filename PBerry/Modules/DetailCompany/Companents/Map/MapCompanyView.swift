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
    func mapCompany(_ mapView: MKMapView) -> MapViewModel?
}

struct MapViewModel {
    var location: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    
    init(location: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.location = location
        self.title = title ?? ""
        self.subtitle = subtitle ?? ""
    }
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
        guard let mapViewModel = self.dataSource?.mapCompany(self.mapView) else { return }
        let region = MKCoordinateRegion(center: mapViewModel.location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
        self.addMarker(mapViewModel)
    }
    
    private func addMarker(_ mapViewModel: MapViewModel) {
        let annotation = MKPointAnnotation()
        annotation.title = mapViewModel.title
        annotation.subtitle = mapViewModel.subtitle
        annotation.coordinate = mapViewModel.location
        self.mapView.addAnnotation(annotation)
    }
}
