//
//  ChartUIView.swift
//  EasyFood
//
//  Created by Nick Nguyen on 2/6/2024.
//

import Charts
import Foundation
import SwiftUI

enum ChartType: String, CaseIterable {
    case detail = "Detail List"
    case pieChart = " Pie Chart"
}

struct ChartUIView: View {
    var data: [Nutrition] = []
    var recipeID: Int?
    @State private var selectedSegment = 0
    var body: some View {
        if #available(iOS 17.0, *) {
            Chart(data) { d in
                SectorMark(angle: .value("Amount", d.amountInGrams()))
                    .foregroundStyle(by: .value("Name", d.name))
            }
        }
    }

    mutating func setData(nuitritionList: [Nutrition]) {
        data = nuitritionList
    }
}
