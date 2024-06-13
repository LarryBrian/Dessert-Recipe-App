//
//  FetchTestApp.swift
//  FetchTest
//
//  Created by Brian King on 6/10/24.
//

import SwiftUI

@main
struct FetchTestApp: App {
    var body: some Scene {
        WindowGroup {
            MealsView(viewModel: MealsViewModel())
        }
    }
}
