//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Lucas Franco on 3/16/16.
//  Copyright © 2016 Lucas Franco. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var heart: dragImage!
    @IBOutlet weak var food: dragImage!
    
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    
    var MusicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        heart.dropTarget = monsterImg
        food.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        startTimer()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "OnItemDroppedOnCharacter:", name: "OnTargetDropped", object: nil)
        
        
        do{
            try MusicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
        } catch let err as NSError{
            print(err.debugDescription)
        }
        
        
        MusicPlayer.prepareToPlay()
        MusicPlayer.play()
        
        sfxBite.prepareToPlay()
        sfxDeath.prepareToPlay()
        sfxHeart.prepareToPlay()
        sfxSkull.prepareToPlay()
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func OnItemDroppedOnCharacter(notif: AnyObject){
       monsterHappy = true
        startTimer()
        if currentItem == 0 {
            sfxHeart.play()
        } else if currentItem == 1{
            sfxBite.play()
        }
        food.alpha = DIM_ALPHA
        food.userInteractionEnabled = false
        
        heart.alpha = DIM_ALPHA
        heart.userInteractionEnabled = false
    }
    
    func startTimer(){
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "ChangeGameState", userInfo: nil, repeats: true)
    }
    
    func ChangeGameState(){
        
        if !monsterHappy {
        penalties++
            
            sfxSkull.play()
        
        if penalties == 1 {
        penalty1Img.alpha = OPAQUE
        penalty2Img.alpha = DIM_ALPHA
        } else if penalties == 2 {
          penalty2Img.alpha = OPAQUE
          penalty3Img.alpha = DIM_ALPHA
        }       else if penalties >= 3 {
                penalty3Img.alpha = OPAQUE
            
        }           else {
                    penalty1Img.alpha = DIM_ALPHA
                    penalty2Img.alpha = DIM_ALPHA
                    penalty3Img.alpha = DIM_ALPHA
        }
        if penalties >= MAX_PENALTIES {
            gameOver()
            
        }
        }
        
        let rand = arc4random_uniform(2)
        if rand == 0{
            food.alpha = DIM_ALPHA
            food.userInteractionEnabled = false
           
            heart.alpha = OPAQUE
            heart.userInteractionEnabled = true
        } else if rand == 1{
            heart.alpha = DIM_ALPHA
            heart.userInteractionEnabled = false
            
            food.alpha = OPAQUE
            food.userInteractionEnabled = true
        }
        currentItem = rand
        monsterHappy = false
        
        
    }
    func gameOver(){
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
    }
    }

