import UIKit

class secondAlgo: UIView {
    
    var numbers: [Int]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }

        guard let numbers = numbers, numbers.count >= 6 else { return }
        let size: CGFloat = CGFloat(numbers.count)
        let space: CGFloat = CGFloat(3)
        let boxHeight = bounds.height / size  //one height for bar
        let barWidth = (bounds.width - ((size+1) * space)) / size //Get fix size for all bars
        var spacewidth = space + (barWidth / 2)   //Get fix space size between all bars
        
        for i in 0..<numbers.count {
            let barheight = boxHeight * CGFloat(Int(size) - numbers[i])
            context.setLineWidth(barWidth)
            context.setStrokeColor(UIColor.orange.cgColor)
            context.move(to: CGPoint(x: spacewidth, y: bounds.height))
            context.addLine(to: CGPoint(x: spacewidth, y: barheight))
            context.strokePath()
            spacewidth = spacewidth + space + barWidth
        }
    }
}
