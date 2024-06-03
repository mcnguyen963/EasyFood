//
//  NuitritionViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 2/6/2024.
//

import Charts
import SwiftUI
import UIKit

class NuitritionViewController: UIViewController {
    var recipeID: Int?
    var nuitritionData: NutritionDetail?
    var indicator = UIActivityIndicatorView()
    var chartController: UIHostingController<ChartUIView>?
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:
                view.safeAreaLayoutGuide.centerYAnchor),
        ])
        indicator.startAnimating()
        if recipeID != nil {
            Task {
                await getNuitritionData(id: recipeID ?? 0)
            }
        }
        //        Do any additional setup after loading the view.

        let controller = UIHostingController(rootView: ChartUIView())
        guard let chartView = controller.view else {
            return
        }
        view.addSubview(chartView)
        addChild(controller)
        chartView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            chartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            chartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12.0),
        ])

        chartController = controller
    }

    func getNuitritionData(id: Int) async {
        var searchURLComponents = URLComponents()
        searchURLComponents.scheme = "https"
        searchURLComponents.host = "api.spoonacular.com"
        searchURLComponents.path = "/recipes/\(String(recipeID ?? 0))/nutritionWidget.json"
        searchURLComponents.queryItems = [
            URLQueryItem(name: "apiKey", value: "baee3d6b25894651a9d3904b9fed4428"),
        ]
        guard let requestURL = searchURLComponents.url else {
            print("Invalid URL.")
            return
        }

        let urlRequest = URLRequest(url: requestURL)
        do {
            let (data, _) =
                try await URLSession.shared.data(for: urlRequest)
            indicator.stopAnimating()
            do {
                let decoder = JSONDecoder()
                let nuitTritionInfor = try decoder.decode(NutritionDetail.self, from: data)
                nuitritionData = nuitTritionInfor
                updataData()
            } catch {
                print(error)
            }

        } catch {
            print(error)
        }
    }

    func updataData() {
        var n = nuitritionData
        chartController?.rootView.setData(nuitritionList: nuitritionData?.nutrients ?? [])
    }
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */
}
