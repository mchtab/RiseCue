//
//  SunriseWidgetExtensionBundle.swift
//  SunriseWidgetExtension
//
//  Created by Michael Chen on 1/13/26.
//

import WidgetKit
import SwiftUI

@main
struct SunriseWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        SunriseWidgetExtension()
        SunriseWidgetExtensionControl()
        SunriseWidgetExtensionLiveActivity()
    }
}
