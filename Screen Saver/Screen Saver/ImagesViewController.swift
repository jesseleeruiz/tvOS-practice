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
    var category: String = ""
    var appID = "A6DumcjiudECz6RcugrLXh9Y-aJ_izqL8qn6jUGHmr8"

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
