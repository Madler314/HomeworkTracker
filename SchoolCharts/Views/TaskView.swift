//
//  TaskView.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 7/25/22.
//

import SwiftUI

struct TaskView: View {
    
    @EnvironmentObject var viewModel: TaskViewModel
    
    @State var task: Task
    
    /*var task: Task {
        
        let taskToDisplay = viewModel.tasks[viewModel.index(of: inputedTask)!]
        return taskToDisplay
    }*/
    
    let calendar = Calendar.current
    
    var body: some View {
        NavigationLink(destination: Fredrica(task: task, isDailyView: false), label: {
                VStack {
                    //Text("\(task.time, style: .time)")
                    Text(task.title)
                        .font(.title2)
                        .bold()
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                        
                    getTaskColor(for: task)
                        .opacity(0.5)
                        .cornerRadius(10)
                )
            }
        )
    }
}

extension TaskView {
    
    func getTaskColor(for task: Task) -> Color {
        
        switch(task.type) {
        case .test:
            return Color(.blue)
        case .quiz:
            return Color(.red)
        case .homework:
            return Color(.green)
        case .taskBreak:
            return Color(.gray)
        case .misc:
            return Color(.purple)
            
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    @State static var task = Task()
    static var previews: some View {
        TaskView(task: task)
    }
}
