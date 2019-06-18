//
//  ViewController.swift
//  BouncingBall
//
//  Created by Abdul Samad on 29/05/2019.
//  Copyright © 2019 Abdul. All rights reserved.
//

import UIKit
import CoreMotion
let scrollingHeight:CGFloat = 5000.0

class ViewController: UIViewController {
    //var ball: BallView?
    var ball: BallView!

    var motionManager: CMMotionManager!
    var dynamicAnimator: UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    var collisionBehaviour: UICollisionBehavior!
    var tapGesture: UITapGestureRecognizer!
    var swipeGesture: UISwipeGestureRecognizer!
    var timer: Timer!
    var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollingHeight)


        scrollView.backgroundColor = UIColor.blue

        scrollView.setContentOffset(CGPoint(x: 0.0, y: scrollView.contentSize.height - scrollView.visibleSize.height), animated: false)
        view.addSubview(scrollView)


        let ballX =  scrollView.visibleSize.width / 2.0;
        let ballY =  scrollView.contentOffset.y + (scrollView.visibleSize.height / 2.0);
        self.ball = BallView(radius:25.0, center: CGPoint(x: ballX, y: ballY), size: CGSize(width: view.bounds.size.width/6.0 , height: view.bounds.size.width/6.0))
        scrollView.addSubview(self.ball!)


        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction = .right
        self.view.addGestureRecognizer(tapGesture)
        self.view.addGestureRecognizer(swipeGesture)


        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        gravityBehavior = UIGravityBehavior(items: [ball!])
        collisionBehaviour = UICollisionBehavior(items: [ball!])

        collisionBehaviour.translatesReferenceBoundsIntoBoundary = true

        dynamicAnimator.addBehavior(collisionBehaviour)

     //   setupMotionManager()

    }

    @objc func handleTap(tapGesture: UITapGestureRecognizer) {

        if let _ = timer {
            timer.invalidate()
        }

        let touchPoint = tapGesture.location(in: self.view)
        let difference = touchPoint.x - self.ball.frame.origin.x

        gravityBehavior.gravityDirection = CGVector(dx: 0.0, dy: -2.0)
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { [weak self]  _ in
            if let mySelf = self {

                let toMove = difference/(self?.view.bounds.size.width ?? 1.0)
                self?.gravityBehavior.gravityDirection = CGVector(dx:toMove, dy: 1.5)

                let ballLocation = mySelf.scrollView.convert(mySelf.ball.center, to: mySelf.scrollView)

                print("Ball location: \(ballLocation)")

                print("Content offset: \(mySelf.scrollView.contentOffset)")

                let visibleHeightArea = mySelf.scrollView.contentOffset.y + mySelf.scrollView.visibleSize.height
                let difference = visibleHeightArea - ballLocation.y
                let howMuchToMove = difference - (mySelf.scrollView.visibleSize.height/2.0)
                // as the scroll view 0,0 is at the top and we consider it at the bottom that why need
                // to convert this.
                let offset = (mySelf.scrollView.contentSize.height - mySelf.scrollView.contentOffset.y)

                let newPositionOrigin = mySelf.scrollView.contentSize.height - offset - howMuchToMove
                if howMuchToMove > 0.0 && newPositionOrigin >= 0.0 {
                    self?.scrollView.scrollRectToVisible(CGRect(x: 0.0, y: newPositionOrigin, width: mySelf.scrollView.bounds.size.width, height: mySelf.view.bounds.size.height), animated: true)
                     mySelf.scrollView.addSubview(mySelf.createBlocker(in: CGRect(origin: mySelf.scrollView.contentOffset, size: mySelf.scrollView.bounds.size)))
                }
            }

        })
    }

    func createBlocker(in visibleArea: CGRect) -> UIView
    {
        let view = UIView(frame: CGRect(x: 0.0, y: visibleArea.origin.y - 100.0,
                                        width: 60.0, height: 20.0))
        view.backgroundColor = UIColor.yellow
        return view
    }


    @objc func handleSwipe() {
        if(!dynamicAnimator.behaviors.contains(gravityBehavior)) {
            dynamicAnimator.addBehavior(gravityBehavior)
        }
    }
}

