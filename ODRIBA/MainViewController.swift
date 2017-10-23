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
    
    // UIToolBarのボタン
    @IBOutlet weak var btnUPDOWN: UIBarButtonItem!
    @IBOutlet weak var btnInfo: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // ToolBarのボタンにイメージを設定
        self.btnInfo.image = UIImage(named: "information")
        self.btnUPDOWN.image = UIImage(named: "standing")
        
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
        // 楽曲設定情報がない場合のアラートを作成する
        let alert = UIAlertController(title: "楽曲を選択してください",
                                      message: "楽曲編集画面に移動します",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        // 閉じるボタンを作成する
        let cancelAction = UIAlertAction(title: "閉じる",
                                         style: UIAlertActionStyle.cancel,
                                         handler:
            {
                (action:UIAlertAction) -> Void in
                
                self.performSegue(withIdentifier: "goEdit", sender: "UP")
            }
        )
        
        // アラートに閉じるボタンを追加する
        alert.addAction(cancelAction)
        
        // アラートを表示する
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    
    /*
     *
     *  DOWNボタン処理
     *
     */
    @IBAction func btnDownAction(_ sender: Any)
    {
        // 楽曲設定情報がない場合のアラートを作成する
        let alert = UIAlertController(title: "楽曲を選択してください",
                                      message: "楽曲編集画面に移動します",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        // 閉じるボタンを作成する
        let cancelAction = UIAlertAction(title: "閉じる",
                                         style: UIAlertActionStyle.cancel,
                                         handler:
            {
                (action:UIAlertAction) -> Void in
                
                self.performSegue(withIdentifier: "goEdit", sender: "DOWN")
            }
        )
        
        // アラートに閉じるボタンを追加する
        alert.addAction(cancelAction)
        
        // アラートを表示する
        self.present(alert,
                     animated: true,
                     completion: nil)
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
        self.lblMessage.isHidden = false
        self.btnUPDOWN.image = UIImage(named: "stairs")
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

