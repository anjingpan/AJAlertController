//
//  AJAlertController.swift
//  AJAlertController
//
//  Created by mac on 2017/11/7.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

@objc public enum AJAlertControllerStyle : Int {
    case alert
    case wideScreen
}

let kAnimated = "animated"

class AJAlertController: UIViewController {

    // MARK: - Property
    open var isDismissTapBackground = false
    open var isAnimated = true
    open var textFields = [UITextField]()
    open var textFieldMarginX : CGFloat = 12
    open var textFieldHieght : CGFloat = 44
    open var actionHeight : CGFloat = 44
    
    @IBOutlet weak var alertBackgroundView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionView: UIView!
    
    @IBOutlet weak var alertViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewMarginTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var actionViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate var timer : Timer?
    fileprivate var actions = [AJAlertAction]()
    
    // MARK: - Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if actionView.subviews.count == 0 {
            imageViewMarginTop.constant += (messageLabel.frame.minY - titleLabel.frame.maxY)
            actionViewHeightConstraint.constant = 0
        }
        
        if actions.count == 2 {
            for (index,textField) in textFields.enumerated() {
                textField.frame = CGRect.init(x: textFieldMarginX, y: CGFloat(index) * textFieldHieght, width: alertViewWidthConstraint.constant - 2 * textFieldMarginX, height: textFieldHieght)
            }
            
            for (index,action) in actions.enumerated() {
                action.frame = CGRect.init(x: alertViewWidthConstraint.constant * 0.5 * CGFloat(index), y: CGFloat(textFields.count) * textFieldHieght, width: alertViewWidthConstraint.constant * 0.5, height: actionHeight)
            }
            actionViewHeightConstraint.constant = CGFloat(textFields.count) * textFieldHieght + actionHeight
            
            return
        }
        
        for (index,textField) in textFields.enumerated() {
            textField.frame = CGRect.init(x: textFieldMarginX, y: CGFloat(index) * textFieldHieght, width: alertViewWidthConstraint.constant - 2 * textFieldMarginX, height: textFieldHieght)
        }
        
        for (index,action) in actions.enumerated() {
            action.frame = CGRect.init(x: 0, y: CGFloat(textFields.count) * textFieldHieght + CGFloat(index) * actionHeight, width: alertViewWidthConstraint.constant, height: actionHeight)
        }
        
        actionViewHeightConstraint.constant = CGFloat(textFields.count) * textFieldHieght + CGFloat(actions.count) * actionHeight
        
    }
    
    // MARK: - Public Function
    @objc public convenience init(title: String?, message: String?, image: UIImage?, prefferedStyle: AJAlertControllerStyle) {
        self.init()
        
        let nib = Bundle.main.loadNibNamed("AJAlertController", owner: self, options: nil)
        view = nib?.first as! UIView
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        
        alertView.layer.cornerRadius = 6
        alertView.layer.masksToBounds = false
        alertView.layer.shadowRadius = 8
        alertView.layer.shadowOpacity = 0.3
        
        (image != nil) ? (imageView.image = image) : (imageViewHeightConstraint.constant = 0)
        imageView.clipsToBounds = true
        titleLabel.text = title
        messageLabel.text = message
        
        prefferedStyle == .alert ? (alertViewWidthConstraint.constant = 270) : (alertViewWidthConstraint.constant = UIScreen.main.bounds.size.width - 36)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapBackgroundView))
        alertBackgroundView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc public func addAction(_ action: AJAlertAction) {
        actions.append(action)
        actionView.addSubview(action)
        action.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
    }
    
    @objc public func addTextField(_ configuration : ((_ textField : UITextField) -> Void)?) {
        let textFiled = UITextField.init()
        configuration?(textFiled)
        textFields.append(textFiled)
        actionView.addSubview(textFiled)
    }
    
    @objc public func hide(_ animated: Bool) {
        dismissAlert(animated)
    }
    
    @objc public func hide(_ animated: Bool, afterDelay: Double) {
        setupTimer(afterDelay, animated)
    }
    
    // MARK: - Notification
    @objc fileprivate func keyboardWillShow(_ notification : Notification) {
        guard let keyboardMiny = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.minY else { return }
        
        //修复键盘高度变小后其不跟随键盘下来
        if alertView.center.y < alertBackgroundView.center.y {
            alertView.center.y += (alertBackgroundView.center.y - alertView.center.y) > (keyboardMiny - alertView.frame.maxY) ? (alertBackgroundView.center.y - alertView.center.y) - (keyboardMiny - alertView.frame.maxY) : 0
        }else{
            alertView.center.y -= alertView.frame.maxY - keyboardMiny > 0 ? alertView.frame.maxY - keyboardMiny : 0
        }
    }
    
    @objc fileprivate func keyboardWillHide(_ notification : Notification) {
        alertView.center = alertBackgroundView.center
    }
    
    // MARK: - Timer
    @objc fileprivate func setupTimer(_ timerInterval : Double , _ animated : Bool) {
        timer = Timer.init(timeInterval: timerInterval, target: self, selector: #selector(timerFired(_:)), userInfo: [kAnimated : animated], repeats: false)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    
    @objc fileprivate func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Action
    @objc fileprivate func clickAction() {
        dismissAlert(isAnimated)
    }
    
    @objc fileprivate func tapBackgroundView() {
        if !isDismissTapBackground {
            return
        }
        
        dismissAlert(isAnimated)
    }
    
    @objc fileprivate func dismissAlert(_ animated: Bool) {
        if let _ = timer {
            invalidateTimer()
        }
        
        if animated {
            UIView.animate(withDuration: 0.75, animations: {
                self.view.alpha = 0
            }) { (isComplete) in
                self.dismiss(animated: false, completion: nil)
            }
        }else{
            dismiss(animated: false, completion: nil)
        }
    }
    
    @objc fileprivate func timerFired(_ timer : Timer) {
        if let userInfo = timer.userInfo as? Dictionary<String, Bool>{
            let animated = userInfo[kAnimated] ?? false
            dismissAlert(animated)
            return
        }
        dismissAlert(false)
    }
    
}
