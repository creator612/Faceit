//
//  ViewController.swift
//  Faceit
//
//  Created by 이소영 on 2022/06/03.
//

import UIKit

class FaceViewController: UIViewController
{
    var expression = FacialExpression(eyes: .Closed, eyeBrows: .Relaxed, mouth: .Smirk){
        didSet{
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView!{
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(faceView.changeScale(recognizer:))
            ))
            
            let happierSwiperGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.increaseHappiness)
            )
            happierSwiperGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwiperGestureRecognizer)
            
            let sadderSwiperGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.decreaseHappiness)
            )
            sadderSwiperGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwiperGestureRecognizer)
            
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer)
    {
        if recognizer.state == .ended{
            switch expression.eyes{
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    
    @objc
    func increaseHappiness()
    {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    @objc
    func decreaseHappiness()
    {
        expression.mouth = expression.mouth.sadderMouth()
    }

    
    private var mouthCurvatures = [ FacialExpression.Mouth.Frown: -1.0, .Grin: 0.5, .Smile: 1.0, .Smirk: -0.5, .Neutral: 0.0 ]
    private var eyeBrouwTilts = [ FacialExpression.EyeBrows.Relaxed: 0.5, .Furrowed: -0.5, .Normal: 0.0 ]
    
    private func updateUI() {
        switch expression.eyes{
        case .Open: faceView.eyesOpen = true
        case .Closed: faceView.eyesOpen = false
        case .Squinting: faceView.eyesOpen = false
        }
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = eyeBrouwTilts[expression.eyeBrows] ?? 0.0
    }
    
}

