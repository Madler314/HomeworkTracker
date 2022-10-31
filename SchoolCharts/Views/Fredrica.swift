//
//  Fredrica.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 7/23/22.
//

import SwiftUI

struct Fredrica: View {
    
    @EnvironmentObject var viewModel: TaskViewModel
    
    @State var task: Task
    @State var dates = [Date]()
    
    let isDailyView: Bool

    @Environment(\.presentationMode) private var mode
    
    var body: some View {
        VStack {
            Form {
                Toggle(isOn: $task.manualTime, label: {
                    Text("Input Time Manually")
                })
                
                TextField("Name of Task", text: $task.title)
                
                Picker(selection: $task.type, label:
                        HStack {
                            Text("Type")
                            Spacer()
                            Text(task.type.rawValue)
                        }) {
                    ForEach(Task.TaskType.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                if isDailyView {
                    if task.manualTime {
                        TimeMinutesPicker(task: $task)
                    } else {
                        Stepper(value: $task.difficulty, step: 1) {
                            HStack {
                                Text("Difficulty: ")
                                Spacer()
                                TextField("Difficulty", value: $task.difficulty,
                                          formatter: NumberFormatter.decimal)
                                    .keyboardType(.numbersAndPunctuation)
                            }
                        }
                        Stepper(value: $task.urgency, step: 1) {
                            HStack {
                                Text("Urgency: ")
                                Spacer()
                                TextField("Urgency", value: $task.urgency,
                                          formatter: NumberFormatter.decimal)
                                    .keyboardType(.numbersAndPunctuation)
                            }
                        }
                    }
                }
            }
            VStack {
                if !isDailyView {
                    MultiDatePicker(anyDays: $dates)
                }
            }
            .padding(.bottom, 200.0)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    mode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(action: {
                    viewModel.removeTask(task: task)
                    mode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "trash")
                })
            }
            ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        print("S:LDKFJ")
                        //print(task.title)
                        //print(task.date)
                        //print(task.type)
                        if isDailyView {
                            viewModel.addTask(newTask: task, overrideBreakLength: true)
                        } else {
                            for day in dates {
                                var newTask = task
                                newTask.date = day
                                newTask.id = UUID().uuidString
                                viewModel.addTask(newTask: newTask, overrideBreakLength: true)
                            }
                        }
                        //print(viewModel.tasks)
                        mode.wrappedValue.dismiss()
                    }
                }
            })
    }
}

/*struct MultiDatePicker: View {
    
    // the type of picker, based on which init() function is used.
    enum PickerType {
        case singleDay
        case anyDays
        case dateRange
    }
    
    // lets all or some dates be elligible for selection.
    enum DateSelectionChoices {
        case allDays
        case weekendsOnly
        case weekdaysOnly
    }
    
    @StateObject var monthModel: MDPModel
        
    // selects only a single date
    
    init(singleDay: Binding<Date>,
         includeDays: DateSelectionChoices = .allDays,
         minDate: Date? = nil,
         maxDate: Date? = nil
    ) {
        _monthModel = StateObject(wrappedValue: MDPModel(singleDay: singleDay, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
    }
    
    // selects any number of dates, non-contiguous
    
    init(anyDays: Binding<[Date]>,
         includeDays: DateSelectionChoices = .allDays,
         minDate: Date? = nil,
         maxDate: Date? = nil
    ) {
        _monthModel = StateObject(wrappedValue: MDPModel(anyDays: anyDays, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
    }
    
    // selects a closed date range
    
    init(dateRange: Binding<ClosedRange<Date>?>,
         includeDays: DateSelectionChoices = .allDays,
         minDate: Date? = nil,
         maxDate: Date? = nil
    ) {
        _monthModel = StateObject(wrappedValue: MDPModel(dateRange: dateRange, includeDays: includeDays, minDate: minDate, maxDate: maxDate))
    }
    
    var body: some View {
        MDPMonthView()
            .environmentObject(monthModel)
    }
}*/

struct Fredrica_Previews: PreviewProvider {
    
    @State static var newTask = Task()
    static var previews: some View {
        
        Fredrica(task: newTask, isDailyView: false)
        
    }
}
