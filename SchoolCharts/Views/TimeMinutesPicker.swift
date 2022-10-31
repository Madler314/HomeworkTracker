//
//  EditDailyTask.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 7/28/22.
//

import SwiftUI

struct TimeMinutesPicker: View {
    
    @EnvironmentObject var viewModel: TaskViewModel
    @Binding var task: Task
    
    var body: some View {
        Stepper(value: $task.hours, in: 0...23, step: 1) {
            HStack {
                Text("Hours:")
                TextField("Hours!!!", value: $task.hours, formatter: NumberFormatter.decimal)
                    .keyboardType(.numbersAndPunctuation)
            }
        }.listRowBackground(AppColor.background)
        Stepper(value: $task.minutes, in: 0...55, step: 5) {
            HStack {
                Text("Minutes:")
                TextField("Minutes", value: $task.minutes, formatter: NumberFormatter.decimal)
                    .keyboardType(.numbersAndPunctuation)
            }
        }.listRowBackground(AppColor.background)
        if task.type != .taskBreak {
            Stepper(value: $task.priority, step: 1) {
                HStack {
                    Text("Priority:")
                    TextField("Priority", value: $task.priority, formatter: NumberFormatter.decimal)
                        .keyboardType(.numbersAndPunctuation)
                }
            }
        }
    }
}

struct timeMinutesPicker_Previews: PreviewProvider {
    
    @State static var task = Task()
    
    static var previews: some View {
        TimeMinutesPicker(task: $task)
    }
}
