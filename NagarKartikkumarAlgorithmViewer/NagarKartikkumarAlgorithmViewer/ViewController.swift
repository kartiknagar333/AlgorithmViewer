//
//  ViewController.swift
//  NagarKartikkumarAlgorithmViewer
//
//  Created by CDMStudent on 4/8/25.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var sortbtn: UIButton!
    
    @IBOutlet weak var secondalgoView: secondAlgo!
    @IBOutlet weak var firstalgoView: firstAlgoView!
    override func viewDidLoad() {
        super.viewDidLoad()
        shuffleNumbersAndDisplay(size:16)
    }

    
    private func shuffleNumbersAndDisplay(size: Int) {
        var numbers = Array(1...size)
        numbers.shuffle()
        firstalgoView.numbers = numbers
        secondalgoView.numbers = numbers
    }

    @IBAction func chnagNSize(_ sender: Any) {
        if let segmented = sender as? UISegmentedControl {
              let selectedIndex = segmented.selectedSegmentIndex
              let title = segmented.titleForSegment(at: selectedIndex) ?? "0"
              if let size = Int(title) {
                  shuffleNumbersAndDisplay(size: size)
              }
          }
    }
    
}

