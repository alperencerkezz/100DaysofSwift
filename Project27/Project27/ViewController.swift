//
//  ViewController.swift
//  Project27
//
//  Created by Alperen Çerkez on 5.01.2025.
//

import UIKit 

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawRectangle()
    }
    
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 6 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerBoard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawStar()
        default:
            break
        }
    }
    
    // MARK: - Draw Rectangle
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    // MARK: - Draw Circle
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 5, y: 5, width: 512, height: 512).insetBy(dx: 10, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    // MARK: - Draw Checkerboard
    func drawCheckerBoard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col).isMultiple(of: 2) {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    // MARK: - Draw Rotated Squares
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    // MARK: - Draw Lines
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = image
    }
    
    func drawStar() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let center = CGPoint(x: 256, y: 256)
            let pointsOnStar = 5
            let starExtrusion: CGFloat = 100
            
            let angle = (2.0 * .pi) / CGFloat(pointsOnStar)
            let halfAngle = angle / 2.0
            
            let path = UIBezierPath()
            
            for i in 0..<pointsOnStar {
                let angle = CGFloat(i) * angle - .pi / 2
                let point = CGPoint(
                    x: center.x + cos(angle) * starExtrusion,
                    y: center.y + sin(angle) * starExtrusion
                )
                
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
                
                let midAngle = angle + halfAngle
                let midPoint = CGPoint(
                    x: center.x + cos(midAngle) * (starExtrusion / 2),
                    y: center.y + sin(midAngle) * (starExtrusion / 2)
                )
                
                path.addLine(to: midPoint)
            }
            
            path.close()
            
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.setLineWidth(5)
            
            ctx.cgContext.addPath(path.cgPath)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawTWIN() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let context = ctx.cgContext
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(5)
            
            // Draw 'T'
            context.move(to: CGPoint(x: 50, y: 100))
            context.addLine(to: CGPoint(x: 150, y: 100))
            context.move(to: CGPoint(x: 100, y: 100))
            context.addLine(to: CGPoint(x: 100, y: 200))
            
            // Draw 'W'
            context.move(to: CGPoint(x: 200, y: 100))
            context.addLine(to: CGPoint(x: 225, y: 200))
            context.addLine(to: CGPoint(x: 250, y: 150))
            context.addLine(to: CGPoint(x: 275, y: 200))
            context.addLine(to: CGPoint(x: 300, y: 100))
            
            // Draw 'I'
            context.move(to: CGPoint(x: 350, y: 100))
            context.addLine(to: CGPoint(x: 350, y: 200))
            
            // Draw 'N'
            context.move(to: CGPoint(x: 400, y: 200))
            context.addLine(to: CGPoint(x: 400, y: 100))
            context.addLine(to: CGPoint(x: 450, y: 200))
            context.addLine(to: CGPoint(x: 450, y: 100))
            
            context.strokePath()
        }
        
        imageView.image = image
    }
}
