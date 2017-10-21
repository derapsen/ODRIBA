//
//  EditViewController.swift
//  ODRIBA
//
//  Created by AppCircle on 2017/10/21.
//  Copyright © 2017年 NichibiAppCircle. All rights reserved.
//

import UIKit

class EditViewController: UIViewController
{

    @IBOutlet weak var musicToolBar: UIToolbar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let item1 = UIBarButtonItem(title: "Select", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        let item2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: nil, action: nil)
        let item3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: nil, action: nil)
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let items = [item1, flexibleItem, item2, flexibleItem, item3]
        // 配列を、UIToolBarのプロパティitemsに代入
        self.musicToolBar.items = items

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}
