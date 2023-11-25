//
//  GoalView.swift
//  WaterMinder
//
//  Created by f2205276 on 25/11/2023.
//

import SwiftUI

struct GoalView: View {
    @State private var cupName: String = "Water"
    @State private var type: String = "Water"
    @State private var Impact: Int = 1
    @State private var amount: Int = 14
    @State private var timer: Int = 15
    @State private var isNotificationEnabled: Bool = true
    @State private var isTimerEnabled: Bool = false

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(cupName)
                            .foregroundColor(.gray)
                    }
                }
                Section {
                    HStack {
                        Text("Drink type")
                        Spacer()
                        Text(type)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Hydration Impact")
                        Spacer()
                        Text("\(Impact)")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Drink Amount")
                        Spacer()
                        Text("\(amount)oz")
                            .foregroundColor(.gray)
                    }
                }
                Section {
                    Text("Icon")
                    Text("Color")
                }
                Section() {
                    Toggle("Enable Notification", isOn: $isNotificationEnabled)
                    HStack {
                        Text("Timer")
                            .foregroundColor(isNotificationEnabled ? .primary : .gray)
                            .disabled(!isNotificationEnabled)
                        Spacer()
                        Text("\(timer)mins")
                            .foregroundColor(.gray)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Edit Cup")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                // Add save button action logic here
            }) {
                Text("Save")
                    .foregroundColor(.blue)
            })
        }
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView()
    }
}
