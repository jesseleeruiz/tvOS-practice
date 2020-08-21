//
//  ImagesViewController.swift
//  Screen Saver
//
//  Created by Jesse Ruiz on 8/21/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var creditLabel: UILabel!
    
    // MARK: - Properties
    var category = ""
    var appID = "Sv8YNEGO2Yy1gf20irPS2jBUbBxUQcjuULOfXbTJfTU"
    var imageViews = [UIImageView]()
    var images = [JSON]()
    var imageCounter = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Goes over every component in the current UI and creates a new array containing those components (which are Image Views)
        imageViews = view.subviews.compactMap { $0 as? UIImageView }
        imageViews.forEach { $0.alpha = 0 }
        creditLabel.layer.cornerRadius = 15
        
        guard let url = URL(string: "https://api.unsplash.com/search/photos?client_id=\(appID)&query=\(category)&per_page=100") else { return }
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetch(url)
        }
    }
    
    // MARK: - Methods
    func fetch(_ url: URL) {
        if let data = try? Data(contentsOf: url) {
            let json = JSON(data)
            images = json["results"].arrayValue
            downloadImage()
        }
    }
    
    func downloadImage() {
        // Figure out what image to display
        let currentImage = images[imageCounter % images.count]
        
        // Find its image URL and user credit
        let imageName = currentImage["urls"]["full"].stringValue
        let imageCredit = currentImage["user"]["name"].stringValue
        
        // Add 1 to imageCounter so next time we load the following image
        imageCounter += 1
        
        // Convert it to a Swift URL and download it
        guard let imageURL = URL(string: imageName) else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        
        // Convert the Data to a UIImage
        guard let image = UIImage(data: imageData) else { return }
        
        // Push our work to the main thread
        DispatchQueue.main.async {
            self.show(image, credit: imageCredit)
        }
    }
    
    func show(_ image: UIImage, credit: String) {
        // Stop the AI animation
        spinner.stopAnimating()
        
        // Figure out which image view to activate and deactivate
        let imageViewToUse = imageViews[imageCounter % imageViews.count]
        let otherImageView = imageViews[(imageCounter + 1) % imageViews.count]
        
        // Start an animation over two seconds
        UIView.animate(withDuration: 2.0, animations: {
            imageViewToUse.image = image
            imageViewToUse.alpha = 1
            
            // Fade out the credit label to avoid it looking wrong
            self.creditLabel.alpha = 0
            
            // Move the deactivated image view to the back, behind the activated one
            self.view.sendSubviewToBack(otherImageView)
        }) { _ in
            self.creditLabel.text = "  \(credit.uppercased())"
            self.creditLabel.alpha = 1
            
            otherImageView.alpha = 0
            otherImageView.transform = .identity
            
            UIView.animate(withDuration: 10.0, animations: {
                imageViewToUse.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                DispatchQueue.global(qos: .userInteractive).async {
                    self.downloadImage()
                }
            }
        }
    }
}
