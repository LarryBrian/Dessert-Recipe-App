//
//  OrangeDivider.swift
//  FetchTest
//
//  Created by Brian King on 6/12/24.
//

import Foundation
import SwiftUI

struct OrangeDivider: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .frame(height: 1.5)
            .foregroundStyle(.orange)
            .padding(.horizontal, 40)
    }
}
