//
//  FaceView.swift
//  Happiness
//
//  Created by sbx_fc on 15/9/1.
//  Copyright (c) 2015年 SF. All rights reserved.
//

import UIKit

protocol FaceViewDataSource : class{
    func smilinessForFaceView(sender:FaceView) -> Double?
}

@IBDesignable
class FaceView: UIView {

    @IBInspectable
    var lineWidth:CGFloat = 3 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var scale:CGFloat = 0.9 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var faceCenter:CGPoint{
        return convertPoint(center,fromView:superview)
    }
    
    var faceRadius:CGFloat{
        return min(bounds.size.width, bounds.size.height)*0.5*scale
    }
    
    var color:UIColor = UIColor.blueColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    
    func scale(gesture:UIPinchGestureRecognizer){
        
        if gesture.state == .Changed
        {
            scale *= gesture.scale
            gesture.scale = 1
        }
        
    }
    
    /**
     * delegate 会被设置到 Controller
     * 而Controler本身已经持有FaceView的引用,这时就会建立起一个双向引用
     * 所以,我们需要将dataSource 设置为弱引用 weak,当Controller释放掉FaceView时,
     * FaceView就不会因为有一个强引用的指针指向Controller而无法释放掉
    */
    weak var dataSource:FaceViewDataSource?
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye { case Left, Right }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath
    {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        
        let path = UIBezierPath(
            arcCenter: eyeCenter,
            radius: eyeRadius,
            startAngle: 0,
            endAngle: CGFloat(2*M_PI),
            clockwise: true
        )
        path.lineWidth = lineWidth
        return path
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath
    {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle:CGFloat( 2*M_PI ), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        let smiliness = dataSource?.smilinessForFaceView(self) ?? 0.0
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
        
    }
    
}
