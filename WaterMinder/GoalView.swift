//
//  GoalView.swift
//  WaterMinder
//
//  Created by f2205276 on 25/11/2023.
//

import SwiftUI

struct GoalView: View {
    @AppStorage("username") var cupName: String = "User"
    @State private var isNamePopoverPresented = false
    @State private var newName: String = ""
    
    @State private var type: String = "Water"
    @State private var Impact: Int = 1
    
    @State private var isPopoverPresented = false
    @State private var isTPopoverPresented = false
    
    @State private var selectedTimerIndex = (20 / 5) - 1
    @State private var timerOptions = Array(stride(from: 5, through: 60, by: 5))
    
    @AppStorage("dailyGoal") var dailyGoal: Int = 125
    @State private var newGoal: Int = 0
    @AppStorage("notificationTimer") var timer: Int = 20
    @AppStorage("notificationOn") var enabled: Bool = false

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
                    .onTapGesture {
                            isNamePopoverPresented = true
                        }
                        .popover(isPresented: $isNamePopoverPresented, arrowEdge: .top) {
                            VStack {
                                Text("Change Name")
                                    .font(.headline)
                                TextField("Enter new name", text: $newName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                Button(action: {
                                    cupName = newName
                                    isNamePopoverPresented = false
                                }) {
                                    Text("Update Name")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
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
                        Text("Daily Goal")
                        Spacer()
                        Text("\(dailyGoal) Oz")
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                        isPopoverPresented = true
                    }
                    .popover(isPresented: $isPopoverPresented, arrowEdge: .top) {
                        VStack {
                            Text("New Goal")
                                .font(.headline)
                            TextField("Enter new goal", value: $newGoal, format: .number)
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            Button(action: {
                                dailyGoal = newGoal
                                isPopoverPresented = false
                            }) {
                                Text("Update Goal")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                    }
                }
                
                Section {
                    Toggle("Enable Notification", isOn: $enabled)
                    HStack {
                        Text("Timer")
                            .foregroundColor(enabled ? .primary : .gray)
                            .disabled(!enabled)
                        Spacer()
                        Text("\(timer) mins")
                            .foregroundColor(.gray)
                    }
                    .onTapGesture {
                            isTPopoverPresented = true
                        }
                        .popover(isPresented: $isTPopoverPresented, arrowEdge: .top) {
                            VStack {
                                Text("Select Timer")
                                    .font(.headline)
                                Picker("Timer", selection: $selectedTimerIndex) {
                                    ForEach(0..<timerOptions.count) { index in
                                        Text("\(timerOptions[index]) mins")
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 150)
                                .padding()
                                Button(action: {
                                    timer = timerOptions[selectedTimerIndex]
                                    isTPopoverPresented = false
                                }) {
                                    Text("Done")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                        }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Edit Goal")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct GoalView_Previews: PreviewProvider {
    static var previews: some View {
        GoalView()
    }
}
