//
//  HydrationView.swift
//  WaterMinder
//
//  Created by f2205276 on 24/11/2023.
//

import SwiftUI

struct HydrationView: View {
    @State private var progress: Double = 0.6
    
    var body: some View {
        NavigationView {
            VStack {
                Ring(progress: progress, lineWidth: 20, processText: "64%", totalText: "41.3oz", leftoverText: "-22.7oz")
                    .frame(width: 280, height: 280)
                    .padding(.top, 70)
                    Spacer()
                    .navigationBarTitle("Current Hydration", displayMode: .large)
                
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
                Spacer()
            }
        }
    }
}

struct Ring: View {
    var progress: Double
    var lineWidth: CGFloat
    var processText: String
    var totalText: String
    var leftoverText: String

    var body: some View {
        ZStack {
            // Background Ring
            Circle()
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue.opacity(0.2))

            // Foreground Ring
            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: -90)) // Start from the top
            
            // Center Text
            VStack {
                Text(processText)
                    .font(.title)
                    .fontWeight(.bold) // Make the font bold
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text(totalText)
                    .font(.system(size: 35)) // Set the desired font size
                    .fontWeight(.bold) // Make the font bold
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Text(leftoverText)
                    .font(.title)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: 200, height: 200) // Adjust the size of the frame as needed
        }
    }
}

struct HydrationView_Previews: PreviewProvider {
    static var previews: some View {
        HydrationView()
    }
}
