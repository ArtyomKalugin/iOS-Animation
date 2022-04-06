//
//  ViewController.swift
//  iOS - Animation
//
//  Created by Artem Kalugin on 04.04.2022.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingCompleteLabel: UILabel!
    
    // private properties
    private var loadingAnimator: UIViewPropertyAnimator!
    private var loadingCompleteAnimator: UIViewPropertyAnimator!
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoadingCompleteLabel()
        configureLoadingView()
        configureAnimators()
        configureProgressView()
        startLoading()
    }
    
    // actions
    @IBAction func backButtonAction(_ sender: Any) {
        loadingAnimator.stopAnimation(true)
        loadingCompleteAnimator.stopAnimation(true)
        
        dismiss(animated: true, completion: nil)
    }
    
    // private functions
    private func configureAnimators() {
        loadingAnimator = UIViewPropertyAnimator(duration: 5, curve: .easeIn, animations: { [weak self] in
            
            self?.loadingView.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            self?.loadingView.layer.borderWidth = 50
            self?.loadingView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        })
        
        loadingCompleteAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn, animations: { [weak self] in
            
            self?.loadingView.layer.cornerRadius = 4
            self?.loadingView.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 0.8037820778)
            self?.loadingView.transform = CGAffineTransform.init(scaleX: 3, y: 1.5)
            
            self?.loadingCompleteLabel.center = self?.loadingView.center ?? CGPoint(x: 0, y: 0)
            self?.loadingCompleteLabel.alpha = 1
            
        })
    }
    
    private func configureLoadingView() {
        loadingView.layer.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0)
        loadingView.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        loadingView.layer.borderWidth = 4.0
        loadingView.layer.cornerRadius = loadingView.frame.height / 2
    }
    
    private func configureProgressView() {
        progressView.progress = 0
    }
    
    private func configureLoadingCompleteLabel() {
        loadingCompleteLabel.alpha = 0
    }
    
    private func startLoading() {
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            
            self?.loadingAnimator.fractionComplete = CGFloat(self?.progressView.progress ?? 0)
            self?.progressView.progress += 0.01
            
            if self?.progressView.progress == 1 {
                timer.invalidate()
                self?.loadingCompleteAnimator.startAnimation()
            }
        }
    }

}

