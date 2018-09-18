//
//  ViewController.swift
//  CircularProgressAnimation
//
//  Created by Karthik on 12/09/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var shapeLayer: CAShapeLayer?
    var trackLayer: CAShapeLayer?
    var pulseLayer: CAShapeLayer?
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        return gesture
    }()
    
    
    private func createShapeLayer(fillColor: UIColor, strokeColor: UIColor) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeEnd = 1
        
        shapeLayer.lineWidth = 20
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        
        shapeLayer.position = view.center
        
        return shapeLayer
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "Circular Animation"
        
        setupViews()
        
        setupNotificationObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        
        view.addGestureRecognizer(tapGestureRecognizer)
        
        shapeLayer = createShapeLayer(fillColor: UIColor.clear, strokeColor: UIColor.darkGray)
        trackLayer = createShapeLayer(fillColor: UIColor.lightGray, strokeColor: UIColor.white)
        pulseLayer = createShapeLayer(fillColor: UIColor.lightGray, strokeColor: UIColor.clear)
        
        view.layer.addSublayer(pulseLayer!)
        view.layer.addSublayer(trackLayer!)
        view.layer.addSublayer(shapeLayer!)
        
//        pulseLayer?.opacity = 0.5
        
        animatePulse()
        animateCircle()
    }
    
    func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleForeground), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func handleForeground() {
        animatePulse()
        animateCircle()
    }
    
    fileprivate func animatePulse() {
        let basicAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        basicAnimation.fromValue = 1
        basicAnimation.toValue = 1.5
        basicAnimation.duration = 0.8
        basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        basicAnimation.repeatCount = Float.greatestFiniteMagnitude
//        basicAnimation.autoreverses = true
        
        pulseLayer!.add(basicAnimation, forKey: "pulse")
        
        let colorAnimation = CABasicAnimation(keyPath: "fillColor")
        
        colorAnimation.duration = 0.8
        colorAnimation.fromValue = UIColor.lightGray.cgColor
        colorAnimation.toValue = UIColor.white.cgColor
        colorAnimation.repeatCount = Float.greatestFiniteMagnitude
        colorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        colorAnimation.autoreverses = true
        
        pulseLayer?.add(colorAnimation, forKey: "color")
    }

    fileprivate func animateCircle() {
        // animate stroke
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 0.95
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.repeatCount = Float.greatestFiniteMagnitude
        basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        basicAnimation.autoreverses = true
        
        shapeLayer!.add(basicAnimation, forKey: "anim")
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = CGFloat.pi * 2
        rotateAnimation.duration = 5
        rotateAnimation.repeatCount = Float.greatestFiniteMagnitude
        rotateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
//        rotateAnimation.autoreverses = true
        
        shapeLayer!.add(rotateAnimation, forKey: "rotateAnim")
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        shapeLayer!.strokeEnd = 0
    }

}

