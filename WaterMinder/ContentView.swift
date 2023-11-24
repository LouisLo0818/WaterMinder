//
//  ContentView.swift
//  WaterMinder
//
//  Created by f2205276 on 24/11/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HydrationView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Record")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg")
                    Text("Record")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
