//
//  TaskModel.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 7/23/22.
//

import SwiftUI

// Task Model and Sample Tasks...
//Array of Tasks...
struct Task: Identifiable, Hashable, Codable {
    
    var id = UUID().uuidString
    var title: String = ""
    var date: Date = Date()
    var type: TaskType = .misc
    
    var manualTime: Bool = true
    var hours: Int = 0
    var minutes: Int = 0
    var totalMinutes: Int {
        hours*60 + minutes
    }
    
    var difficulty: Int = 0
    var urgency: Int = 0
    var totalPoints: Int {
        difficulty+urgency
    }
    var startTime: Date = Date()
    var endTime: Date {
        return Calendar.current.date(byAdding: .minute, value: totalMinutes, to: startTime)!
    }
    
    var priority: Int = 1
    
    enum TaskType: String, CaseIterable, Codable {
        case test = "test"
        case quiz = "quiz"
        case homework = "homework"
        case taskBreak = "break"
        case misc = "misc"
    }
    
    /*init(title: String, time: Date, type: TaskType) {
        self.title = title
        self.time = time
        self.type = type
    }

    init() {
        self.id = UUID().uuidString
        self.type = .misc
        self.time = Date()
        self.type = .misc
    }*/
}

extension Task {
    static var tasks: [Task] = [
        Task(title: "Talk to Anwita", priority: 1),
        Task(title: "Conquer the World", priority: 2),
        Task(title: "Infest Satan with Jaundice", date: getSampleDate(offset: 2)),
        Task(title: "Become Awesome", date: getSampleDate(offset: 2)),
        Task(title: "Super Scary Math Test!", date: getSampleDate(offset: 5), type: .test),
        Task(title: "Mega Freaky Programming Quiz!", date: getSampleDate(offset: 5), type: .quiz)
    ]
    
    static var listy: [String] = ["Hello!"]
}

// Total Task Meta View...
/*struct TaskMetaData: Identifiable {
    var id = UUID().uuidString
    @State var task: [Task]
    var taskDate: Date
    
}*/

// sample Date for Testing...
func getSampleDate(offset: Int) -> Date {
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

/*extension TaskMetaData {
    static var tasks: [TaskMetaData] = [

        TaskMetaData(task: [
        
                        Task(title: "Talk to Anwita"),
                        Task(title: "Conquer the World")],
                     taskDate: Date()),
        TaskMetaData(task: [
                        Task(title: "Infest Satan with Jaundice"),
                        Task(title: "Become awesome")],
                     taskDate: getSampleDate(offset: 2)),
        
        TaskMetaData(task: [
        
                        Task(title: "NONEXISTANT MATH TEST", type: .test),
                        Task(title: "NONEXISTANT PROGRAMMING QUIZ", type: .quiz)],
                     taskDate: getSampleDate(offset: 5))
    ]

    static var listy = ["AH!", nil]
}*/
