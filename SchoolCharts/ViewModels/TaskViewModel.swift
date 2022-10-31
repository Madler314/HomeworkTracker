//
//  TaskViewModel.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 7/25/22.
//

import SwiftUI
import UserNotifications

class TaskViewModel: ObservableObject {
    @Published var tasks = Task.tasks
    @Published var listy = Task.listy
    @Published var startTime = Date()
    @Published var breakLength: Int = 10
    @Published var homeworkTime: Int = 240
    var notificationsExist: Bool = false

    var freakyTasks: [Task] {
        tasks
    }
    
    var filteredTasks: [Task] {
        tasks.filter { isSameDay(date1: $0.date, date2: Date()) }
    }
    
    var sortedTasks: [Task] {
        let newFilteredTasks = calculateTaskTimes(newTasks: filteredTasks)
        return newFilteredTasks.sorted {
            return $0.priority < $1.priority
        }
    }
    
    var breaksArray: [Task] = []
    
    func appendBreaksArray() -> [Task] {
        
        var newBreaksArray: [Task] = []
        for index in sortedTasks.indices {
            if index < sortedTasks.count - 1 {
                if index < breaksArray.count {
                    newBreaksArray.append(breaksArray[index])
                } else {
                    newBreaksArray.append(Task(title: "Break", type: .taskBreak, minutes: breakLength, priority: sortedTasks[index].priority+1))
                }
                //newBreaksArray.append(Task(title: "Break", type: .taskBreak, minutes: breakLength, priority: sortedTasks[index].priority+1))
            }
        }
            return newBreaksArray
    }
    
    var woohooTasks: [Task] {
        dailyTasks()
    }
    
    func dailyTasks() -> [Task] {
        
        if breaksArray.count != sortedTasks.count - 1 {
            breaksArray = appendBreaksArray()
        }
        
        //let calculatedTasks = calculateTaskTimes(newTasks: sortedTasks)

        let newSortedTasks = insertBreaks(sortedTasks: sortedTasks)
        
        //removeNotifications()
        let newTasks = generateStartTimes(sortedTasks: newSortedTasks)
        
        //if notificationsExist {
        //    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        //}
        
        //for task in newTasks {
        //    scheduleNotification(task: task)
        //}
        
        notificationsExist = true
        
        return newTasks
    }
    
    func insertBreaks(sortedTasks: [Task]) -> [Task] {
        
        var newSortedTasks: [Task] = []
        
        for index in sortedTasks.indices {
            
            newSortedTasks.append(sortedTasks[index])
            if index < sortedTasks.count - 1 {
                breaksArray[index].priority = sortedTasks[index].priority
                newSortedTasks.append(breaksArray[index])
                
            }
            //newSortedTasks.append(Task(title: "Break", type: .taskBreak, minutes: breakLength, priority: sortedTasks[index].priority))
        }
        //newSortedTasks.remove(at: newSortedTasks.count-1)
        return newSortedTasks
    }
    
    func generateStartTimes(sortedTasks: [Task]) -> [Task] {
        
        //print("Checkpoint 0")
        var newSortedTasks = sortedTasks
        var funcStartTime = startTime
        
        for task in newSortedTasks {
            //print(task)
            //print("Checkpoint 1")
            var newTask = task
            newTask.startTime = funcStartTime
            
            guard let index = otherIndex(of: task, in: newSortedTasks) else {
                return []
            }
            newSortedTasks[index] = newTask
            funcStartTime = newTask.endTime
        }
        
        let finalSortedTasks = newSortedTasks.sorted {
            return $0.priority < $1.priority
        }
        
        /*for index in newSortedTasks.indices {
            if index != 0 && newSortedTasks[index].type == .taskBreak && newSortedTasks[index - 1].type == .taskBreak {
                newSortedTasks.remove(at: index)
            }
        }*/
        
        return finalSortedTasks
    }
    
    func addTask(newTask: Task, overrideBreakLength: Bool) {
        
        //print("A:LKJASKL:J")
        newTask.type == .taskBreak ? addBreak(newBreak: newTask, overrideBreakLength: overrideBreakLength) : addNonBreakTask(newTask: newTask)
        if isSameDay(date1: newTask.date, date2: Date()) {
            scheduleNotification(task: newTask)
        }
        //saveTasks()
    }
    
    func addNonBreakTask(newTask: Task) {
        
        guard let index = index(of: newTask) else {
            if newTask.type == .taskBreak && woohooTasks[woohooTasks.count-1].type == .taskBreak {
                return
            } else {
            tasks.append(newTask)
                return
            }
        }
        //print("Difficulty: \(newTask.difficulty)")
        //print("Minutes: \(newTask.minutes)")
        tasks[index] = Task(id: tasks[index].id, title: newTask.title, date: newTask.date, type: newTask.type, manualTime: newTask.manualTime, hours: newTask.hours, minutes: newTask.minutes, difficulty: newTask.difficulty, urgency: newTask.urgency, startTime: newTask.startTime, priority: newTask.priority)
        }
    
