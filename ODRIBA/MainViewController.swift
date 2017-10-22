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
        performSegue(withIdentifier: "goEdit_UP", sender: nil)
    }
    
    /*
     *
     *  DOWNボタン処理
     *
     */
    @IBAction func btnDownAction(_ sender: Any)
    {
        performSegue(withIdentifier: "goEdit_DOWN", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // EditViewControllerのインスタンス
        let editVC = segue.destination as! EditViewController
        
        if (segue.identifier == "goEdit_UP")
        {
            editVC.navItems.title = "編集画面：UP"
        }
        else if (segue.identifier == "goEdit_DOWN")
        {
            editVC.navItems.title = "編集画面：DOWN"
        }
        else
        {
            print("segue error")
        }
    }
    

}

