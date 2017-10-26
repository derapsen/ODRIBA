//
//  InvertedTriangleButton.swift
//  ODRIBA
//
//  Created by AppCircle on 2017/10/21.
//  Copyright © 2017年 NichibiAppCircle. All rights reserved.
//

import UIKit

class InvertedTriangleButton: TriangleButton
{
    override func createTrianglePath() -> UIBezierPath
    {
        let rect = self.frame

        return createStep(rect: rect, startX: 0, startY: 0)
    }
}
