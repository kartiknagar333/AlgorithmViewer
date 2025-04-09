//
//  ViewController.swift
//  NagarKartikkumarAlgorithmViewer
//
//  Created by CDMStudent on 4/8/25.
//

import UIKit

class ViewController: UIViewController {
    enum ViewState {
        case stopped
        case running
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "background",
                                                             qos: .background)
    
    private var queue1: DispatchQueue = DispatchQueue(label: "queue-1",
                                                      qos: .background)
    private var queue2: DispatchQueue = DispatchQueue(label: "queue-2",
                                                      qos: .background)
    
    var array1: [Int] = []
    var array2: [Int] = []
    var TopSortindex: Int = 1
    var BottomSortindex: Int = 1
    private var timer: Timer?
    
    var state: ViewState = .stopped {
        didSet {
            self.handle(state)
        }
    }
    
    @IBOutlet weak var sortbtn: UIButton!
    
    @IBOutlet weak var bottomSortSegment: UISegmentedControl!
    @IBOutlet weak var TopSortSegment: UISegmentedControl!
    @IBOutlet weak var NSegment: UISegmentedControl!
    @IBOutlet weak var secondalgoView: secondAlgo!  //TopUIView to top bars of sort method
    @IBOutlet weak var firstalgoView: firstAlgoView! //BottomUIView to bottom bars of sort method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initial Array Size
        shuffleNumbersAndDisplay(size:16)
    }
    
    private func handle(_ newState: ViewState) {
        switch newState {
        case .stopped:
            self.NSegment.isEnabled = true
            self.TopSortSegment.isEnabled = true
            self.bottomSortSegment.isEnabled = true
            self.sortbtn.isEnabled = true
            self.timer?.invalidate()
            self.timer = nil
            
        case .running:
            self.NSegment.isEnabled = false
            self.TopSortSegment.isEnabled = false
            self.bottomSortSegment.isEnabled = false
            self.sortbtn.isEnabled = false
            
            self.dispatchQueue.async {
                let group = DispatchGroup()
                
                group.enter()
                self.queue1.async {
                    switch self.TopSortindex{
                    case 1:
                        self.insertionSort(&self.array1, isTopView: true)
                    case 2:
                        self.selectionSort(&self.array1, isTopView: true)
                    case 3:
                        self.quickSort(&self.array1, low: 0, high: (self.array1.count - 1) , isTopView: true)
                    case 4:
                        self.mergeSort(&self.array1, isTopView: true)
                    default:
                        break
                    }
                    group.leave()
                }
                
                group.enter()
                self.queue2.async {
                    switch self.BottomSortindex{
                    case 1:
                        self.insertionSort(&self.array2, isTopView: false)
                    case 2:
                        self.selectionSort(&self.array2, isTopView: false)
                    case 3:
                        self.quickSort(&self.array2, low: 0, high: (self.array2.count - 1) , isTopView: false)
                    case 4:
                        self.mergeSort(&self.array2, isTopView: false)
                    default:
                        break
                    }
                    group.leave()
                }
                
                group.wait()
                
                DispatchQueue.main.async {
                    self.state = .stopped
                }
            }
        }
    }
    
    @IBAction func TopSortBtn(_ sender: Any) {
        switch self.state {
        case .stopped:
            self.state = .running
        case .running:
            self.state = .stopped
        }
    }
    
    private func shuffleNumbersAndDisplay(size: Int) {
        //Assigning array size to AlgoView class, so it makes 2d bars on View
        var numbers = Array(1...size)
        numbers.shuffle()  // Randomize the array order
        array1 = numbers
        array2 = numbers
        firstalgoView.numbers = array1
        secondalgoView.numbers = array2
    }
    
    @IBAction func chnagNSize(_ sender: Any) {
        // Get & assigning array size when user changes N sige segment
        if let segmented = sender as? UISegmentedControl {
            let selectedIndex = segmented.selectedSegmentIndex
            let title = segmented.titleForSegment(at: selectedIndex) ?? "16"
            if let size = Int(title) {
                shuffleNumbersAndDisplay(size: size)
            }
        }
    }
    
    @IBAction func ChangeTopSort(_ sender: Any) {
        if let segmented = sender as? UISegmentedControl {
            let selectedIndex: Int = segmented.selectedSegmentIndex
            switch selectedIndex{
            case 0:
                TopSortindex = 1
            case 1:
                TopSortindex = 2
            case 2:
                TopSortindex = 3
            case 3:
                TopSortindex = 4
            default:
                break
            }
        }
    }
    
    @IBAction func ChnageBottomSort(_ sender: Any) {
        if let segmented = sender as? UISegmentedControl {
            let selectedIndex: Int = segmented.selectedSegmentIndex
            switch selectedIndex {
            case 0:
                BottomSortindex = 1
            case 1:
                BottomSortindex = 2
            case 2:
                BottomSortindex = 3
            case 3:
                BottomSortindex = 4
            default:
                break
            }
        }
    }
    
    func insertionSort(_ a: inout [Int], isTopView: Bool) {
        for i in 0 ..< a.count {
            var j = i
            while j > 0 && a[j-1] > a[j] {
                a.swapAt(j-1, j)
                j -= 1
                if isTopView{
                    Thread.sleep(forTimeInterval: 0.1)
                    DispatchQueue.main.async {
                        self.firstalgoView.numbers = self.array1
                    }
                }else{
                    Thread.sleep(forTimeInterval: 0.2)
                    DispatchQueue.main.async {
                        self.secondalgoView.numbers = self.array2
                    }
                }
            }
        }
    }
    
    
    func selectionSort(_ a: inout [Int], isTopView: Bool) {
        for i in 0..<a.count {
            var minIndex = i
            for j in (i+1)..<a.count {
                if a[j] < a[minIndex] {
                    minIndex = j
                }
            }
            if i != minIndex {
                a.swapAt(i, minIndex)
                if isTopView {
                    Thread.sleep(forTimeInterval: 0.1)
                    DispatchQueue.main.async {
                        self.firstalgoView.numbers = self.array1
                    }
                } else {
                    Thread.sleep(forTimeInterval: 0.2)
                    DispatchQueue.main.async {
                        self.secondalgoView.numbers = self.array2
                    }
                }
            }
        }
    }
    
    
    func quickSort(_ a: inout [Int], low: Int, high: Int, isTopView: Bool) {
         if low < high {
             let p = partition(&a, low: low, high: high, isTopView: isTopView)
             quickSort(&a, low: low, high: p - 1, isTopView: isTopView)
             quickSort(&a, low: p + 1, high: high, isTopView: isTopView)
         }
     }
     
     func partition(_ a: inout [Int], low: Int, high: Int, isTopView: Bool) -> Int {
         let pivot = a[high]
         var i = low
         for j in low..<high {
             if a[j] < pivot {
                 a.swapAt(i, j)
                 if isTopView {
                     Thread.sleep(forTimeInterval: 0.1)
                     DispatchQueue.main.async {
                         self.firstalgoView.numbers = self.array1
                     }
                 } else {
                     Thread.sleep(forTimeInterval: 0.2)
                     DispatchQueue.main.async {
                         self.secondalgoView.numbers = self.array2
                     }
                 }
                 i += 1
             }
         }
         a.swapAt(i, high)
         if isTopView {
             Thread.sleep(forTimeInterval: 0.1)
             DispatchQueue.main.async {
                 self.firstalgoView.numbers = self.array1
             }
         } else {
             Thread.sleep(forTimeInterval: 0.2)
             DispatchQueue.main.async {
                 self.secondalgoView.numbers = self.array2
             }
         }
         return i
     }
    
    
    
    func mergeSort(_ a: inout [Int], isTopView: Bool) {
        mergeSortHelper(&a, low: 0, high: a.count - 1, isTopView: isTopView)
    }
    
    func mergeSortHelper(_ a: inout [Int], low: Int, high: Int, isTopView: Bool) {
        if low < high {
            let mid = (low + high) / 2
            mergeSortHelper(&a, low: low, high: mid, isTopView: isTopView)
            mergeSortHelper(&a, low: mid + 1, high: high, isTopView: isTopView)
            merge(&a, low: low, mid: mid, high: high, isTopView: isTopView)
        }
    }
    
    func merge(_ a: inout [Int], low: Int, mid: Int, high: Int, isTopView: Bool) {
            var left = Array(a[low...mid])
            var right = Array(a[(mid+1)...high])
            var index = low
            
            while !left.isEmpty && !right.isEmpty {
                if left.first! <= right.first! {
                    a[index] = left.removeFirst()
                } else {
                    a[index] = right.removeFirst()
                }
                index += 1
                if isTopView {
                    Thread.sleep(forTimeInterval: 0.1)
                    DispatchQueue.main.async {
                        self.firstalgoView.numbers = self.array1
                    }
                } else {
                    Thread.sleep(forTimeInterval: 0.2)
                    DispatchQueue.main.async {
                        self.secondalgoView.numbers = self.array2
                    }
                }
            }
            
            while !left.isEmpty {
                a[index] = left.removeFirst()
                index += 1
                if isTopView {
                    Thread.sleep(forTimeInterval: 0.1)
                    DispatchQueue.main.async {
                        self.firstalgoView.numbers = self.array1
                    }
                } else {
                    Thread.sleep(forTimeInterval: 0.2)
                    DispatchQueue.main.async {
                        self.secondalgoView.numbers = self.array2
                    }
                }
            }
            while !right.isEmpty {
                a[index] = right.removeFirst()
                index += 1
                if isTopView {
                    Thread.sleep(forTimeInterval: 0.1)
                    DispatchQueue.main.async {
                        self.firstalgoView.numbers = self.array1
                    }
                } else {
                    Thread.sleep(forTimeInterval: 0.2)
                    DispatchQueue.main.async {
                        self.secondalgoView.numbers = self.array2
                    }
                }
            }
        }
}

