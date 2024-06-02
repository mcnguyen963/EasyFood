//
//  ChartUIView.swift
//  EasyFood
//
//  Created by Nick Nguyen on 2/6/2024.
//

import Charts
import Foundation
import SwiftUI

struct ChartUIView: View {
    var data: [Nutrition] = []
    var body: some View {
        Chart {
            SectorMark
        }
    }
}
