//
//  xApp.swift
//  x
//
//  Created by Aaron Li on 10/13/23.
//

import SwiftUI

@main
struct xApp: App {

    var body: some Scene {
        WindowGroup {
           // Currently we are displaying only buttons
          //  DashboardView()
            ActionsView()
                .background(Color(hex: 0xDDF6FF))
        }
    }
}
