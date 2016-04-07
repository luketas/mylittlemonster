//
//  dragimage.swift
//  mylittlemonster
//
//  Created by Lucas Franco on 3/16/16.
//  Copyright © 2016 Lucas Franco. All rights reserved.
//

import Foundation
import UIKit

class dragImage: UIImageView{
    
    var originalposition: CGPoint!
    var dropTarget: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder:  NSCoder){
        super.init(coder: aDecoder)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        originalposition = self.center
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            let position = touch.locationInView(self.superview)
            self.center = CGPointMake(position.x , position.y)
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first, let target = dropTarget{
            
            let position = touch.locationInView(self.superview)
            
            if CGRectContainsPoint(target.frame , position){
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "OnTargetDropped", object: nil))
            }
        }
        
        
        
        
        self.center = originalposition
    }



}