    func addBreak(newBreak: Task, overrideBreakLength: Bool) {
        
        guard let index = otherIndex(of: newBreak, in: breaksArray) else {
            breaksArray.append(newBreak)
            return
        }
        
        breaksArray[index] = Task(id: newBreak.id, title: newBreak.title, date: newBreak.date, type: newBreak.type, hours: newBreak.hours, minutes: overrideBreakLength ? newBreak.minutes : breakLength, startTime: newBreak.startTime, priority: newBreak.priority)
        
        for task in tasks {
            addNonBreakTask(newTask: task)
        }
        
    }
    
    func removeTask(task: Task) {
        
        guard let index = index(of: task) else {
            return
        }
        
        tasks.remove(at: index)
        //saveTasks()
    }
    
    func changeStartTime(startTime: Date) {
        self.startTime = startTime
    }
    
    func changeBreakLength(breakLength: Int) {
        for task in breaksArray {
            var newBreak = task
            newBreak.minutes = breakLength
            addBreak(newBreak: newBreak, overrideBreakLength: false)
        }
    }
    
    func calculateTaskTimes(newTasks: [Task]) -> [Task] {
        print("Calculate Task Times!")
        var newHomeworkTime = homeworkTime
        var calculatedTasks = [Task]()
        
        for task in newTasks where task.manualTime == true {
            newHomeworkTime -= task.totalMinutes
            calculatedTasks.append(task)
        }
        
        var overallPoints = 0
        for task in newTasks where !task.manualTime {
            overallPoints += task.totalPoints
        }
        
        //print(overallPoints)
        
        for task in newTasks where !task.manualTime {
            var newTask = task
            //print(newTask.title)
            let timePercentage: Double = Double(newTask.totalPoints) / Double(overallPoints)
            //print(timePercentage)
            newTask.minutes = Int(timePercentage * Double(newHomeworkTime))
            print("Minutes: \(newTask.minutes)")
            calculatedTasks.append(newTask)
            //print("Checkpoint A")
        }
        
        for task in calculatedTasks {
            //print(task.title)
        }
        return calculatedTasks
    }
    
    func isSameDate(date1: Date, date2: Date) -> Bool {
        
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        
        let calendar = Calendar.current
        
        let date1Components = calendar.dateComponents([.day], from: date1)
        let date2Components = calendar.dateComponents([.day], from: date2)
        
        return date1Components.day == date2Components.day
    }
    
    func index(of task: Task) -> Int? {
        for index in tasks.indices {
            if tasks[index].id == task.id {
                return index
            }
        }
        return nil
    }
    
    func otherIndex(of task: Task, in tasks: [Task]) -> Int? {
        for index in tasks.indices {
            if tasks[index].id == task.id {
                return index
            }
        }
        return nil
    }
    //------------------Saving Data -----------------------------
    
    private var tasksFileURL: URL {
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return documentsDirectory.appendingPathComponent("taskData1")
        }
        catch {
            fatalError("An error occurred while getting the url: \(error)")
        }
    }
    
    private var startTimeFileURL: URL {
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return documentsDirectory.appendingPathComponent("startTime")
        }
        catch {
            fatalError("An error occurred while getting the url: \(error)")
        }
    }
    
    func saveTasks() {
        do {
            let encodedDataTasks = try JSONEncoder().encode(tasks)
            try encodedDataTasks.write(to: tasksFileURL)
            let encodedDataStartTime = try JSONEncoder().encode(startTime)
            try encodedDataStartTime.write(to: startTimeFileURL)
        }
        catch {
            fatalError("An error occurred while saving recipes: \(error)")
        }
    }
    
    func loadTasks() {
        guard let taskData = try? Data(contentsOf: tasksFileURL) else { return }
        guard let startTimeData = try? Data(contentsOf: startTimeFileURL) else { return }
        do {
            let savedTasks = try JSONDecoder().decode([Task].self, from: taskData)
            tasks = savedTasks
            let savedStartTime = try JSONDecoder().decode(Date.self, from: startTimeData)
            startTime = savedStartTime
        }
        catch {
            fatalError("An error occurred while loading recipes: \(error)")
        }
    }
    
    // -----------------Notification Manager---------------------
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (Sucess, Error) in
            //
        }
    }
    
    func scheduleNotifications(tasks: [Task]) {
        
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for task in tasks {
            scheduleNotification(task: task)
        }
    }
    
    func scheduleNotification(task: Task) {
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id])
        
        let index = otherIndex(of: task, in: woohooTasks)!
        
        let content = UNMutableNotificationContent()
        content.title = "\(task.title)"
        //content.subtitle =
        //content.subtitle = "This is a very awesome notification"
        content.sound = .default
        
        var dateComponents: DateComponents {
            Calendar.current.dateComponents([.hour, .minute], from: woohooTasks[index].startTime)
        }
        //print(dateComponents.hour)
        //print(dateComponents.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }

    //func removeNotifications() {
    //    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    //
   // }
}
