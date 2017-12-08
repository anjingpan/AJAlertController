//
//  AJAlertAction.swift
//  AJAlertController
//
//  Created by mac on 2017/11/8.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

@objc public enum AJAlertActionStyle : Int {
    case `default`
    case cancel
}

class AJAlertAction: UIButton {

    // MARK: - Property
    open var actionStyle : AJAlertActionStyle
    open var seperatorColor : UIColor {
        didSet {
            seperatorView.backgroundColor = seperatorColor
        }
    }
    
    fileprivate var seperatorView : UIView!
    
    fileprivate var action : (() -> Void)?

    // MARK: - Life Cycle
    init() {
        actionStyle = .default
        seperatorColor = .groupTableViewBackground
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init View
    @objc public convenience init(title: String, style: AJAlertActionStyle, handler: (() -> Void)? ){
        self.init()
        
        setTitle(title, for: .normal)
        titleLabel?.textAlignment = .center
        
        actionStyle = style
        style == .default ? (self.setTitleColor(UIColor(red: 191.0/255.0, green: 51.0/255.0, blue: 98.0/255.0, alpha: 1.0), for: UIControlState())) : (self.setTitleColor(UIColor.gray, for: UIControlState()))
        
        action = handler
        
        addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        
        initSeperatorView()
    }
    
    func initSeperatorView() {
        seperatorView = UIView.init()
        seperatorView.backgroundColor = seperatorColor
        addSubview(seperatorView)
        
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[seperatorView]-8-|", options: .directionLeftToRight, metrics: nil, views: ["seperatorView" : seperatorView])
        constraintsH.first?.priority = .defaultHigh
        addConstraints(constraintsH)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[seperatorView(1)]", options: .directionLeadingToTrailing, metrics: nil, views: ["seperatorView" : seperatorView]))
    }
    
    // MARK: - Button Click
    @objc func clickAction() {
        action?()
    }
    
}
