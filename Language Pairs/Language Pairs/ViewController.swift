//
//  ViewController.swift
//  Language Pairs
//
//  Created by Jesse Ruiz on 8/30/20.
//  Copyright © 2020 Jesse Ruiz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var language: UISegmentedControl!
    @IBOutlet var words: UISegmentedControl!
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? GameViewController else { return }
        
        vc.targetLanguage = language.titleForSegment(at: language.selectedSegmentIndex)!.lowercased()
        vc.wordType = words.titleForSegment(at: words.selectedSegmentIndex)!.lowercased()
    }

}

