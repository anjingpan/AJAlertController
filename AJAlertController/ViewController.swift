//
//  ViewController.swift
//  AJAlertController
//
//  Created by mac on 2017/11/7.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Init View
    func initView() {
        _ = initButton { (button) in
            button.center = view.center
            button.setTitle("alertWithThreeAction", for: .normal)
            button.backgroundColor = .blue
            button.addTarget(self, action: #selector(alert), for: .touchUpInside)
        }
        
        _ = initButton({ (button) in
            button.center = CGPoint.init(x: view.center.x, y: view.center.y - 60)
            button.setTitle("alertWithTwoAction", for: .normal)
            button.backgroundColor = .red
            button.addTarget(self, action: #selector(alertWithTwoAction), for: .touchUpInside)
        })
        
        _ = initButton({ (button) in
            button.center = CGPoint.init(x: view.center.x, y: view.center.y + 60)
            button.setTitle("alertWithNoAction", for: .normal)
            button.backgroundColor = .gray
            button.addTarget(self, action: #selector(alertWithNoAction), for: .touchUpInside)
        })
        
        _ = initButton({ (button) in
            button.center = CGPoint.init(x: view.center.x, y: view.center.y + 120)
            button.setTitle("alertWithTextField", for: .normal)
            button.backgroundColor = .cyan
            button.addTarget(self, action: #selector(alertWithTextField), for: .touchUpInside)
        })
    }
    
    func initButton(_ configuration : ((_ button : UIButton) -> Void)) {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 0, width: 300, height: 40)
        view.addSubview(button)
        configuration(button)
    }

    // MARK: - Button Click
    @objc func alert() {
        let alert = AJAlertController.init(title: "梅西加油", message: "阿根廷世界杯夺冠", image: #imageLiteral(resourceName: "messi.jpg"), prefferedStyle: .alert)
        let action1 = AJAlertAction.init(title: "恭喜", style: .default) {
            print("恭喜")
        }
        let action2 = AJAlertAction.init(title: "祝贺", style: .destructive) {
            print("祝贺")
        }
        let action3 = AJAlertAction.init(title: "取消", style: .cancel) {
            print("取消")
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func alertWithTwoAction() {
        let alert = AJAlertController.init(title: "加油", message: "UIAlertAction 中 cancel 一定在左侧或者下方，三个及以上 UIAlertAction 时，其竖向排列。两个 UIAlertAction 横向排列，当其中一个的标题显示不下时，其也会竖向排列。只有一个时，显示不下会缩小字体来适应。", image: #imageLiteral(resourceName: "messi.jpg"), prefferedStyle: .wideScreen)
        let action2 = AJAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let action1 = AJAlertAction.init(title: "恭喜", style: .default, handler: nil)

        alert.addAction(action2)
        alert.addAction(action1)
        alert.imageViewWidthConstraint.constant = 80
        alert.imageViewHeightConstraint.constant = 80
        present(alert, animated: true, completion: nil)

    }
    
    @objc func alertWithNoAction() {
        let alert = AJAlertController.init(title: nil, message: "Don't cry for me argentina", image: #imageLiteral(resourceName: "messi.jpg"), prefferedStyle: .alert)
        alert.imageViewWidthConstraint.constant = 80
        alert.imageViewWidthConstraint.constant = 80
        alert.isDismissTapBackground = true
        present(alert, animated: true, completion: nil)
        alert.hide(true, afterDelay: 2)

    }
    
    @objc func alertWithTextField() {
        let alert = AJAlertController.init(title: "登录", message: nil, image: #imageLiteral(resourceName: "messi.jpg"), prefferedStyle: .alert)
        alert.addTextField { (textField) in
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 40))
            label.text = "用户名："
            textField.leftView = label
            textField.leftViewMode = .always
            textField.placeholder = "请输入用户名"
        }
        
        alert.addTextField { (textField) in
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 40))
            label.text = "密码："
            textField.leftView = label
            textField.isSecureTextEntry = true
            textField.leftViewMode = .always
            textField.placeholder = "请输入密码"
        }
        
        let cancel = AJAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let confirm = AJAlertAction.init(title: "确认", style: .default) {
            print(String.init(format: "用户名：%@,密码：%@", alert.textFields.first?.text ?? "",alert.textFields.last?.text ?? ""))
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        present(alert, animated: true, completion: nil)
        
    }

}

