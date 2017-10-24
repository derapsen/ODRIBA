//
//  MainViewController.swift
//  ODRIBA
//
//  Created by AppCircle on 2017/10/21.
//  Copyright © 2017年 NichibiAppCircle. All rights reserved.
//

import UIKit
import CoreMotion

class MainViewController: UIViewController
{
    // 楽曲管理シングルトン
    var audioManager = AudioManager.sharedManager
    
    var before_altitude: Double = 0
    var now_altitude: Double = 0
    var isUp: Bool = false
    var isDown: Bool = false
    
    // 昇降計測用タイマー
    var measure_timer: Timer?
    
    // 待機時間カウント用変数
    var wait_count: Int = 0
    var isWait: Bool = true
    
    let altimeter = CMAltimeter()
    
    // 再生状況判断用タイマー
    var musicEndCheck_timer: Timer?
    
    // 再生範囲用変数
    var musicStartTime: TimeInterval = 0
    var musicEndTime: TimeInterval = 0
    
    // 中央のメッセージラベル
    @IBOutlet weak var lblMessage: UILabel!
    
    // UP・DOWNのボタンとメッセージラベル
    @IBOutlet weak var btnDOWN: InvertedTriangleButton!
    @IBOutlet weak var btnUP: TriangleButton!
    @IBOutlet weak var lblDOWNMessage: UILabel!
    @IBOutlet weak var lblUPMessage: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.Setting()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // NavigationBar非表示
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if (self.measure_timer != nil)
        {
            self.measure_timer?.invalidate()
            self.musicEndCheck_timer?.invalidate()
            self.Setting()
        }
        
        if (self.audioManager.isUpColle())
        {
            self.btnUP.backgroundColor = self.UIColorFromRGB(rgbValue: 0xFFA000)
            let upMusicColle = audioManager.upMusicInfo()
            self.lblUPMessage.text = upMusicColle.items.first?.title
        }
        else
        {
            self.btnUP.backgroundColor = UIColor.lightGray
            self.lblUPMessage.text = "このエリアをタップして音楽を選択してください"
        }
        
        if (self.audioManager.isDownColle())
        {
            self.btnDOWN.backgroundColor = self.UIColorFromRGB(rgbValue: 0x00B8FA)
            let downMusicColle = audioManager.downMusicInfo()
            self.lblDOWNMessage.text = downMusicColle.items.first?.title
        }
        else
        {
            self.btnDOWN.backgroundColor = UIColor.lightGray
            self.lblDOWNMessage.text = "このエリアをタップして音楽を選択してください"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        // NavigationBar表示
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if (self.measure_timer != nil)
        {
            self.measure_timer?.invalidate()
            self.musicEndCheck_timer?.invalidate()
            self.Setting()
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        // 上り下りの両方あれば計測開始
        if (self.audioManager.isUpColle() && self.audioManager.isDownColle())
        {
            self.btnUP.isEnabled = false
            self.btnDOWN.isEnabled = false
            self.lblMessage.isHidden = false
            self.startUpdate()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    /*
     *
     *  計測処理
     *
     */
    func startUpdate()
    {
        if (CMAltimeter.isRelativeAltitudeAvailable())
        {
            self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler:
                {data, error in
                    if error == nil
                    {
                        self.now_altitude = data?.relativeAltitude as! Double
                        
                        if (!(self.measure_timer?.isValid)!)
                        {
                            self.before_altitude = self.now_altitude
                            self.measure_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.UpDownCheck), userInfo: nil, repeats: true)
                        }
                    }
            })
        }
        else
        {
            print("not use altimeter")
        }
    }
    
    /*
     *
     *  上りか下りかの検出
     *
     */
    @objc func UpDownCheck()
    {
        if (self.now_altitude == 0)
        {
            self.wait_count = 0
            self.before_altitude = self.now_altitude
            return
        }
        
        if (self.now_altitude > self.before_altitude + 0.025)
        {
            self.wait_count = 0
            self.isUp = true
            self.isDown = false
            
            // 追加分
            self.musicSettingChange()

            self.before_altitude = self.now_altitude
        }
        else if (self.now_altitude < self.before_altitude - 0.025)
        {
            self.wait_count = 0
            self.isUp = false
            self.isDown = true
            
            // 追加分
            self.musicSettingChange()
            
            self.before_altitude = self.now_altitude
        }
        else
        {
            self.wait_count += 1
            self.isUp = false
            self.isDown = false
            
            if (wait_count >= 5)
            {
                // 曲を止める
                self.audioManager.player.pause()
                self.audioManager.player.currentPlaybackTime = 0
                
                self.measure_timer?.invalidate()
                self.musicEndCheck_timer?.invalidate()
                self.Setting()
            }
        }
    }
    
