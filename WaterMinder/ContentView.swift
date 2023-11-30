//
//  ContentView.swift
//  WaterMinder
//
//  Created by f2205276 on 24/11/2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("dayList") var dayListData: Data = Data()
    @AppStorage("cupList") var cupListData: Data = Data()
    
    var dayList: [Day] {
        get {
            if let decodedData = try? JSONDecoder().decode([Day].self, from: dayListData) {
                return decodedData
            }
            return []
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                dayListData = encodedData
            }
        }
    }
    var cupList: [Cup] {
        get {
            if let decodedData = try? JSONDecoder().decode([Cup].self, from: cupListData) {
                return decodedData
            }
            return []
        }
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                cupListData = encodedData
            }
        }
    }
    
    var body: some View {
        TabView {
            HydrationView()
                .tabItem {
                    Image(systemName: "drop.fill")
                    Text("Hydration")
                }
            HistoryView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg")
                    Text("Record")
                }
            GoalView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Day: Codable {
    var goal: Double;
    var amount: Double;
    var date: Date = Date.now
    var cups: [Cup]
}

struct Cup: Codable {
    var name: String;
    var type: String;
    var hydrationImpact: Double;
    var amount: Double;
}
