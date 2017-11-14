//
//  DetailViewController.swift
//  My_Notes
//
//  Created by Nitin Panchal on 2017-10-31.
//  Copyright © 2017 Sweta panchal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var detailDescriptionTextView: UITextView!


    func configureView() {
        // Update the user interface for the detail item.
        
        if objects.count == 0 {
            return
        }
            if let label = detailDescriptionTextView {
                label.text = objects[currentIndex]
                if label.text == blank_note {
                    label.text = ""
                }
            }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        detailViewController = self
        detailDescriptionTextView.becomeFirstResponder()
        detailDescriptionTextView.delegate = self
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView() 
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if objects.count == 0{
            return
        }
        objects[currentIndex] = detailDescriptionTextView.text
        if detailDescriptionTextView.text == "" {
            
             objects[currentIndex] = blank_note
        }
        saveAndUpdate()
        
    }
    
    func saveAndUpdate()
    {
        masterView?.save()
        masterView?.tableView.reloadData()
    }

    func textViewDidChange(_ textView: UITextView) {
        objects[currentIndex] = detailDescriptionTextView.text
        saveAndUpdate()
    }

}

