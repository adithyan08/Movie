//
//  EmptyStateImage.swift
//  MovieApp
//
//  Created by adithyan na on 5/9/25.
//

import Foundation
import SwiftUI
struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "film.stack")
                .font(.system(size: 64))
                .foregroundColor(.gray)
            
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
