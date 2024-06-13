//
//  RoundedRectangleWithShadow.swift
//  FetchTest
//
//  Created by Brian King on 6/11/24.
//

import Foundation
import SwiftUI

struct RoundedRectangleWithShadow: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 22.0)
            .fill(.white.shadow(.drop(color: .black.opacity(0.28), radius: 3, x: 0, y: 6)))
    }
}
