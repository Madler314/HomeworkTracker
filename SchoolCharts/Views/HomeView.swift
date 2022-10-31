//
//  ContentView.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 7/14/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: TaskViewModel
    
    @State var isPresenting: Bool = false
    @State var isChecked: Bool = false
    
    var body: some View {
        NavigationView {
                List {
                    Spacer()
                    NavigationLink(
                        destination: EditDailyTasks(tasks: tasks),
                        label: {
                            Text("Edit Schedule")
                        })
                    Spacer()
                    ForEach(tasks) { task in
                        if viewModel.isSameDay(date1: task.date, date2: Date()) {
                            HStack {
                                NavigationLink(
                                    destination: Fredrica(task: task, isDailyView: true),
                                    label: {
                                        HStack {
                                            Text(task.title)
                                            Spacer()
                                            Text(task.startTime, style: .time)
                                            Spacer()
                                            Text(task.type.rawValue)
                                            Spacer()
                                        }
                                    })
                            }
                        }
                    }
                    .listRowBackground(AppColor.background)
                    .foregroundColor(AppColor.foreground)
                    Spacer()
                }
                .onAppear {
                    viewModel.requestAuthorization()
                    viewModel.scheduleNotifications(tasks: tasks)
                }
                .navigationTitle("Today's Tasks")
                .navigationBarHidden(false)
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isPresenting = true
                        }, label: {
                            Image(systemName: "plus")
                        })
                    }
                })
                .sheet(isPresented: $isPresenting, content: {
                    NavigationView {
                        let newTask = Task()
                        Fredrica(task: newTask, isDailyView: true)
                            .toolbar(content: {
                               // ToolbarItem(placement: .cancellationAction) {
                               //     Button("Cancel") {
                                //        isPresenting = false
                               //     }
                               // }
                            })
                            .navigationTitle("Add a New Event")
                    }
                })
        }
    }
}

extension HomeView {
    
    private var listy: [String] {
        viewModel.listy
    }
    
    var tasks: [Task] {
        //viewModel.woohooTasks
        viewModel.woohooTasks
    }

}

struct SchoolChartsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TaskViewModel())
    }
}
