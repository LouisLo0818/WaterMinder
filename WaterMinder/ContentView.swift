//
//  ContentView.swift
//  WaterMinder
//
//  Created by f2205276 on 24/11/2023.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @StateObject public var days = GlobalDays()
    @AppStorage("dailyGoal") var dailyGoal: Int = 125
    @AppStorage("notificationTimer") var timer: Int = 20
    @AppStorage("notificationOn") var enabled: Bool = true
    
    var body: some View {
        TabView {
            HydrationView()
                .tabItem {
                    Image(systemName: "drop.fill")
                    Text("Hydration")
                }.environmentObject(days)
            HistoryView()
                .tabItem {
                    Image(systemName: "waveform.path.ecg")
                    Text("Record")
                }.environmentObject(days)
            GoalView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }.environmentObject(days)
        }
        .onAppear {
            loadDays()
            addDayWithCurrentDateIfNeeded()
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
    
    func addDayWithCurrentDateIfNeeded() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if days.days.first(where: { calendar.isDate($0.date, inSameDayAs: today) }) == nil {
            let newDay = Day(goal: Double(dailyGoal), amount: 0, date: today, cups: [])
            days.days.append(newDay)
        }
        
        saveDays()
    }
    
    public func scheduleNotification() {
        if (enabled == false) {
            return
        }
        
        print(timer*60)
        let timeInterval = TimeInterval(timer*60)
            // Call the scheduleNotification function with the retrieved timeInterval
        scheduleNotification(after: timeInterval)
        }
    
    func scheduleNotification(after timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "WaterMinder"
        content.body = "It's time to drink water!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: enabled)
        let request = UNNotificationRequest(identifier: "ReminderNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully.")
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
    var goal: Double
    var amount: Double
    var date: Date
    var cups: [Cup]
    
    mutating func addCup(_ cup: Cup) {
            cups.append(cup)
        }
}

struct Cup: Codable {
    var name: String
    var hydrationImpact: Double
    var amount: Double
    var time: Date
}

class GlobalDays: ObservableObject {
    @Published var days: [Day] = []
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
