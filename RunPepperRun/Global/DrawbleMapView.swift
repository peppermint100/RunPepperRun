//
//  DrawbleMapView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 1/9/24.
//

import Foundation
import MapKit

protocol MapViewDrawble {
    func drawRoute(points: [Point])
    func drawPinAt(point: Point?, title: String?)
}

extension MKMapView: MapViewDrawble {
    func drawRoute(points: [Point]) {
        let count = points.count
        let line = MKPolyline(coordinates: points.map{ $0.toCoordinate() }, count: count)
        
        DispatchQueue.main.async { [weak self] in
            self?.addOverlay(line, level: .aboveRoads)
            let customEdgePadding: UIEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 20)
            self?.setVisibleMapRect(line.boundingMapRect, edgePadding: customEdgePadding, animated: false)
        }
    }
    
    func drawPinAt(point: Point?, title: String?) {
        if let point = point {
            let annotation = MKPointAnnotation()
            annotation.coordinate = point.toCoordinate()
            annotation.title = title
            self.addAnnotation(annotation)
        }
    }
}
