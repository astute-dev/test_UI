//
//  DescriptionViewController.swift
//  Astute
//
//  Created by Ulises Giacoman on 2/4/16.
//  Copyright © 2016 DeHacks. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController {
    var content: [String]!
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var eventPic: UIImageView!
    @IBOutlet weak var duration: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.date.text = content[2]
        self.course.text = content[0]
        self.eventPic.image = UIImage(named: content[3])
        self.duration.text = content[4]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
