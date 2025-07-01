//
//  VoteProgressView.swift
//  MovieApp
//
//  Created by Pedro Borrayo on 29/06/25.
//

import SwiftUI

struct VoteProgressView: View {
    let voteAverage: Double
    let voteCount: Int

    private var progress: Double {
        min(max(voteAverage / 10.0, 0), 1)  // Clamp between 0 and 1
    }

    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.2)
                .foregroundColor(.gray)

            // Progress Circle
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(
                    AngularGradient(gradient: Gradient(colors: [.green, .yellow, .red]), center: .center),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // Start from top
                .animation(.easeOut(duration: 0.6), value: progress)

            // Center Text
            VStack(spacing: 2) {
                Text(String(format: "%.1f", voteAverage))
                    .font(.headline)
                    .bold()
                Text("(\(voteCount))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 80, height: 80)
    }
}

// MARK: - Preview
struct VoteProgressView_Previews: PreviewProvider {
    static var previews: some View {
        VoteProgressView(voteAverage: 7.557, voteCount: 6656)
    }
}

