//
//  Enum.swift
//  CollectionViewDemo
//
//  Created by Lahiru Chathuranga on 4/6/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import Foundation

enum DeviceOrientation {
    case landscape, portrait
}

enum UIUserInterfaceIdiom : Int {
    case unspecified

    case phone // iPhone and iPod touch style UI
    case pad   // iPad style UI (also includes macOS Catalyst)
}

enum DeviceTypeAndOrientation {
    case phonePortrait
    case phoneLandscape
    case padPortrait
    case padLandscape
}
