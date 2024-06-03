//
//  InstructionViewController.swift
//  EasyFood
//
//  Created by Nick Nguyen on 2/6/2024.
//

import UIKit

class InstructionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var instructionCollectionView: UICollectionView!
    var instructionList: [Step]?
    var selectedStep: Step?
    var selectedIndex: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.instructionCollectionView.delegate = self
        self.instructionCollectionView.dataSource = self
        self.setCollectionViewLayout(collectionView: self.instructionCollectionView, factionWidth: 1.0)
        // Do any additional setup after loading the view.
    }

    func setCollectionViewLayout(collectionView: UICollectionView, factionWidth: CGFloat) {
        let layout = UICollectionViewCompositionalLayout { (_: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(factionWidth), heightDimension: .estimated(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        collectionView.collectionViewLayout = layout
    }

    func updatinData() {
        if self.instructionList != nil {
            self.instructionCollectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.instructionCollectionView {
            return self.instructionList?.count ?? 0
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedStep = self.instructionList?[indexPath.row]
        self.selectedIndex = indexPath.row
        performSegue(withIdentifier: "toStepDetailSegue", sender: self)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.instructionCollectionView {
            let cell = self.instructionCollectionView.dequeueReusableCell(withReuseIdentifier: "instructionDetailCell", for: indexPath) as! InstructionDetailCell

            if let instructionList = self.instructionList {
                cell.setup(stepData: instructionList[indexPath.row])
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toStepDetailSegue" {
            let destination = segue.destination as! StepViewController
            destination.stepDetail = self.selectedStep
            destination.selectedStepIndex = self.selectedIndex
            destination.stepList = self.instructionList
        }
    }
}

class InstructionDetailCell: UICollectionViewCell {
    @IBOutlet var stepIndex: UILabel!

    @IBOutlet var stepDescription: UITextView!
    func setup(stepData: Step?) {
        if let temp = stepData {
            self.stepIndex.text = "Step \(temp.number):"
            self.stepDescription.text = temp.step
            self.stepDescription.isUserInteractionEnabled = false
        }
    }
}
