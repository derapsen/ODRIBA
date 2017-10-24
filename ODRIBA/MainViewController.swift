//
//  MainViewController.swift
//  ODRIBA
//
//  Created by AppCircle on 2017/10/21.
//  Copyright © 2017年 NichibiAppCircle. All rights reserved.
//

import UIKit


class MainViewController: UIViewController
{
    // 楽曲管理シングルトン
    var audioManager = AudioManager.sharedManager
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        // NavigationBar非表示
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
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
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
     *  昇降ボタン処理
     *
     */
    @IBAction func btnUPDOWNTapAction(_ sender: UIBarButtonItem)
    {
        var title: String = ""
        var msg: String = ""
        
        // 閉じるボタンを作成する
        let cancelAction = UIAlertAction(title: "閉じる",
                                         style: UIAlertActionStyle.cancel,
                                         handler: nil)
        
        if (audioManager.isUpColle() && !audioManager.isDownColle())
        {
            // 上りだけ設定済み
            
            title = "上りの曲のみ設定しています"
            msg = "下りの曲は再生しません。"
            
            // アラートを作成する
            let alert = UIAlertController(title: title,
                                          message: msg,
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            // アラートに閉じるボタンを追加する
            alert.addAction(cancelAction)
            
            // アラートを表示する
            self.present(alert,
                         animated: true,
                         completion: nil)
            
        }
        else if (!audioManager.isUpColle() && audioManager.isDownColle())
        {
            // 下りだけ設定済み
            
            title = "下りの曲のみ設定しています"
            msg = "上りの曲は再生しません。"
            
            // アラートを作成する
            let alert = UIAlertController(title: title,
                                          message: msg,
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            // アラートに閉じるボタンを追加する
            alert.addAction(cancelAction)
            
            // アラートを表示する
            self.present(alert,
                         animated: true,
                         completion: nil)
        }
        else if (!audioManager.isUpColle() && !audioManager.isDownColle())
        {
            // 上り下り設定していない
            
            title = "楽曲を設定していません"
            msg = "楽曲設定ボタンをタップし設定を行ってください。"
            
            // アラートを作成する
            let alert = UIAlertController(title: title,
                                          message: msg,
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            // 戻るボタンを作成する
            let backAction = UIAlertAction(title: "戻る",
                                             style: UIAlertActionStyle.cancel,
                                             handler: nil)
            
            // アラートに閉じるボタンを追加する
            alert.addAction(backAction)
            
            // アラートを表示する
            self.present(alert,
                         animated: true,
                         completion: nil)
            
            return
        }
        else
        {
            print("all setting")
            
            title = "上りと下りの曲設定済み"
            msg = "上りと下り曲どちらでも再生できます"
            
            // アラートを作成する
            let alert = UIAlertController(title: title,
                                          message: msg,
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            // アラートに閉じるボタンを追加する
            alert.addAction(cancelAction)
            
            // アラートを表示する
            self.present(alert,
                         animated: true,
                         completion: nil)
        }
        
        
        
        self.lblMessage.isHidden = false
    }
    
    /*
     *
     *  インフォボタン処理
     *
     */
    @IBAction func btnInfoTapAction(_ sender: Any)
    {
        performSegue(withIdentifier: "goCredit", sender: nil)
    }
    
}

