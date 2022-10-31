//
//  CalendarHome.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 7/23/22.
//

import SwiftUI

struct CalendarHome: View {
    
    @EnvironmentObject var viewModel: TaskViewModel
    
    @State var currentDate: Date = Date()
    
    @State private var isPresenting: Bool = false
    
    @State var newTask = Task()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) { // What is showIndicators?
                
                VStack(spacing: 20) { // Experiment with spacing
                    
                    CustomDatePicker(currentDate: $currentDate)
                        .environmentObject(viewModel)
                }
                .padding(.vertical)
            }
            .navigationTitle("")
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
                    Fredrica(task: newTask, isDailyView: false)
                        .toolbar(content: {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isPresenting = false
                                }
                            }
                            //ToolbarItem(placement: .confirmationAction) {
                            //        Button("Save") {
                            //            isPresenting = false
                            //            viewModel.addTask(newTask: newTask)
                            //        }
                            //    }
                            })
                        .navigationTitle("Add a New Event")
                }
            })
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        CalendarHome()
    }
}
