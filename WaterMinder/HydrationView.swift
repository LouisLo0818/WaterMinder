//
//  HydrationView.swift
//  WaterMinder
//
//  Created by f2205276 on 24/11/2023.
//

import SwiftUI

struct HydrationView: View {
    @State private var progress: Double = 0.6
    @State private var currentPage: Int = 0
    
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
                
                // NavigationLink to SecondView
                NavigationLink(destination: SecondView(progress: progress, total: "41.3oz", remaining: "-22.7oz")) {
                    Text("Update Hydration")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

struct SecondView: View {
    @State private var isFormPresented = false
    @State private var progress: Double = 0.0
    let total: String
    let remaining: String
    
    init(progress: Double, total: String, remaining: String) {
        self._progress = State(initialValue: progress)
        self.total = total
        self.remaining = remaining
    }
    
    var body: some View {
        VStack {
            Text("This is the Second View")
            
            Spacer()
            
            Button(action: {
                isFormPresented.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 30)
            
            ProgressBar(progress: $progress, total: total, remaining: remaining)
        }
        .padding()
        .sheet(isPresented: $isFormPresented) {
            VStack {
                PopupView()
                    .presentationDetents([.height(550)])
            }
        }
    }
    
    private func simulateProgress() {
        // Simulate progress update
        withAnimation(.linear(duration: 2.0)) {
            progress = 1.0
        }
    }
}

struct ProgressBar: View {
    @Binding var progress: Double
    let total: String
    let remaining: String

    var body: some View {
        HStack {
            Text(total)
            Text("• \(Int(progress * 100))%")
            Spacer()
            Text("Remaining: \(Int(progress * 100))%")
        }
        .padding(.horizontal)

        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 5) // Adjust the corner radius as needed
                .frame(height: 10)
                .opacity(0.3)
                .foregroundColor(Color.gray)

            RoundedRectangle(cornerRadius: 5) // Adjust the corner radius as needed
                .frame(width: CGFloat(progress) * UIScreen.main.bounds.width, height: 10)
                .foregroundColor(Color.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 5) // Adjust the corner radius as needed
                        .stroke(Color.blue, lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
}


struct PopupView: View {
    @State private var inputValue: String = ""

    var body: some View {
        VStack {
            Text(inputValue.isEmpty ? "0" : inputValue) // Show "0" as a placeholder
                .font(.title)
                .padding()

            Spacer()

            NumPad(value: $inputValue)
                .padding()

        }
        .padding()
    }
}

struct NumPad: View {
    @Binding var value: String
    @Environment(\.colorScheme) var colorScheme

    let rows = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        [".", "0", "⌫"]
    ]

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 3), spacing: 15) {
            ForEach(rows, id: \.self) { row in
                ForEach(row, id: \.self) { button in
                    Button(action: {
                        if button == "⌫" {
                            value = value.isEmpty ? "" : String(value.dropLast())
                        } else {
                            value += button
                        }
                    }) {
                        Text(button)
                            .frame(width: 70, height: 10)
                            .padding()
                            .background(button.isNumeric ? Color.gray.opacity(0.2) : (button == "⌫" ? Color.red : Color.clear))
                            .cornerRadius(8)
                            .foregroundColor(button.isNumeric ? (colorScheme == .dark ? .white : .black) : (button == "⌫" ? .white : .primary))
                    }
                }
            }
        }
        
        Button(action: {
            // Add button action logic here
        }) {
            Text("ADD")
                .padding()
                .frame(width: 150, height: 40)  // Set the desired width and height
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(50)
        }
    }
}

extension String {
    var isNumeric: Bool {
        return Double(self) != nil
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
