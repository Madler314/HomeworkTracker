//
//  EditDailyTasks.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 7/30/22.
//

import SwiftUI

struct EditDailyTasks: View {
    
    @EnvironmentObject var viewModel: TaskViewModel
    
    @State var tasks: [Task]
    //@State var filteredTasks: [Task] = tasks.filter { $0.title != "break" }
    @State var newTask = Task()
    //@State var newBreakLength: Int = 10
    
    
    var body: some View {
        VStack {
            Form {
                DatePicker("Start Time", selection: $viewModel.startTime, displayedComponents: [.hourAndMinute])
                ForEach(tasks) { task in
                    //newTask = task
                    if task.type != .taskBreak {
                        EditPriority(task: binding(for: task))
                    //viewModel.addTask(newTask: newTask)
                    //newTask = Task()
                    }
                }
                Stepper(value: $viewModel.breakLength, step: 5) {
                    HStack {
                        Text("Break Length:")
                        Spacer()
                        TextField("Break Length", value: $viewModel.breakLength, formatter: NumberFormatter.decimal)
                            .keyboardType(.numbersAndPunctuation)
                }
            }
                Stepper(value: $viewModel.homeworkTime, step: 15) {
                    HStack {
                        Text("Time for homework: ")
                        Spacer()
                        TextField("Homework Time", value: $viewModel.homeworkTime,
                                  formatter: NumberFormatter.decimal)
                            .keyboardType(.numbersAndPunctuation)
                    }
                }
                Button("Save") {
                    for task in tasks {
                        viewModel.addTask(newTask: task, overrideBreakLength: false)
                    }
                    //viewModel.changeBreakLength(breakLength: newBreakLength)
                }
            }
        }
    }
}

extension EditDailyTasks {
    
    func binding(for task: Task) -> Binding<Task> {
        guard let index = viewModel.otherIndex(of: task, in: tasks) else {
            fatalError("Task Not Found")
        }
        return $tasks[index]
    }
}

struct EditDailyTasks_Previews: PreviewProvider {

    var tasks = Task.tasks
    
    static var previews: some View {
        HomeView()
    }
}
