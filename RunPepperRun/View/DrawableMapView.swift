//
//  DrawableMapView.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/21/23.
//

import UIKit
import MapKit

protocol MapViewDrawable {
    func drawRoute(with coordinates: [CLLocationCoordinate2D])
    func drawPin(at coordinates: CLLocationCoordinate2D, title: String?)
}

class DrawableMapView: MKMapView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("DrawableMapView 생성 실패")
    }
}

extension DrawableMapView: MapViewDrawable {

    func drawRoute(with coordinates: [CLLocationCoordinate2D]) {
        let count = coordinates.count
        let line = MKPolyline(coordinates: coordinates, count: count)
        
        DispatchQueue.main.async { [weak self] in
            self?.addOverlay(line, level: .aboveRoads)
            let customEdgePadding: UIEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 20)
            self?.setVisibleMapRect(line.boundingMapRect, edgePadding: customEdgePadding, animated: false)
        }
    }

    func drawPin(at coordinate: CLLocationCoordinate2D, title: String?) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        self.addAnnotation(annotation)
    }
}
