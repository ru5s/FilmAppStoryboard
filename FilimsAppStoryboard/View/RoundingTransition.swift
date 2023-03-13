//
//  RoundingTransition.swift
//  FilimsAppStoryboard
//
//  Created by Ruslan Ismailov on 01/03/23.
//

import Foundation
import UIKit

class RoundingTransition: NSObject {
    
    var round = UIView()
    
    var start = CGPoint.zero {
        didSet {
            round.center = start
        }
    }
    
    var roundColor = UIColor.red
    
    var time = 0.6
    
    enum RoundingTransitionProfile: Int {
        case show, cancel, pop
    }
    
    var transitionProfile: RoundingTransitionProfile = .show
    
}

extension RoundingTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return time
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        if transitionProfile == .show {
            if let showedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                
                let viewCenter = showedView.center
                let viewSize = showedView.frame.size
                
                round = UIView()
                
                round.frame = roundFrame(withViewCenter: viewCenter, size: viewSize, startPoint: start)
                
                round.layer.cornerRadius = round.frame.size.height / 2
                round.center = start
                round.backgroundColor = roundColor
                round.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                container.addSubview(round)
                
                showedView.center = start
                showedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                showedView.alpha = 0
                container.addSubview(showedView)
                
                UIView.animate(withDuration: time, animations: {
                    self.round.transform = CGAffineTransform.identity
                    showedView.transform = CGAffineTransform.identity
                    showedView.alpha = 1
                    showedView.center = viewCenter
                    
                }, completion: {(success: Bool) in
                    transitionContext.completeTransition(success)
                })
            }
            
        } else {
            
            let transitionModeKey = (transitionProfile == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returnableView = transitionContext.view(forKey: transitionModeKey) {
                
                let viewCenter = returnableView.center
                let viewSize = returnableView.frame.size
                
                round.frame = roundFrame(withViewCenter: viewCenter, size: viewSize, startPoint: start)
                
                round.layer.cornerRadius = round.frame.size.height / 2
                round.center = start
                
                UIView.animate(withDuration: time, animations: {
                    
                    self.round.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returnableView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returnableView.center = self.start
                    returnableView.alpha = 0
                    
                    if self.transitionProfile == .pop {
                        container.insertSubview(returnableView, belowSubview: returnableView)
                        container.insertSubview(self.round, belowSubview: returnableView)
                    }
                    
                }, completion: { (success: Bool) in
                    returnableView.center = viewCenter
                    returnableView.removeFromSuperview()
                    
                    self.round.removeFromSuperview()
                    
                    transitionContext.completeTransition(success)
                })
            }
        }
    }
    
    func roundFrame(withViewCenter viewCenter: CGPoint, size viewsize: CGSize, startPoint:CGPoint) -> CGRect {
        
        let xLength = fmax(startPoint.x, viewsize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewsize.height - startPoint.y)
        
        let offsetVector = sqrt(xLength * xLength * yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
    
}
