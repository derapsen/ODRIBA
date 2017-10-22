//
//  CreditViewController.swift
//  ODRIBA
//
//  Created by AppCircle on 2017/10/22.
//  Copyright © 2017年 NichibiAppCircle. All rights reserved.
//

import UIKit

class CreditViewController: UIViewController
{
    // 受け取る用のインスタンス変数
    var navTitle: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = self.navTitle
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}
