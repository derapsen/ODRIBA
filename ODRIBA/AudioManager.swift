//
//  AudioManager.swift
//  ODRIBA
//
//  Created by AppCircle on 2017/10/21.
//  Copyright © 2017年 NichibiAppCircle. All rights reserved.
//

import UIKit
import MediaPlayer

class AudioManager: NSObject
{
    // シングルトン
    static let sharedManager = AudioManager()
    
    var player = MPMusicPlayerController()
    
    // UserDefaults のインスタンス
    let UD = UserDefaults.standard
    
    let downMediaColleKey: String = "downColle_value"
    let downStartTimeKey: String = "downStart_value"
    let downEndTimeKey: String = "downEnd_value"
    
    let upMediaColleKey: String = "upColle_value"
    let upStartTimeKey: String = "upStart_value"
    let upEndTimeKey: String = "upEnd_value"
    
    private override init()
    {
        self.player = MPMusicPlayerController.systemMusicPlayer
        self.player.repeatMode = .one
        self.player.shuffleMode = .off
    }
    
    func isUpColle() -> Bool
    {
        if (self.UD.object(forKey: self.upMediaColleKey) != nil)
        {
            print("find up media")
            return true
        }
        print("not find up media")
        return false
    }
    
    func isDownColle() -> Bool
    {
        if (self.UD.object(forKey: self.downMediaColleKey) != nil)
        {
            print("find down media")
            return true
        }
        print("not find down media")
        return false
    }
    
    func saveUpItems(mediaColle:MPMediaItemCollection, startTime: Double, endTime: Double)
    {
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: mediaColle)
        self.UD.set(data, forKey: self.upMediaColleKey)
        self.UD.set(startTime, forKey: self.upStartTimeKey)
        self.UD.set(endTime, forKey: self.upEndTimeKey)
    }
    
    func saveDownItems(mediaColle:MPMediaItemCollection, startTime: Double, endTime: Double)
    {
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: mediaColle)
        self.UD.set(data, forKey: self.downMediaColleKey)
        self.UD.set(startTime, forKey: self.downStartTimeKey)
        self.UD.set(endTime, forKey: self.downEndTimeKey)
    }
    
    func upMusicInfo() -> MPMediaItemCollection?
    {
        var temp: MPMediaItemCollection?
        if let arc = self.UD.object(forKey: self.upMediaColleKey) as? Data
        {
            temp = NSKeyedUnarchiver.unarchiveObject(with: arc) as? MPMediaItemCollection
        }
        
        return temp
    }
    
    func downMusicInfo() -> MPMediaItemCollection?
    {
        var temp: MPMediaItemCollection?
        if let arc = self.UD.object(forKey: self.downMediaColleKey) as? Data
        {
            temp = NSKeyedUnarchiver.unarchiveObject(with: arc) as? MPMediaItemCollection
        }
        
        return temp
    }
}
