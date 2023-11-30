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
    @EnvironmentObject private var days: GlobalDays
    
    var body: some View {
        NavigationView {
            VStack {
                
                VStack {
                        Picker("Category", selection: $selectedOption) {
                            Text("Day").tag("Day")
                            Text("All").tag("All")
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        
                        if selectedOption == "Day" {
                            LineView(data: getDayCurve(), legend: "Today's cups", style: Styles.barChartStyleNeonBlueLight)
                                .padding()
                            
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
                                
                                HStack {
                                    Text("Cups")
                                        .font(.subheadline)
                                    Spacer()
                                    Text(String(findCups()) + " cups")
                                        .font(.subheadline)
                                }
                                .padding(.leading, 8)
                                
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
                            
                        } else {
                            LineView(data: getAllCurve(), legend: "Daily amount", style: Styles.barChartStyleNeonBlueLight)
                                .padding()
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Total")
                                        .font(.headline)
                                    Spacer()
                                    Text(String(findTotalAmount()) + "oz")
                                        .font(.headline)
                                }
                                .padding(.leading, 8)
                                
                                HStack {
                                    Text("Avg. Amount")
                                        .font(.subheadline)
                                    Spacer()
                                    Text(String(calculateAllAverage()) + "oz")
                                        .font(.subheadline)
                                }
                                .padding(.leading, 8)
                                
                                HStack {
                                    Text("Avg. Cup Count")
                                        .font(.subheadline)
                                    Spacer()
                                    Text(String(calculateAverageCupCount()) + "cups")
                                        .font(.subheadline)
                                }
                                .padding(.leading, 8)
                                
                                HStack {
                                    Text("Goals Achieved")
                                        .font(.subheadline)
                                    Spacer()
                                    Text(String(totalGoalAchieved()) + " days")
                                        .font(.subheadline)
                                }
                                .padding(.leading, 8)
                                
                                HStack {
                                    Text("Complete %")
                                        .font(.subheadline)
                                    Spacer()
                                    Text(String(calculateComplete()*100) + "%")
                                        .font(.subheadline)
                                }
                                .padding(.leading, 8)
                            }
                            .cornerRadius(8)
                            .padding(16)
                        }
                        
                        Spacer()
                    }

            }
            .navigationBarTitle("History", displayMode: .large)
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
    
    func findCups() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let matchingDay = days.days.first(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            return matchingDay.cups.count
        }
        
        return 0
    }
    
    func findTotalAmount() -> Double {
        return days.days.reduce(0.0) { result, day in
                return result + day.amount
            }
    }
    
    func calculateAllAverage() -> Double {
        return (findTotalAmount()/Double(days.days.count)).rounded(toPlaces: 2)
    }
    
    func totalGoalAchieved() -> Int {
        let matchingDays = days.days.filter { $0.amount >= $0.goal }
        return matchingDays.count
    }
    
    func calculateComplete() -> Double {
        let matchingDays = days.days.filter { $0.amount >= $0.goal }
        return Double(matchingDays.count/days.days.count)
    }
    
    func calculateAverageCupCount() -> Double {
        let totalCupCount = days.days.reduce(0) { result, day in
            return result + day.cups.count
        }
        
        let dayCount = Double(days.days.count)
        
        if dayCount > 0 {
            return (Double(totalCupCount) / dayCount).rounded(toPlaces: 2)
        } else {
            return 0.0
        }
    }
    
    func getDayCurve() -> [Double] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let day = days.days.first(where: { calendar.isDate($0.date, inSameDayAs: today) }) {
            return day.cups.map { $0.amount * $0.hydrationImpact }
        }
        
        return []
    }
    
    func getAllCurve() -> [Double] {
        return days.days.map { $0.amount }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
