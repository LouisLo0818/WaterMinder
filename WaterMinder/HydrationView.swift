//
//  HydrationView.swift
//  WaterMinder
//
//  Created by f2205276 on 24/11/2023.
//

import SwiftUI

struct HydrationView: View {
    @EnvironmentObject private var days: GlobalDays
    
    var body: some View {
        NavigationView {
            VStack {
                Ring(progress: calculatePercentage(), lineWidth: 20, processText: String(format: "%.2f", (calculatePercentage()*100)) + "%", totalText: (String(findTodayAmount()) + "oz"), leftoverText: ("-" + String(calculateDifference()) + "oz"))
                    .frame(width: 280, height: 280)
                    .padding(.top, 70)
                    Spacer()
                    .navigationBarTitle("Current Hydration", displayMode: .large)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(String(findTodayAmount()) + "oz")
                            .font(.headline)
                    }
                    .padding(.leading, 8)
                    
                    HStack {
                        Text("Date")
                            .font(.subheadline)
                        Spacer()
                        Text(findTodayDate())
                            .font(.subheadline)
                    }
                    .padding(.leading, 8)
                    
//                    HStack {
//                        Text("Streak")
//                            .font(.subheadline)
//                        Spacer()
//                        Text("0 days")
//                            .font(.subheadline)
//                    }
//                    .padding(.leading, 8)
                    
                    HStack {
                        Text("Avg. Size")
                            .font(.subheadline)
                        Spacer()
                        Text(String(calculateAverage()) + "oz")
                            .font(.subheadline)
                    }
                    .padding(.leading, 8)
                    
                    HStack {
                        Text("Goal Achieved")
                            .font(.subheadline)
                        Spacer()
                        Text(goalAchieved())
                            .font(.subheadline)
                    }
                    .padding(.leading, 8)
                }
                .cornerRadius(8)
                .padding(16)
                Spacer()
                
                // NavigationLink to SecondView
                NavigationLink(destination: SecondView(progress: calculatePercentage(), total: (String(findTodayAmount()) + "oz"), remaining: ("-" + String(calculateDifference()) + "oz"))) {
                    Text("Update Hydration")
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            loadDays()
        }
        .onDisappear {
            saveDays()
        }
    }
    
    func loadDays() {
        if let data = UserDefaults.standard.data(forKey: "days"),
           let savedDays = try? JSONDecoder().decode([Day].self, from: data) {
            days.days = savedDays
        }
    }
    
    func saveDays() {
        if let encodedData = try? JSONEncoder().encode(days.days) {
            UserDefaults.standard.set(encodedData, forKey: "days")
        }
    }
    
    func findTodayAmount() -> Double {
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return days.days.first(where: { calendar.isDate($0.date, inSameDayAs: today) })?.amount ?? 0.0
    }
    
    func findTodayGoal() -> Double {
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return days.days.first(where: { calendar.isDate($0.date, inSameDayAs: today) })?.goal ?? 0.0
    }
    
    func findTodayDate() -> String {
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let todayRecord = days.days.first(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: todayRecord.date)
        }
        
        return "No record"
    }
    
    func calculatePercentage() -> Double {
        
        guard findTodayGoal() != 0 else {
            return 0.0 // Prevent division by zero
        }
        
        let percentage = (findTodayAmount() / findTodayGoal()).rounded(toPlaces: 4)
        return percentage
    }
    
    func calculateDifference() -> Double {
        let diff = (findTodayGoal() - findTodayAmount())
        if (diff < 0.0) {
            return 0.0
        }
        return diff
    }
    
    func calculateAverage() -> Double {
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let todayRecord = days.days.first(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            let cupAmounts = todayRecord.cups.map { $0.amount }
            if (cupAmounts.count == 0) {
                return 0.0
            }
            let totalAmount = cupAmounts.reduce(0, +)
            let averageAmount = (totalAmount / Double(cupAmounts.count)).rounded(toPlaces: 2)
            return averageAmount
        }
        
        return 0.0
    }
    
    func goalAchieved() -> String {
        if (calculateDifference() == 0.0) {
            return "Yes"
        }
        else {
            return "No"
        }
    }
}

struct SecondView: View {
    @State private var isFormPresented = false
    @State private var progress: Double = 0.0
    @Environment(\.colorScheme) var colorScheme
    
    let total: String
    let remaining: String
    
    init(progress: Double, total: String, remaining: String) {
        self._progress = State(initialValue: progress)
        self.total = total
        self.remaining = remaining
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("panda")
                .resizable()
                .frame(width: 450, height: 500)
                .offset(y: -50)
            // overlay blue color
                .overlay(
                    VStack {
                        Color.blue.opacity(0)
                        Color.blue.opacity(0.4)
                            .frame(height: min(500 * progress, 500))
                            .offset(y: -54)
                    }
                )
            
            if colorScheme == .light {
                Image("white")
                    .resizable()
                    .frame(width: 450, height: 500)
                    .offset(y: -50)
            } else {
                Image("back")
                    .resizable()
                    .frame(width: 450, height: 500)
                    .offset(y: -50)
            }
        }
        
        VStack {
            Button(action: {
                isFormPresented.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 20)

            ProgressBar(progress: $progress, total: total, remaining: remaining)
        }
        .padding()
        .offset(y: -30) // Adjust the offset to position the overlay image
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
            Text("Remaining: \(max(Int((1 - progress) * 100), 0))%")
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
    @State private var selectedDrink: String = "Water"
    
    var drinkOptions = ["Water", "Tea"]

    var body: some View {
        VStack {
            Text(inputValue.isEmpty ? "0" : inputValue + " Oz")
                .font(.title)
                .padding()

            Picker("Select Drink", selection: $selectedDrink) {
                ForEach(drinkOptions, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 300, height: 120) // Set the desired width and height
            .padding()
            
            NumPad(value: $inputValue, dType: $selectedDrink)
                .padding()

        }
        .padding()
    }
}

struct NumPad: View {
    @EnvironmentObject private var days: GlobalDays
    
    @Binding var value: String
    @Environment(\.colorScheme) var colorScheme
    @Binding var dType: String

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
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let amount = Double(value)
            let hydrationLevel: Double = (dType == "Tea") ? 0.75 : 1.0
            
            if let todayIndex = days.days.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
                let cup = Cup(name: dType, hydrationImpact: hydrationLevel, amount: amount ?? 0.0, time: Date.now)
                days.days[todayIndex].cups.append(cup)
                days.days[todayIndex].amount += (cup.amount * cup.hydrationImpact)
                
//                days[todayIndex].cups = []
//                days[todayIndex].amount = 0
                
            }
        }) {
            Text("ADD")
                .padding()
                .frame(width: 150, height: 40)  // Set the desired width and height
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(50)
        }
        .onAppear {
            loadDays()
        }
        .onDisappear {
            saveDays()
        }
    }
    
    func loadDays() {
        if let data = UserDefaults.standard.data(forKey: "days"),
           let savedDays = try? JSONDecoder().decode([Day].self, from: data) {
            days.days = savedDays
        }
        print("Loaded")
    }
    
    func saveDays() {
        if let encodedData = try? JSONEncoder().encode(days.days) {
            UserDefaults.standard.set(encodedData, forKey: "days")
            print("Saved")
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
