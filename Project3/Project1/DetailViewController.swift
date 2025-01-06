//
//  DetailViewController.swift
//  Project1
//
//  Created by TwoStraws on 12/08/2016.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    var position: (position: Int, total: Int)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedImage = selectedImage else {
            print("No image provided")
            return
        }
        guard let position = position else {
            print("No position provided")
            return
        }
        
        title = selectedImage + " - \(position.position)/\(position.total)"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        imageView.image = UIImage(named: selectedImage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image else {
            print("No image found")
            return
        }
        
        // Render the image with the text overlay
        let renderedImage = renderImageWithText(image: image, text: "From Storm Viewer")
        
        // Share the final rendered image
        let vc = UIActivityViewController(activityItems: [renderedImage], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func renderImageWithText(image: UIImage, text: String) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let renderedImage = renderer.image { ctx in
            // Draw the original image
            image.draw(in: CGRect(origin: .zero, size: image.size))
            
            // Define text attributes
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: image.size.width * 0.05, weight: .bold),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle,
                .backgroundColor: UIColor.black.withAlphaComponent(0.6)
            ]
            
            let textHeight = image.size.height * 0.1
            let textRect = CGRect(
                x: 0,
                y: image.size.height - textHeight,
                width: image.size.width,
                height: textHeight
            )
            
            // Draw the text in the specified rectangle
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            attributedString.draw(in: textRect)
        }
        
        return renderedImage
    }
    
}
