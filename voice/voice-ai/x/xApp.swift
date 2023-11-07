//
//  xApp.swift
//  x
//
//  Created by Aaron Li on 10/13/23.
//

import SwiftUI
import SwiftData

@main
struct xApp: App {
    @StateObject var store = Store()
    var body: some Scene {
        WindowGroup {
           // Currently we are displaying only buttons
          //  DashboardView()
            ActionsView().environmentObject(store).background(Color(hex: 0x1E1E1E).animation(.none))
        }
    }
}
