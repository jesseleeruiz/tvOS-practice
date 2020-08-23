//
//  ViewController.swift
//  Focus Technique
//
//  Created by Jesse Ruiz on 8/22/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var textfield: UITextField!
    @IBOutlet var textFieldTrip: UILabel!
    @IBOutlet var nextButton: UIButton!
    
    // MARK: - Properties
    var focusGuide: UIFocusGuide!
    
    // Change the start Focus Guide to somewhere else
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [textfield]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the Focus Guide
        focusGuide = UIFocusGuide()
        view.addLayoutGuide(focusGuide)
        
        // Place the Focus Guide via Anchors
        focusGuide.topAnchor.constraint(equalTo: textfield.bottomAnchor).isActive = true
        focusGuide.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        focusGuide.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        focusGuide.preferredFocusEnvironments = [nextButton]
    }
    
    // MARK: - Actions
    @IBAction func showAlert(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Hello", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    // MARK: - Methods
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        // If the user is moving towards the text field
        if context.nextFocusedView == textfield {
            // Tell the focus guide to redirect to the next button
            focusGuide.preferredFocusEnvironments = [nextButton]
        } else if context.nextFocusedView == nextButton {
            // Otherwise tell the focus guide to redirect to the text field
            focusGuide.preferredFocusEnvironments = [textfield]
        }
    }
    

}

