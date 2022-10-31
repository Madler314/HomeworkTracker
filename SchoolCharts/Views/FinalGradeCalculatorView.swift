//
//  FinalGradeCalculatorView.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 7/14/22.
//

import SwiftUI

struct FinalGradeCalculatorView: View {
    
    private var viewModel = FinalGradeCalculatorViewModel()
    
    @State private var currentGrade = 89.0
    @State private var desiredGrade = 89.5
    @State private var finalWeight = 10.0
    
    var body: some View {
        VStack {
            Text("Final Grade Calculator")
                .font(.title)
                .padding()
            //Spacer()
            Form {
                Stepper(value: $currentGrade, in: 0...100, step: 0.1) {
                    HStack {
                        Text("Current Grade:    ")
                        TextField("Current Grade      ",
                                  value: $currentGrade,
                                  formatter: NumberFormatter.decimal)
                            .keyboardType(.numbersAndPunctuation)
                    }
                }
                Spacer()
                Stepper(value: $desiredGrade, in: 0...100, step: 0.1) {
                    HStack {
                        Text("Desired Grade:    ")
                        TextField("Desired Grade      ",
                                  value: $desiredGrade,
                                  formatter: NumberFormatter.decimal)
                            .keyboardType(.numbersAndPunctuation)
                    }
                }
                Spacer()
                Stepper(value: $finalWeight, in: 0...100, step: 0.1) {
                    HStack {
                        Text("Final Weight:    ")
                        TextField("Final Weight    ",
                                  value: $finalWeight,
                                  formatter: NumberFormatter.decimal)
                            .keyboardType(.numbersAndPunctuation)
                    }
                }
                Spacer()
                Text("Grade Necessary: \(String(finalGrade))")
            }
        }
    }
}

extension NumberFormatter {
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
}

extension FinalGradeCalculatorView {
    private var finalGrade: Double {
        return viewModel.finalGrade(currentGrade: currentGrade, desiredGrade: desiredGrade, finalWeight: finalWeight)
    }
}

struct FinalGradeCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        FinalGradeCalculatorView()
    }
}
