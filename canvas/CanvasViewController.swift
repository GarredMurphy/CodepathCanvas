//
//  CanvasViewController.swift
//  canvas
//
//  Created by LinuxPlus on 10/22/18.
//  Copyright © 2018 LinuxPlus. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    
    let trayDownOffset: CGFloat! = 180
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var isUp: Bool!
    
    @IBOutlet weak var arrow: UIImageView!
    
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        var velocity = sender.velocity(in: view)
        if (sender.state == .began){
            trayOriginalCenter = trayView.center
        }
        if (sender.state == .changed){
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
        if (sender.state == .ended){
            
            if (velocity.y > 0)
            {
                UIView.animate(withDuration:0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
                
                arrow.transform = CGAffineTransform(rotationAngle: 135)
                
            } else {
                UIView.animate(withDuration:0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                }, completion: nil)
                
                arrow.transform = CGAffineTransform(rotationAngle: 0)
                
            }
        }
    }
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if (sender.state == .began){
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.transform = newlyCreatedFace.transform.scaledBy(x: 1.25, y: 1.25)
            newlyCreatedFace.isUserInteractionEnabled = true
            
            let gesture1 = UIPanGestureRecognizer(target: self, action: #selector(didPanImageView))
            newlyCreatedFace.addGestureRecognizer(gesture1)
            let gesture2 = UIPinchGestureRecognizer(target: self, action: #selector(didPinchImageView))
            newlyCreatedFace.addGestureRecognizer(gesture2)
            gesture2.delegate = self
            let gesture3 = UIRotationGestureRecognizer(target: self, action: #selector(didRotateImageView))
            newlyCreatedFace.addGestureRecognizer(gesture3)
            let gesture4 = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapImageView))
            gesture4.numberOfTapsRequired = 2
            newlyCreatedFace.addGestureRecognizer(gesture4)
        }
        if (sender.state == .changed){
           newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
        if (sender.state == .ended){
           newlyCreatedFace.transform = newlyCreatedFace.transform.scaledBy(x: 0.80, y: 0.80)
        }
        
    }
    
    @objc func didPanImageView(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)
        if sender.state == .began{
            newlyCreatedFace = sender.view as? UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.transform = newlyCreatedFace.transform.scaledBy(x: 1.25, y: 1.25)
        }
        if sender.state == .changed{
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
        if sender.state == .ended{
            newlyCreatedFace.transform = newlyCreatedFace.transform.scaledBy(x: 0.80, y: 0.80)
        }
    }
    
    
    @objc func didPinchImageView(_ sender: UIPinchGestureRecognizer){
        let scale = sender.scale
        let imageView = sender.view as! UIImageView
        imageView.transform = imageView.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
    }
    
    @objc func didRotateImageView(_ sender: UIRotationGestureRecognizer){
        let rotation = sender.rotation
        let imageView = sender.view as! UIImageView
        imageView.transform = imageView.transform.rotated(by: rotation)
        sender.rotation = 0
    }
    @objc func didDoubleTapImageView(_ sender: UITapGestureRecognizer){
        let imageView = sender.view as! UIImageView
        imageView.removeFromSuperview()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
