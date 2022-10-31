//
//  CustomDatePicker.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 7/23/22.
//

import SwiftUI

struct CustomDatePicker: View {

    @EnvironmentObject var viewModel: TaskViewModel
    @Binding var currentDate: Date
    
    // Month update on arrow button clicks...
    @State var currentMonth: Int = 0
    
    @State var tasksExist: Bool = false
    
    var calendarTasks: [Task] {
        viewModel.tasks
    }
    
    var body: some View {
        
        //VStack(spacing: 35) {
        ScrollView() {
            
            let days: [String] =
                ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
            HStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 30) {
                    
                    Text(dateStrings()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(dateStrings()[1])
                        .font(.title)
                        .bold()
                        .padding(.bottom, 45)
                }
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            //Dates...
            //Lazy Grid...
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 15) {
                
                ForEach(extractDate()) { value in
                    
                    CardView(value: value)
                        .background(
                            Capsule()
                                .fill(Color(.systemPink))
                                .opacity(viewModel.isSameDate(date1: value.date, date2: currentDate) ? 1 : 0)
                        )
                        .onTapGesture {
                            currentDate = value.date
                        }
                    
                }
            }
            
            VStack(spacing: 15) {
            //ScrollView {
                
                Text("Tasks")
                    .font(.title2)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 10)
                
                ForEach(calendarTasks) { task in
                    if viewModel.isSameDate(date1: task.date, date2: currentDate) {
                        VStack(alignment: .leading, spacing: 10) {
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
                }
                if !calendarTasks.contains(where: { task in
                                    return viewModel.isSameDate(date1: task.date, date2: currentDate)} ) {
                    Text("No Task Found")
                }
            }
            .padding()
            //.padding(.top, 10)
            .frame(maxHeight: .infinity)
        }
        .onChange(of: currentMonth) { newValue in
            
            // updating Month
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        
        VStack {
            
            if value.day != -1 {
                
                if let task = calendarTasks.first(where: { task in
                    
                    return viewModel.isSameDate(date1: task.date, date2: value.date)
                }) {
                    Text("\(value.day)")
                        .font(.title3)
                        .bold()
                        .foregroundColor(viewModel.isSameDate(date1: task.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .fill(viewModel.isSameDate(date1: task.date, date2: currentDate) ? .white : Color(.systemPink))
                        .frame(width: 8, height: 8)
                }
                else {
                    
                    Text("\(value.day)")
                        .font(.title3)
                        .bold()
                        .foregroundColor(viewModel.isSameDate(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
        }
        .padding(.vertical,8)
        .frame(height: 60, alignment: .top)
    }
    
    // checking dates...

    
    // extracting Year and Month for display
    func dateStrings() -> [String] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ") // What is this components kind of a function?
    }
    
    func getCurrentMonth() -> Date {
        
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() ->[DateValue] {
        
        let calendar = Calendar.current
        
        //Getting Current Month Date
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            
            // getting day
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        // adding offset days to get exact week day
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 1..<firstWeekday {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

extension CustomDatePicker {
    
    func binding(for task: Task) -> Binding<Task> {
        guard let index = viewModel.index(of: task) else {
            fatalError("Recipe Not Found")
        }
        return $viewModel.tasks[index]
    }
    
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

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHome()
    }
}

// Extending Date to get Current Month Dates
extension Date {
    
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        // getting start Date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        //range.removeLast()
        
        // Getting date
        return range.compactMap { day -> Date in
                
            return calendar.date(byAdding: .day, value: day == 1 ? 0 : day-1, to: startDate)!
        }
    }
}
