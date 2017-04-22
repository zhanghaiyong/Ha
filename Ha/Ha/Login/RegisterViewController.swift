//
//  RegisterViewController.swift
//  Ha
//
//  Created by zhy on 2017/4/22.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    var userTextF : JVFloatLabeledTextField!
    var passwordTextF : JVFloatLabeledTextField!
    var emailTextF : JVFloatLabeledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.initSubViews()
        
    }
    
    func initSubViews() {
        
        let cancleButton = UIButton(frame: CGRect(x: kSCREENWIDTH-60, y: 20, width: 44, height: 44))
        cancleButton.titleLabel?.font = UIFont(name: kFONT, size: 17)
        cancleButton.setTitle("X", for: .normal)
        cancleButton.setTitleColor(UIColor.black, for: .normal)
        cancleButton.addTarget(self, action: #selector(RegisterViewController.cancleAction), for: .touchUpInside)
        self.view.addSubview(cancleButton)
        
        let smileImageV = UIImageView(frame: CGRect(x: kSCREENWIDTH/2-75, y: 30, width: 150, height: 150))
        smileImageV.image = UIImage(named: "smile")
        self.view.addSubview(smileImageV)
        
        let logoImage = UIImageView(frame: CGRect(x: 40, y: smileImageV.bottom, width: kSCREENWIDTH-30, height: 50))
        logoImage.image = UIImage(named: "logo")
        self.view.addSubview(logoImage)
        
        self.userTextF = JVFloatLabeledTextField(frame: CGRect(x: 30, y: logoImage.bottom+15, width: kSCREENWIDTH-60, height: 44))
        self.userTextF.borderStyle = .roundedRect
        self.userTextF.font = UIFont(name: kFONT, size: 15)
        self.userTextF.placeholder = "用户名"
        self.view.addSubview(self.userTextF)
        
        self.passwordTextF = JVFloatLabeledTextField(frame: CGRect(x: 30, y: self.userTextF.bottom+15, width: kSCREENWIDTH-60, height: 44))
        self.passwordTextF.font = UIFont(name: kFONT, size: 15)
        self.passwordTextF.borderStyle = .roundedRect
        self.passwordTextF.isSecureTextEntry = true
        self.passwordTextF.placeholder = "密码"
        self.view.addSubview(self.passwordTextF)
        
        self.emailTextF = JVFloatLabeledTextField(frame: CGRect(x: 30, y: self.passwordTextF.bottom+15, width: kSCREENWIDTH-60, height: 44))
        self.emailTextF.font = UIFont(name: kFONT, size: 15)
        self.emailTextF.borderStyle = .roundedRect
        self.emailTextF.isSecureTextEntry = true
        self.emailTextF.placeholder = "邮箱"
        self.view.addSubview(self.emailTextF)
        
        let loginButton = UIButton(frame: CGRect(x: 30, y: self.emailTextF.bottom+15, width: kSCREENWIDTH-60, height: 44))
        loginButton.titleLabel?.font = UIFont(name: kFONT, size: 15)
        loginButton.setTitle("注册", for: .normal)
        loginButton.backgroundColor = mainColor
        loginButton.layer.cornerRadius = 2
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.addTarget(self, action: #selector(RegisterViewController.registerAction), for: .touchUpInside)
        self.view.addSubview(loginButton)
    }
    
    func registerAction() {
        
        
    }
    
    func cancleAction() {
        
        self.dismiss(animated: true, completion: nil)
    }

}
