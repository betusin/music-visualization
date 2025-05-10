//
//  ContentView.swift
//  music-visualization-watch Watch App
//
//  Created by Alžbeta Hajná on 10.05.2025.
//
import SwiftUI

struct SmallHomePage: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) { // Replace with `smallGapSize` equivalent
                NavigationLink(destination: PairWithPhonePage()) {
                    Label("Pair", systemImage: "link")
                }

                NavigationLink(destination: VibrationPage()) {
                    Label("Vibrate", systemImage: "waveform")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
