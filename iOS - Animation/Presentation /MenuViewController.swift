//
//  MenuViewController.swift
//  iOS - Animation
//
//  Created by Artem Kalugin on 06.04.2022.
//

import UIKit

class MenuViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var transitioningView: UIView!
    @IBOutlet weak var toLoadLabel: UILabel!
    
    // private properties
    var tapGesture: UITapGestureRecognizer!
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTapGesture()
        configureTransitioningView()
    }
    
    // private functions
    private func configureTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(transitioningViewDidTap))
    }
    
    private func configureTransitioningView() {
        transitioningView.layer.cornerRadius = 8.0
        transitioningView.clipsToBounds = true
        
        transitioningView.addGestureRecognizer(tapGesture)
    }
    
    // objc functions
    @objc func transitioningViewDidTap() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainScreenViewController") as! MainScreenViewController
        
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension MenuViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let fromViewController = presenting as? MenuViewController,
              let toViewController = presented as? MainScreenViewController else {
                  return nil
              }
        
        return AnimatedTransitioning(fromViewController: fromViewController, toViewController: toViewController)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return nil
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
final class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    // private properties
    private let fromViewController: UIViewController
    private let toViewController: UIViewController
    private let duration: TimeInterval = 1.5
    
    // MARK: - Life cycle
    init(fromViewController: UIViewController, toViewController: UIViewController) {
        
        self.fromViewController = fromViewController
        self.toViewController = toViewController
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let toView = toViewController.view else {
            
            transitionContext.completeTransition(false)
            return
        }
        
        guard let menuViewController = fromViewController as? MenuViewController else {
                  
                  transitionContext.completeTransition(false)
                  return
              }
        
        toView.alpha = 0
        containerView.addSubview(toView)
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic) {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                menuViewController.toLoadLabel.alpha = 0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: self.duration - 0.2) {
                menuViewController.transitioningView.transform = CGAffineTransform(scaleX: 10, y: 10)
                toView.alpha = 1
            }
            
        } completion: { _ in
            
            transitionContext.completeTransition(true)
            menuViewController.transitioningView.transform = .identity
            menuViewController.toLoadLabel.alpha = 1
            
            return
        }
    }
}
