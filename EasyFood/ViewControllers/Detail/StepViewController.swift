//
//  StepViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 2/6/2024.
//

import UIKit

class StepViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var ingredientCollectionView: UICollectionView!

    @IBOutlet var stepIndex: UILabel!

    @IBOutlet var stepDescription: UITextView!
    @IBOutlet var equipmentCollectionView: UICollectionView!

    @IBOutlet var nextStepButton: UIBarButtonItem!
    var stepDetail: Step?
    var selectedStepIndex: Int?
    var stepList: [Step]?

    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientCollectionView.delegate = self
        ingredientCollectionView.dataSource = self

        equipmentCollectionView.delegate = self
        equipmentCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        updateData()
    }

    func updateData() {
        guard let tempIndex = selectedStepIndex else {
            return
        }
        guard let tempList = stepList else {
            return
        }
        if tempIndex > tempList.count - 2 {
            nextStepButton.isHidden = true
        }

        stepIndex.text = "Step \(tempList[tempIndex].number):"
        stepDescription.text = tempList[tempIndex].step
        stepDetail = tempList[tempIndex]
        ingredientCollectionView.reloadData()
        equipmentCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ingredientCollectionView {
            return stepDetail?.ingredients.count ?? 0
        }
        if collectionView == equipmentCollectionView {
            return stepDetail?.equipment.count ?? 0
        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ingredientCollectionView {
            let cell = ingredientCollectionView.dequeueReusableCell(withReuseIdentifier: "stepIngredientCell", for: indexPath) as! StepIngredientCell

            if let temp = stepDetail {
                cell.setup(stepData: temp.ingredients[indexPath.row])
            }
            return cell
        }
        if collectionView == equipmentCollectionView {
            let cell = equipmentCollectionView.dequeueReusableCell(withReuseIdentifier: "stepEquipmentCell", for: indexPath) as! StepEquipmentCell

            if let temp = stepDetail {
                cell.setup(stepData: temp.equipment[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }

    @IBAction func nextStepAction(_ sender: Any) {
        let temp = selectedStepIndex ?? 0
        let tempListCount = stepList?.count ?? 0
        if temp+1 <= tempListCount - 1 {
            selectedStepIndex = temp+1
            updateData()
        }
    }
}

class StepIngredientCell: UICollectionViewCell {
    @IBOutlet var imgView: UIImageView!

    @IBOutlet var nameView: UILabel!
    func setup(stepData: ShortIngredient?) {
        if let temp = stepData {
            if let imageURL = URL(string: temp.image) {
                getImage(from: imageURL)
            }
            nameView.text = stepData?.name
        }
    }

    func getImage(from url: URL) {
        let session = URLSession.shared

        let task = session.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }

            if let error = error {
                print("Error downloading image: \(error)")
                return
            }

            // Ensure there's data
            guard let imageData = data else {
                print("No image data")
                return
            }

            // Convert data to UIImage
            if let image = UIImage(data: imageData) {
                // Update UI on the main thread
                DispatchQueue.main.async {
                    // Set the downloaded image to the image view
                    self.imgView.image = image
                }
            }
        }

        // Resume the task
        task.resume()
    }
}

class StepEquipmentCell: UICollectionViewCell {
    @IBOutlet var imgView: UIImageView!

    @IBOutlet var nameView: UILabel!
    func setup(stepData: Equipment?) {
        if let temp = stepData {
            if let imageURL = URL(string: temp.image) {
                getImage(from: imageURL)
            }
            nameView.text = stepData?.name
        }
    }

    func getImage(from url: URL) {
        let session = URLSession.shared

        let task = session.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }

            if let error = error {
                print("Error downloading image: \(error)")
                return
            }

            // Ensure there's data
            guard let imageData = data else {
                print("No image data")
                return
            }

            // Convert data to UIImage
            if let image = UIImage(data: imageData) {
                // Update UI on the main thread
                DispatchQueue.main.async {
                    // Set the downloaded image to the image view
                    self.imgView.image = image
                }
            }
        }

        // Resume the task
        task.resume()
    }
}
