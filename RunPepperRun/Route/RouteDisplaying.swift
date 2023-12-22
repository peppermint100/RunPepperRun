//
//  RouteDisplaying.swift
//  RunPepperRun
//
//  Created by peppermint100 on 12/11/23.
//

import Foundation
import MapKit

typealias Pathline = MKPolyline

protocol RouteDisplaying: AnyObject {
    func drawRouteOn(map: MKMapView)
}
