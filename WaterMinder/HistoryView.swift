//
//  HistoryView.swift
//  WaterMinder
//
//  Created by f2205276 on 24/11/2023.
//

import SwiftUI
import Charts // Import the library you want to use for the chart
import SwiftUICharts

struct HistoryView: View {
    @State private var selectedOption = "Day"
    
    var body: some View {
        NavigationView {
            VStack {
                // Spacer to push the Picker to the top

                Picker("Category", selection: $selectedOption) {
                    Text("Day").tag("Day")
                    Text("All").tag("All")
                }
                .pickerStyle(.segmented)
                .padding()
                Spacer()
                
                LineView(data: ([8,23,54,32,12,37,7,23,43]), legend: "Average", style: Styles.barChartStyleNeonBlueLight).padding() // Set the legend font color to black
                // legend is optional, use optional .padding()

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text("490.4oz")
                            .font(.headline)
                    }
                    .padding(.leading, 8)
                    
                    HStack {
                        Text("Most Logged")
                            .font(.subheadline)
                        Spacer()
                        Text("Water")
                            .font(.subheadline)
                    }
                    .padding(.leading, 8)
                    
                    HStack {
                        Text("Streak")
                            .font(.subheadline)
                        Spacer()
                        Text("0 days")
                            .font(.subheadline)
                    }
                    .padding(.leading, 8)
                    
                    HStack {
                        Text("Avg. Size")
                            .font(.subheadline)
                        Spacer()
                        Text("22.3oz")
                            .font(.subheadline)
                    }
                    .padding(.leading, 8)
                    
                    HStack {
                        Text("Goal Achieved")
                            .font(.subheadline)
                        Spacer()
                        Text("4")
                            .font(.subheadline)
                    }
                    .padding(.leading, 8)
                }
                .cornerRadius(8)
                .padding(16)
            }
            .navigationBarTitle("History", displayMode: .large)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
