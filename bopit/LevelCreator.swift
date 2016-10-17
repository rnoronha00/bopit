//
//  LevelCreator.swift
//  bopit
//
//  Created by Roshan Noronha on 2016-03-08.
//  Copyright © 2016 Roshan Noronha. All rights reserved.
//

import Foundation
import UIKit

class LevelCreator: NSObject {
    
    struct LevelNumber {
        
        static var levelCount = 0
        
        static func increaseAndStore() -> Int {
            
            return ++levelCount
        }
    }
    
    var timer: NSTimer!
    var level = LevelNumber.increaseAndStore()
    var storeActions: [String: [[String: AnyObject]]]!
    var visibleActions: [String]!
    var actionCount: Int!
    
    
    init(inout sender: [String: [[String: AnyObject]]]) {
        
        super.init()
        timer = NSTimer(timeInterval: 5.0, target: self, selector: "printNo", userInfo: nil, repeats: false)
        actionCount = 0
        storeActions = sender
    }
    
    func setActions(sender: String...) {
        
        visibleActions = sender
    }
    
    func run() {
        print("running \(level)")
        makeVisible()
    }
    
    func makeVisible() {
        
        if (actionCount == visibleActions.count) {
            
            print("done")
        }
        
        else {
            print("visible")
            
            var image: UIImageView!
            var gesture: UIGestureRecognizer!
            
            for data in storeActions[visibleActions[actionCount]]! {
                
                for key in data.keys {
                    
                    if key == "image" {
                        
                        image = data[key] as! UIImageView
                    }
                    
                    if key == "gesture" {
                        
                        gesture = data[key] as! UIGestureRecognizer
                    }
                }
            }
            
            gesture = UIGestureRecognizer(target: self, action: "makeHidden")
            image.addGestureRecognizer(gesture)
            image.userInteractionEnabled = true
            image.hidden = false
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        }
    }
    
    func printNo() {
        
        print("nope")
    }
    
    func makeHidden() {
        
        print("hideen")
        
        //        var image: UIImageView!
        //
        //        for data in storeActions[visibleActions[actionCount]]! {
        //
        //            for key in data.keys {
        //
        //                if key == "image" {
        //
        //                    image = data[key] as! UIImageView
        //                }
        //            }
        //        }
        //
        //        image.hidden = true
        //        actionCount = actionCount + 1
        //        makeVisible()
    }

    func getGesture(sender: UIGestureRecognizer, img: UIImageView) {
        print("gesturefind")

        switch sender {
            
        case (sender as! UITapGestureRecognizer):
            print("tap gesture")
            img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "makeHidden"))
        case (sender as! UISwipeGestureRecognizer):
            print("swipe gesture")
            img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "makeHidden"))
        default:
            print("error")
        }
    }
}



    


