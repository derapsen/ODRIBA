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
        performSegue(withIdentifier: "goEdit", sender: "UP")
    }
    
    /*
     *
     *  DOWNボタン処理
     *
     */
    @IBAction func btnDownAction(_ sender: Any)
    {
        performSegue(withIdentifier: "goEdit", sender: "DOWN")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // EditViewControllerのインスタンス
        let editVC = segue.destination as! EditViewController
        
        if (segue.identifier == "goEdit")
        {
            if (sender as? String == "UP")
            {
                editVC.navTitle = "編集画面：UP"
                editVC.colorBackground = self.UIColorFromRGB(rgbValue: 0xFFA000)
            }
            else
            {
                editVC.navTitle = "編集画面：DOWN"
                editVC.colorBackground = self.UIColorFromRGB(rgbValue: 0x00B8FA)
            }
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
    

}

