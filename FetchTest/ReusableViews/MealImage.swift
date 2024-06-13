//
//  MealImage.swift
//  FetchTest
//
//  Created by Brian King on 6/12/24.
//

import Foundation
import SwiftUI

struct MealImage: View {
    let urlString: String?
    var body: some View {
        if let _urlString = urlString, let _url = URL(string: _urlString) {
            CachedAsyncImage(url: _url, content: { thumbnailImage in
                thumbnailImage
                    .resizable()
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange, Color.yellow, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 4.0)
                    )
            })            
        } else {
            Image(systemName: "photo")
                .resizable()
                .foregroundStyle(.gray).opacity(0.50)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.gray, lineWidth: 4.0)
                )
        }
    }
}
