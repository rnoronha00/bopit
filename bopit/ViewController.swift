//
//  ViewController.swift
//  bopit
//
//  Created by Roshan Noronha on 2016-03-07.
//  Copyright © 2016 Roshan Noronha. All rights reserved.
//
//lastest version
import UIKit

class ViewController: UIViewController {
    
    //images for each action
    @IBOutlet weak var pressIt: UIImageView!
    @IBOutlet weak var tapIt: UIImageView!
    @IBOutlet weak var pinchIt: UIImageView!
    @IBOutlet weak var swipeIt: UIImageView!
    
    //gestures
    var tapGesture: UITapGestureRecognizer!
    var swipeGesture: UISwipeGestureRecognizer!
    var pinchGesture: UIPinchGestureRecognizer!
    var pressGesture: UILongPressGestureRecognizer!
    
    //stores the images and their gestures
    var actionData = [String: UIImageView]()
    
    //current level of the game
    var currentLevel: Int!
    //the current level visible on the game screen
    @IBOutlet var levelDescription: UILabel!
    
    //stores the actions for every level in the game
    var levelActionData = [Int: [String]]()
    //stores the actions for the current level
    var visibleActions: [String]!
    var visibleActionCount: Int!
    
    //the initial time to complete the first level
    //add one to the time
    var levelTimeCount = 31
    //amount of time needed to complete the current level
    var currentLevelTimeCount: Int!
    
    //the pause before the current level starts
    var levelTimer: NSTimer!
    //the length of the pause before the current level starts
    var displayTime: Int!
    //the timer visible on the game screen
    @IBOutlet weak var levelTimeViewer: UILabel!
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        
        callInitilizers()
        createLevels()
    }
    
    //calls all the initializer functions
    func callInitilizers() {
        currentLevel = 0
        
        visibleActionCount = 0
        currentLevelTimeCount = levelTimeCount
        displayTime = 3
        
        initImages()
        initGestureRecognizer()
        initDict()
    }

    //initializers
    func initImages() {
        
        tapIt.hidden = true
        swipeIt.hidden = true
        pinchIt.hidden = true
        pressIt.hidden = true
    }
    func initGestureRecognizer() {
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: "setHidden")
        swipeIt.addGestureRecognizer(swipeGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: "setHidden")
        tapIt.addGestureRecognizer(tapGesture)
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: "checkPinchState")
        pinchIt.addGestureRecognizer(pinchGesture)
        
        pressGesture = UILongPressGestureRecognizer(target: self, action: "checkPressState")
        pressGesture.minimumPressDuration = 1.5
        pressIt.addGestureRecognizer(pressGesture)
    }
    
    func checkPressState() {
        
        if (pressIt.gestureRecognizers![0].state == UIGestureRecognizerState.Began) {
            
            setHidden()
        }
    }
    
    func checkPinchState() {
        
        if (pinchIt.gestureRecognizers![0].state == UIGestureRecognizerState.Ended) {
            
            setHidden()
        }
    }
    
    func initDict() {
        
        actionData["tap"] = tapIt
        actionData["swipe"] = swipeIt
        actionData["pinch"] = pinchIt
        actionData["press"] = pressIt
    }

    //creates the levels
    func createLevels() {
        
        levelActionData[0] = ["tap", "press", "tap", "swipe", "press", "pinch", "tap", "pinch"]
        levelActionData[1] = ["tap", "press", "pinch", "tap", "pinch", "press", "swipe", "tap"]
        levelActionData[2] = ["swipe", "swipe", "tap", "pinch", "tap", "press", "tap", "swipe"]
        levelActionData[3] = ["pinch", "press", "pinch", "tap", "swipe", "press", "tap", "pinch"]
        
        startLevel(currentLevel)
    }
    
    //starts each level
    //if user has completed all levels segues to win view controller
    func startLevel(sender: Int){
        
        if (sender == levelActionData.count) {
            
            self.performSegueWithIdentifier("WinSegue", sender: nil)
        }
        
        else {
        
            visibleActions = levelActionData[sender]
            levelDescription.text = "Level \(currentLevel + 1)"
            
            var displayTimer = NSTimer(timeInterval: NSTimeInterval(displayTime), target: self, selector: "startTimer", userInfo: nil, repeats: false)
            NSRunLoop.currentRunLoop().addTimer(displayTimer, forMode: NSRunLoopCommonModes)
        }
    }
    //starts the timer for each level
    func startTimer() {
        
        currentLevelTimeCount = levelTimeCount
        levelTimer = NSTimer(timeInterval: NSTimeInterval(1.0), target: self, selector: "updateLevelTimerCount", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(levelTimer, forMode: NSRunLoopCommonModes)
        setVisible()
    }
    
    //setVisible and setHidden make each action on evert level alternate between hidden/not hidden
    func setVisible() {
        
        if (visibleActionCount == visibleActions.count) {
 
            levelDescription.text = "Level \(currentLevel + 1) Complete"
            levelTimer.invalidate()
            var tempTimer = NSTimer(timeInterval: NSTimeInterval(displayTime), target: self, selector: "updateCounters", userInfo: nil, repeats: false)
            NSRunLoop.currentRunLoop().addTimer(tempTimer, forMode: NSRunLoopCommonModes)
        }
        
        else {
            
            var newImage = actionData[visibleActions[visibleActionCount]]
            newImage?.hidden = false
            newImage?.userInteractionEnabled = true
        }
    }
    func setHidden() {
        
        var currentImage = actionData[visibleActions[visibleActionCount]]
        currentImage?.hidden = true
        visibleActionCount = visibleActionCount + 1
        setVisible()
    }

    //updates the counters needed to go to the next level and then goes to the next level
    func updateCounters() {
        
        currentLevel = currentLevel + 1
        visibleActionCount = 0
        levelTimeCount = levelTimeCount - 5
        levelTimeViewer.text = ""
        
        startLevel(currentLevel)
    }
    
    //checks that the amount of time needed to complete each level is not over
    //if time is over then segues to lose view controller
    func updateLevelTimerCount() {
        
        func checkZero() {
            
            if currentLevelTimeCount <= 1 {
                
                self.performSegueWithIdentifier("LoseSegue", sender: nil)
            }
        }
        
        checkZero()
        currentLevelTimeCount = currentLevelTimeCount - 1
        levelTimeViewer.text = "\(currentLevelTimeCount)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

