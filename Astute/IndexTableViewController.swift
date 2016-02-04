//
//  IndexTableViewController.swift
//  Astute
//
//  Created by Ulises Giacoman on 2/4/16.
//  Copyright © 2016 DeHacks. All rights reserved.
//

import UIKit

class IndexTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //var users = Array<String>()
    var tv = UITableView()
    var courses:[String] = []
    var numStudents:[String] = []
    var event_date:[String] = []
    var image_name:[String] = []
    var duration:[String] = []
    var edescription:[String] = []
    
    var INFO:[String] = ["","","","","","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = Settings()
        courses = ["CSCI 476", "HIST 212", "CSCI 476", "HIST 212","CSCI 476", "HIST 212","CSCI 476", "HIST 212","HIST 212","HIST 212","HIST 212","HIST 212","HIST 212","HIST 212"]
        
        numStudents = ["8","2","21", "3","8","8","2","21", "3","8","8","2","21", "3"]
        
        event_date = ["1/1","1/1","12/1","12/1","12/1","12/1","1/1","12/1","12/1","12/1","12/1","12/1","12/1","12/1"]
        
        image_name = ["image1.jpg","image2.jpg","image3.jpg","image4.jpg","image5.jpg","image6.jpg","image3.jpg","image4.jpg","image5.jpg","image6.jpg","image3.jpg","image4.jpg","image5.jpg","image6.jpg"]
        
        duration = ["2", "1.5","2", "1.5","2", "1.5","2", "1.5","2", "1.5","2", "1.5","2", "1.5" ]
        
        edescription = ["This is a description"]
        
        
        self.view.backgroundColor = settings.lightBlue
        
        let title = UILabel(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width, height: 125))
        title.text = "Events"
        title.textAlignment = .Center
        title.font = UIFont(name: "Avenir", size: 28)
        title.textColor = UIColor.whiteColor()
        self.view.addSubview(title)

        
        
        tv = UITableView(frame: CGRect(x: 40, y: 100, width: self.view.frame.size.width-80, height: self.view.frame.size.height-240))
        tv.delegate = self

        tv.dataSource = self
        tv.backgroundColor = UIColor.clearColor()
        tv.separatorStyle = .None
        tv.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
        self.view.addSubview(tv)
        
        
        
        
        //        let hralertLabel = UILabel(frame: CGRect(x: 40,y: self.view.frame.size.height/2-50, width: self.view.frame.size.width/2 ,height: 32))
        //        hralertLabel.text = "heartrate alerts?"
        //        hralertLabel.textAlignment = .Left
        //        hralertLabel.font = UIFont(name: "UbuntuTitling-Bold", size: 18)
        //        hralertLabel.textColor = UIColor.whiteColor()
        //        self.view.addSubview(hralertLabel)
        //
        //        let hralertSlider = UISwitch()
        //        hralertSlider.frame = CGRect(x: self.view.frame.size.width-91, y: self.view.frame.size.height/2-50, width: 51, height: 31)
        //        hralertSlider.tintColor = UIColor.whiteColor()
        //        hralertSlider.addTarget(self, action: "hralertSlider:", forControlEvents: .ValueChanged)
        //        self.view.addSubview(hralertSlider)
        //
        //
        //        let cryalertLabel = UILabel(frame: CGRect(x: 40,y: self.view.frame.size.height/2, width: self.view.frame.size.width/2 ,height: 32))
        //        cryalertLabel.text = "crying alerts?"
        //        cryalertLabel.textAlignment = .Left
        //        cryalertLabel.font = UIFont(name: "UbuntuTitling-Bold", size: 18)
        //        cryalertLabel.textColor = UIColor.whiteColor()
        //        self.view.addSubview(cryalertLabel)
        //
        //        let cryalertSlider = UISwitch()
        //        cryalertSlider.frame = CGRect(x: self.view.frame.size.width-91, y: self.view.frame.size.height/2, width: 51, height: 31)
        //        cryalertSlider.tintColor = UIColor.whiteColor()
        //        cryalertSlider.addTarget(self, action: "cryalertSlider:", forControlEvents: .ValueChanged)
        //        self.view.addSubview(cryalertSlider)
        
