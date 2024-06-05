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
            VStack {
                Picker("View", selection: $selectedSegment) {
                    Text("Detail List").tag(0)
                    Text("Pie Chart").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                switch selectedSegment {
                case 0:
                    Text("Nutrition Detail")
                        .font(.title3)
                        .padding()
                    List(data, id: \.id) { nutrient in
                        VStack(alignment: .leading) {
                            Text(nutrient.name)
                                .font(.headline)
                            Text("Amount: \(nutrient.amount) \(nutrient.unit)")
                            Text("Percent of Daily Needs: \(nutrient.percentOfDailyNeeds)%")
                        }
                    }
                case 1:
                    Text("Nutrition Chart Per Serving Percentage in Gram:")
                        .font(.title3)
                        .padding()
                    Chart(data) { d in
                        SectorMark(angle: .value("Amount", d.amountInGrams()))
                            .foregroundStyle(by: .value("Name", d.name))
                    }
                default:
                    EmptyView()
                }
            }
        }
    }

    mutating func setData(nuitritionList: [Nutrition]) {
        data = nuitritionList
    }
}
