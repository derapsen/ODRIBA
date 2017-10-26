//
//  TriangleButton.swift
//  ODRIBA
//
//  Created by AppCircle on 2017/10/21.
//  Copyright © 2017年 NichibiAppCircle. All rights reserved.
//

import UIKit

class TriangleButton: UIButton
{
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        drawTriangle()
    }
    
    private func drawTriangle()
    {
        let path = createTrianglePath()
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        self.layer.masksToBounds = true
        self.layer.mask = mask
        
        let borderShape = CAShapeLayer()
        borderShape.path = path.cgPath
        borderShape.lineWidth = 7.0
        borderShape.strokeColor = UIColor.white.cgColor
        borderShape.fillColor = UIColor.clear.cgColor
        self.layer.insertSublayer(borderShape, at: 0)
    }
    
    func createTrianglePath() -> UIBezierPath
    {
        let rect = self.frame
        
        return self.createStep(rect: rect, startX: rect.width, startY: rect.height)
    }
    
    func createStep(rect: CGRect, startX: CGFloat, startY: CGFloat) -> UIBezierPath
    {
        let step = 4
        let path = UIBezierPath()
        let centerleftX = rect.width*0.35
        let centerrightX = rect.width*0.65
        let centerY = rect.height/2
        let width = (rect.width - centerrightX)/CGFloat(step)
        let height = (rect.height - centerY)/CGFloat(step)
        
        path.move(to: CGPoint(x:startX, y:startY))
        
        for count in 0..<step
        {
            let pointX = rect.width - (width * CGFloat(count))
            let pointY = height * CGFloat(count)
            path.addLine(to: CGPoint(x:pointX, y:pointY))
            path.addLine(to: CGPoint(x:pointX, y:pointY + height))
        }
        
        for count in 0..<step
        {
            let pointX = centerleftX - (width * CGFloat(count+1))
            let pointY = centerY + height * CGFloat(count)
            path.addLine(to: CGPoint(x:pointX, y:pointY))
            path.addLine(to: CGPoint(x:pointX, y:pointY + height))
        }
        
        path.addLine(to: CGPoint(x:0, y:rect.height))
        
        path.close()
        
        return path
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
    {
        if !createTrianglePath().contains(point)
        {
            // タッチ領域外
            return nil
        }
        else
        {
            return super.hitTest(point, with: event)
        }
    }
    
}
