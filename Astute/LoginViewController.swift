//
//  LoginViewController.swift
//  Astute
//
//  Created by Ulises Giacoman on 2/4/16.
//  Copyright © 2016 DeHacks. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var usernameTextOutlet: UITextField!
    @IBOutlet weak var passTextOutlet: UITextField!
    @IBOutlet weak var confirmPassTextOutlet: UITextField!
    
    @IBOutlet weak var confirmPassIconLabel: UILabel!
    @IBOutlet weak var userIconLabel: UILabel!
    @IBOutlet weak var passIconLabel: UILabel!
    
    @IBOutlet weak var passUnderline: UIView!
    @IBOutlet weak var userUnderline: UIView!
    @IBOutlet weak var confirmPassUnderline: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var createAcctBtn: UIButton!
    
//    
//    @IBOutlet weak var createAnAccountBtn: UIButton!
    //paste
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var isRotating = false
    var shouldStopRotating = false
    var offset: CGFloat = 500
    var myString:NSString = "Don't have an account? REGISTER"
    var cancelNSString:NSString = "Cancel"
    var cancelMutableString = NSMutableAttributedString()
    var registerMutableString = NSMutableAttributedString()
    
    var startX = CGFloat()
    var startXconfirmPassTextOutlet = CGFloat()
    var startXphonelabel = CGFloat()
    var startXphoneUnderline = CGFloat()
    var endXconfirmPassTextOutlet = CGFloat()
    var endXphonelabel = CGFloat()
    var endXphoneUnderline = CGFloat()
    var keyboardUp = false
    
    var settings = Settings()
    
    override func viewDidLoad() {
        
        print("----------------------------------------------------------------------------------------")
        print("LoginViewController: Initializing LoginViewController")
        super.viewDidLoad()
        design()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        self.usernameTextOutlet.delegate = self;
        self.passTextOutlet.delegate = self;
        if self.defaults.stringForKey("lastUser") != nil {
            self.usernameTextOutlet.text = self.defaults.stringForKey("lastUser")!
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        hidePhoneLabels()
    }
    
    override func viewDidAppear(animated: Bool) {
        getPhoneLabelsLocation()
        movePhoneLabelsOffScreen(false)
        
        self.startX = self.loginBtn.frame.origin.x
        
        checkUser()
        
        usernameTextOutlet.delegate = self
        passTextOutlet.delegate = self
        self.usernameTextOutlet.nextField = self.passTextOutlet
        
    }
    
    /*
    loginButton
    -----------
    Attempts to log the user into the system
    */
    @IBAction func login(sender: AnyObject) {
        // grab username and password fields and check if they are not null
        print("LoginViewController: Attempting to login...")
        let username = usernameTextOutlet.text
        let password = passTextOutlet.text
        let phone = confirmPassTextOutlet.text
        if (username!.isEmpty) || (password!.isEmpty) {
            print("LoginViewController: Not all fields are filled.")
            jiggleLogin()
            self.displayAlert("Form Error", message: "Please make sure you have filled all fields.")
        } else {
            print("LoginViewController: Sending LOGIN network request.")
            if loginBtn.titleLabel?.text == "LOGIN" {
                if self.isRotating == false {
                    self.logo.rotate360Degrees(completionDelegate: self)

                    // Perhaps start a process which will refresh the UI...
                }
                // else try to log the user in
                Network.login(
                    username!,
                    password: password!,
                    completionHandler: {
                        success, message in
                        
                        if(!success) {
                            // can't make UI updates from background thread, so we need to dispatch
                            // them to the main thread
                            dispatch_async(dispatch_get_main_queue(), {
                                print("LoginViewController: Login failed ~ \(message)")
                                self.jiggleLogin()
                                self.displayAlert("Login Error", message: message)
                                self.shouldStopRotating = true
                                
                            })
                        }
                        else {
                            // can't make UI updates from background thread, so we need to dispatch
                            // them to the main thread
                            dispatch_async(dispatch_get_main_queue(), {
                                print("LoginViewController: Login successful, seguing towards IndexViewController.")
                                self.shouldStopRotating = true
                                self.confirmPassTextOutlet.hidden = true
                                self.confirmPassIconLabel.hidden = true
                                self.confirmPassUnderline.hidden = true
                                
                                let cookies: NSArray = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies as NSArray!
                                
                                Cookies.setCookiesWithArr(cookies)
                                
                                self.defaults.setObject("\(username!)", forKey: "lastUser")
                                self.performSegueWithIdentifier("loginRider", sender: self)
                            })
                        }
                })
            }
            else {
                print("LoginViewController: Attempting to register...")
                if (phone!.isEmpty) {
                    print("LoginViewController: Not all fields are filled.")
                    jiggleLogin()
                    self.displayAlert("Form Error", message: "Please make sure you have filled all fields.")
                } else {
                    print("LoginViewController: Sending register network request.")
                    Network.register(
                        username!,
                        password: password!,
                        phone: phone!,
                        completionHandler: {
                            success, message in
                            
                            // can't make UI updates from background thread, so we need to dispatch
                            // them to the main thread
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                // check if registration succeeds
                                if(!success) {
                                    print("LoginViewController: Registration Error ~ \(message)")
                                    self.displayAlert("Registration Error", message: message)
                                } else {
                                    // if it succeeded, log user in and change screens to
                                    print("LoginViewController: Sending LOGIN network request.")
                                    Network.login(
                                        username!,
                                        password: password!,
                                        completionHandler: {
                                            success, message in
                                            
                                            if(!success) {
                                                //can't make UI updates from background thread, so we need to dispatch
                                                // them to the main thread
                                                dispatch_async(dispatch_get_main_queue(), {
                                                    print("LoginViewController: Login failed ~ \(message)")
                                                    self.displayAlert("Login Error", message: message)
                                                })
                                            }
                                            else {
                                                //can't make UI updates from background thread, so we need to dispatch
                                                // them to the main thread
                                                dispatch_async(dispatch_get_main_queue(), {
                                                    print("LoginViewController: Login successful, seguing towards IndexViewController.")
                                                    let cookies: NSArray = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies as NSArray!
                                                    
                                                    Cookies.setCookiesWithArr(cookies)
                                                    
                                                    self.defaults.setObject("\(username!)", forKey: "lastUser")
                                                    self.performSegueWithIdentifier("loginRider", sender: self)
                                                })
                                            }
                                    })
                                }
                            })
                        }
                    )
                }
                
            }
        }
        
    }
    

    /*
    registerButton
    --------------
    Redirects user to Registration Page
    
    */
    @IBAction func registerButton(sender: AnyObject) {
        
        if createAcctBtn.titleLabel!.text == "Don't have an account? REGISTER" {
            
            print("LoginViewController: User pressed Registration button, updating UI to show phone label.")
            unHidePhoneLabels()
            movePhoneLabelsOnScreen()
            
            createAcctBtn.setAttributedTitle(self.cancelMutableString, forState: UIControlState.Normal)
            loginBtn.setTitle("REGISTER", forState: UIControlState.Normal)
            self.usernameTextOutlet.attributedPlaceholder = NSAttributedString(string:"USERNAME", attributes: [NSForegroundColorAttributeName: settings.darkBlue])
            loginBtn.backgroundColor = UIColor.whiteColor()
            loginBtn.setTitleColor(settings.darkBlue , forState: UIControlState.Normal)
        }
        else {
            print("LoginViewController: User pressed Registration button, updating UI to hide phone label.")
            movePhoneLabelsOffScreen(true)
            
            createAcctBtn.setAttributedTitle(registerMutableString, forState: UIControlState.Normal)
            loginBtn.setTitle("LOGIN", forState: UIControlState.Normal)
            
            self.usernameTextOutlet.attributedPlaceholder = NSAttributedString(string:"USERNAME", attributes: [NSForegroundColorAttributeName: settings.darkBlue])
            
            loginBtn.backgroundColor = UIColor.clearColor()
            loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        
    }
    
    
    
    /*
    design
    ------
    Implements the following styles to the username and password textboxes in the Storyboard ViewController:
    
    usernameTextOutlet: change placeholder text white
    passTextOutlet: change placeholder text white
    
    */
    func design() {
        // Colors
        self.loginBtn.layer.borderWidth = 2
        self.loginBtn.layer.borderColor = UIColor.whiteColor().CGColor
        
        // Username text box
        usernameTextOutlet.layer.masksToBounds = true
        self.usernameTextOutlet.attributedPlaceholder = NSAttributedString(string:self.usernameTextOutlet.placeholder!, attributes: [NSForegroundColorAttributeName: settings.darkBlue])
        
        // Password text box
        self.passTextOutlet.attributedPlaceholder = NSAttributedString(string:self.passTextOutlet.placeholder!, attributes: [NSForegroundColorAttributeName: settings.darkBlue])
        
        self.confirmPassTextOutlet.attributedPlaceholder = NSAttributedString(string:self.confirmPassTextOutlet.placeholder!, attributes: [NSForegroundColorAttributeName: settings.darkBlue])
        
        
        
        cancelMutableString = NSMutableAttributedString(string: cancelNSString as String, attributes: [NSFontAttributeName:UIFont(name: "Avenir Next", size: 15.0)!])
        
        registerMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Avenir Next", size: 15.0)!])
        
        registerMutableString.addAttribute(NSForegroundColorAttributeName, value: settings.darkBlue, range: NSRange(location:23,length:8))
        
//        createAnAccountBtn.setAttributedTitle(registerMutableString, forState: UIControlState.Normal)
        
    }
    
    func checkUser() {
        if isAppAlreadyLaunchedOnce() == false {
            confirmPassTextOutlet.hidden = false
            confirmPassIconLabel.hidden = false
            confirmPassUnderline.hidden = false
            
            self.confirmPassTextOutlet.frame.origin.x = self.startXconfirmPassTextOutlet
            self.confirmPassTextOutlet.frame.origin.x = self.startXconfirmPassTextOutlet
            self.confirmPassIconLabel.frame.origin.x = self.startXphonelabel
            self.confirmPassUnderline.frame.origin.x = self.startXphoneUnderline
            
            createAcctBtn.setAttributedTitle(self.cancelMutableString, forState: UIControlState.Normal)
            loginBtn.setTitle("REGISTER", forState: UIControlState.Normal)
            self.usernameTextOutlet.attributedPlaceholder = NSAttributedString(string:"USERNAME", attributes: [NSForegroundColorAttributeName: settings.darkBlue])
            print("bringing back to center")
            loginBtn.backgroundColor = UIColor.whiteColor()
            loginBtn.setTitleColor(settings.darkBlue , forState: UIControlState.Normal)
        }
    }
    
    func cookiesPresent()->Bool{
        let data: NSData? = defaults.objectForKey("sessionCookies") as? NSData
        if (data == nil){
            print("No cookies, let user log in")
            return false
        }
        else {
            return true
        }
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        if let _ = self.defaults.stringForKey("isAppAlreadyLaunchedOnce"){
            return true
        }
        else {
            defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
            print("LoginViewController: First time launching app, displaying registration screen.")
            return false
        }
    }
    
    /*
    displayAlert
    ------------
    Handles user alerts. For example, when Username or Password is required but not entered.
    
    */
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if self.shouldStopRotating == false {
                        self.logo.rotate360Degrees(completionDelegate: self)

        } else {
            self.reset()
        }
    }
    
    func reset() {
        self.isRotating = false
        self.shouldStopRotating = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let nextField = textField.nextField {
            nextField.becomeFirstResponder()
        }
        if (textField.returnKeyType==UIReturnKeyType.Go)
        {
            textField.resignFirstResponder() // Dismiss the keyboard
            loginBtn.sendActionsForControlEvents(.TouchUpInside)
        }
        return true
    }
    
    func registerForKeyboardNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeShown:",
            name: UIKeyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(self,
            selector: "keyboardWillBeHidden:",
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    func jiggleLogin() {
        UIView.animateWithDuration(
            0.1,
            animations: {
                self.loginBtn.frame.origin.x = self.startX - 10
            },
            completion: { finish in
                UIView.animateWithDuration(
                    0.1,
                    animations: {
                        self.loginBtn.frame.origin.x = self.startX + 10
                    },
                    completion: { finish in
                        UIView.animateWithDuration(
                            0.1,
                            animations: {
                                self.loginBtn.frame.origin.x = self.startX
                            }
                        )
                    }
                )
            }
        )
    }
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (!self.keyboardUp) {
            
            if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                UIView.animateWithDuration(0.5, animations: {
                                        self.logo.alpha = 0.0

                    
                })
                
                self.usernameTextOutlet.frame.origin.y -= 100
                self.userIconLabel.frame.origin.y -= 100
                self.userUnderline.frame.origin.y -= 100
                
                self.passTextOutlet.frame.origin.y -= 100
                self.passIconLabel.frame.origin.y -= 100
                self.passUnderline.frame.origin.y -= 100
                
                self.confirmPassTextOutlet.frame.origin.y -= 100
                self.confirmPassIconLabel.frame.origin.y -= 100
                self.confirmPassUnderline.frame.origin.y -= 100
                
            }
            
            self.keyboardUp = true
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardUp {
            if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.usernameTextOutlet.frame.origin.y += 100
                self.userIconLabel.frame.origin.y += 100
                self.userUnderline.frame.origin.y += 100
                
                self.passTextOutlet.frame.origin.y += 100
                self.passIconLabel.frame.origin.y += 100
                self.passUnderline.frame.origin.y += 100
                
                self.confirmPassTextOutlet.frame.origin.y += 100
                self.confirmPassIconLabel.frame.origin.y += 100
                self.confirmPassUnderline.frame.origin.y += 100
                
                
                UIView.animateWithDuration(0.5, animations: {
                self.logo.alpha = 1.0

                    
                })
                self.keyboardUp = false
            }
            
        }
    }
    
    
    func hidePhoneLabels() {
        confirmPassTextOutlet.hidden = true
                confirmPassIconLabel.hidden = true
        confirmPassUnderline.hidden = true
        
    }
    
    func unHidePhoneLabels() {
        confirmPassTextOutlet.hidden = false
        confirmPassIconLabel.hidden = false
        confirmPassUnderline.hidden = false
    }
    
    func getPhoneLabelsLocation() {
        self.startXconfirmPassTextOutlet = self.confirmPassTextOutlet.frame.origin.x
                self.startXphonelabel = self.confirmPassIconLabel.frame.origin.x
        self.startXphoneUnderline = self.confirmPassUnderline.frame.origin.x
        
    }
    
    func movePhoneLabelsOffScreen(animate: Bool) {
        if animate {
            UIView.animateWithDuration(
                0.5,
                animations: {
                    self.confirmPassTextOutlet.frame.origin.x = self.endXconfirmPassTextOutlet
                    self.confirmPassIconLabel.frame.origin.x = self.endXphonelabel
                    self.confirmPassUnderline.frame.origin.x = self.endXphoneUnderline
                },
                completion: nil
            )
            
        }
        else {
            self.confirmPassTextOutlet.frame.origin.x = startXconfirmPassTextOutlet - self.offset
                        self.confirmPassIconLabel.frame.origin.x = startXphonelabel - self.offset
            self.confirmPassUnderline.frame.origin.x = startXphoneUnderline - self.offset
            
            self.endXconfirmPassTextOutlet = self.confirmPassTextOutlet.frame.origin.x
                        self.endXphonelabel = self.confirmPassIconLabel.frame.origin.x
            self.endXphoneUnderline = self.confirmPassUnderline.frame.origin.x
            
        }
    }
    
    func movePhoneLabelsOnScreen() {
        UIView.animateWithDuration(
            0.5,
            animations: {

        
                self.confirmPassTextOutlet.frame.origin.x = self.startXconfirmPassTextOutlet
                self.confirmPassIconLabel.frame.origin.x = self.startXphonelabel
                self.confirmPassUnderline.frame.origin.x = self.startXphoneUnderline
            },
            completion: nil
        )
        
    }
    
    
}