    /*
     *
     *  流す曲選択処理
     *
     */
    func musicSettingChange()
    {
        if (!(measure_timer?.isValid)!)
        {
            if (self.isUp)
            {
                print("up music setting")
                
                self.audioManager.player.setQueue(with: self.audioManager.upMusicInfo())
                
                self.musicStartTime = self.audioManager.UD.object(forKey: self.audioManager.upStartTimeKey) as! TimeInterval
                self.musicEndTime = self.audioManager.UD.object(forKey: self.audioManager.upEndTimeKey) as! TimeInterval
            }
            if (self.isDown)
            {
                print("down music setting")
                
                self.audioManager.player.setQueue(with: self.audioManager.downMusicInfo())
                
                self.musicStartTime = self.audioManager.UD.object(forKey: self.audioManager.downStartTimeKey) as! TimeInterval
                self.musicEndTime = self.audioManager.UD.object(forKey: self.audioManager.downEndTimeKey) as! TimeInterval
            }
            self.audioManager.player.currentPlaybackTime = self.musicStartTime
            self.audioManager.player.play()
            
            self.musicEndCheck_timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.musicEndPointCheck), userInfo: nil, repeats: true)
        }
    }
    
    /*
     *
     *  再生状況判断処理
     *
     */
    @objc func musicEndPointCheck()
    {
        // 再生範囲上限値まで流れたら再生位置を再生範囲下限値に
        if (self.audioManager.player.currentPlaybackTime >= self.musicEndTime)
        {
            self.audioManager.player.currentPlaybackTime = self.musicStartTime
        }
    }
    
    /*
     *
     *  初期化処理
     *
     */
    func Setting()
    {
        self.isUp = false
        self.isDown = false
        self.btnUP.isEnabled = true
        self.btnDOWN.isEnabled = true
        self.lblMessage.isHidden = true
        self.before_altitude = 0
        self.now_altitude = 0
        self.wait_count = 0
        self.altimeter.stopRelativeAltitudeUpdates()
        self.measure_timer?.invalidate()
        self.musicEndCheck_timer?.invalidate()
    }
    
    /*
     *
     *  UPボタン処理
     *
     */
    @IBAction func btnUpAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "goEdit", sender: "UP")
    }
    
    /*
     *
     *  DOWNボタン処理
     *
     */
    @IBAction func btnDownAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "goEdit", sender: "DOWN")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "goEdit")
        {
            // EditViewControllerのインスタンス
            let editVC = segue.destination as! EditViewController
            
            if (sender as? String == "UP")
            {
                editVC.navTitle = "編集画面：UP"
                editVC.colorBackground = self.UIColorFromRGB(rgbValue: 0xFFA000)
                editVC.updownFlag = 1
                editVC.isColle = self.audioManager.isUpColle()
            }
            else
            {
                editVC.navTitle = "編集画面：DOWN"
                editVC.colorBackground = self.UIColorFromRGB(rgbValue: 0x00B8FA)
                editVC.updownFlag = 2
                editVC.isColle = self.audioManager.isDownColle()
            }
        }
        else if (segue.identifier == "goCredit")
        {
            // CreditViewControllerのインスタンス
            let creditVC = segue.destination as! CreditViewController
            creditVC.navTitle = "クレジット"
        }
        else
        {
            print("segue error")
        }
    }
    
    /*
     *
     *  UIColorHEX処理
     *
     */
    func UIColorFromRGB(rgbValue: UInt) -> UIColor
    {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /*
     *
     *  インフォボタン処理
     *
     */
    @IBAction func btnInfoTapAction(_ sender: Any)
    {
        self.performSegue(withIdentifier: "goCredit", sender: nil)
    }
}

