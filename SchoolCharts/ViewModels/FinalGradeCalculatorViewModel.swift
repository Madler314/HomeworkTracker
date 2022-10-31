//
//  FinalGradeCalculatorViewModel.swift
//  SchoolCharts
//
//  Created by Matthew Adler on 7/14/22.
//

import SwiftUI

struct FinalGradeCalculatorViewModel {
    
    //@State var currentGrade: Double
    //@State var desiredGrade: Double
    //@State var finalWeight: Double
    
    func finalGrade(currentGrade: Double, desiredGrade: Double, finalWeight: Double) -> Double {
        return round(((desiredGrade - (100-finalWeight) * (currentGrade/100)) / finalWeight)*100)
    }
    
    /*init(currentGrade: Double, desiredGrade: Double, finalWeight: Double) {
        self.currentGrade = currentGrade
        self.desiredGrade = desiredGrade
        self.finalWeight = finalWeight
    }*/
}
