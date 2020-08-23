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
        
        // Will keep our preferred focus view we set up in the overriding var
        restoresFocusAfterTransition = false
    }
    
    // MARK: - Actions
    @IBAction func showAlert(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Hello", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
    }
    
    // MARK: - Methods
    // The coordinator will ensure the animations you give it are timed perfectly with the system's own focus animations.
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
        
        if context.nextFocusedView == textfield {
            // We're moving to the text field - animate the tip label
            coordinator.addCoordinatedAnimations({
                self.textfield.alpha = 1
            })
        } else if context.previouslyFocusedView == textfield {
            // We're moving away from the text field - animate out the tip label
            coordinator.addCoordinatedAnimations({
                self.textFieldTrip.alpha = 0
            })
        }
    }
}
