//
//  BallView.swift
//  BouncingBall
//
//  Created by Abdul Samad on 29/05/2019.
//  Copyright © 2019 Abdul. All rights reserved.
//

import UIKit

class BallView: UIView {

    var radius: CGFloat = 5
    var ballCenter: CGPoint

    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder not implemented")
    }

    required init(radius: CGFloat, center: CGPoint, size: CGSize) {
        self.radius = radius
        self.ballCenter = center
        super.init(frame: CGRect(origin: center, size:CGSize(width: radius*2, height: radius*2)))
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(arcCenter: CGPoint(x: radius,y: radius), radius: self.radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 2.0
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.fillColor = UIColor.green.cgColor
        self.layer.addSublayer(shapeLayer)
    }


}