//        let continueBtn = UIButton(frame: CGRect(x: self.view.frame.size.width/2-50, y: self.view.frame.size.height-100, width: 100, height: 60))
//        continueBtn.setTitle("send", forState: .Normal)
//        continueBtn.titleLabel?.font = UIFont(name: "UbuntuTitling-Bold", size: 24)
//        continueBtn.addTarget(self, action: "continueBtn", forControlEvents: .TouchUpInside)
//        continueBtn.layer.cornerRadius = 10
//        continueBtn.layer.borderWidth = 2
//        continueBtn.layer.borderColor = UIColor.whiteColor().CGColor
//        self.view.addSubview(continueBtn)
        // Do any additional setup after loading the view.
    }
    
    func continueBtn() {
        //        var usersToSend:[String] = []
        //        for i in 0...users.count - 1 {
        //            if((tv.cellForRowAtIndexPath(NSIndexPath(index: i))!.accessoryType == .Checkmark)) {
        //                usersToSend.append(users[i])
        //            }
        //        }
        //        var usersToSend = [users[0]]
        //        print("sending video to: \(usersToSend)")
        //        Network.sendVideo(usersToSend) { (success, message, heartRate) -> Void in
        //            if(success) {
        //                print("fuck yeah")
        //            } else {
        //                print("fuck me, fuck life")
        //            }
        //        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(1) * NSEC_PER_SEC)), dispatch_get_main_queue(), {()
            self.navigationController?.popViewControllerAnimated(true)
        });
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func updateTable(username: [String]) {
        courses = username
        numStudents = username
        
        self.tv.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.clearColor()
        cell.accessoryType = .None
        cell.tintColor = UIColor.whiteColor()
        cell.selectionStyle = .None

        
        let courseName = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width-80, height: 62))
        courseName.font = UIFont(name: "UbuntuTitling-Bold", size: 16)
        courseName.textColor = UIColor.whiteColor()
        courseName.textAlignment = .Right
        courseName.frame.origin.y += 10
        courseName.text = courses[indexPath.item] //import users
        //label.backgroundColor = UIColor.redColor()
        cell.addSubview(courseName)
        
        let number = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width-80, height: 62))
        number.font = UIFont(name: "UbuntuTitling-Bold", size: 16)
        number.textColor = UIColor.whiteColor()
        number.frame.origin.y += -25
        number.textAlignment = .Right
        number.text = numStudents[indexPath.item] //import users
        //label.backgroundColor = UIColor.redColor()
        cell.addSubview(number)
        
        let date = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width-80, height: 62))
        date.font = UIFont(name: "UbuntuTitling-Bold", size: 16)
        date.textColor = UIColor.whiteColor()
        //date.textAlignment = da
        date.frame.origin.x += 150
        date.frame.origin.y += 10
        date.text = event_date[indexPath.item] //import users
        cell.addSubview(date)
        
        
        let image = UIImage(named: image_name[indexPath.item])
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        imageView.frame.origin.y -= 10
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        cell.addSubview(imageView)
        
        let sep = UIView(frame: CGRect(x: 0, y: 59, width: cell.frame.size.width, height: 1))
        sep.backgroundColor = UIColor.whiteColor()
        cell.addSubview(sep)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .Checkmark;
        //this is where we capture data and segue
//        var tv = UITableView()
//        var courses:[String] = []
//        var numStudents:[String] = []
//        var event_date:[String] = []
//        var image_name:[String] = []
//        var duration:[String] = []

        self.INFO = [courses[indexPath.item],
                numStudents[indexPath.item],
                event_date[indexPath.item],
                image_name[indexPath.item],
                duration[indexPath.item],
                edescription[indexPath.item]]
        
        print(self.INFO)
        self.performSegueWithIdentifier("descriptionSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "descriptionSegue") {
            
            let tripInfo = segue.destinationViewController as! DescriptionViewController;
            
            tripInfo.content = self.INFO
        }
    }

    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)!.accessoryType = .None;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (courses.count)
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
