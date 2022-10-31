//
//  EditDailyTasks.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 7/30/22.
//

import SwiftUI

struct EditPriority: View {
    
    @Binding var task: Task
    
    var body: some View {
            Stepper(value: $task.priority, step: 1) {
                HStack {
                    Text(task.title)
                    Spacer()
                    Text("Priority:")
                    Spacer()
                    TextField("Priority", value: $task.priority, formatter: NumberFormatter.decimal)
                        .keyboardType(.numbersAndPunctuation)
            }
        }
    }
}

struct EditPriority_Previews: PreviewProvider {
    
    @State static var task: Task = Task(title: "L:KJKL:J")
    
    static var previews: some View {
        EditPriority(task: $task)
    }
}
