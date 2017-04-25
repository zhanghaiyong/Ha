//
//  LoginViewController.swift
//  Ha
//
//  Created by zhy on 2017/4/22.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    var userTextF: JVFloatLabeledTextField!
    var passwordTextF: JVFloatLabeledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.initSubViews()
    }

    func initSubViews() {
        
        let smileImageV = UIImageView(frame: CGRect(x: kSCREENWIDTH/2-75, y: 30, width: 150, height: 150))
        smileImageV.image = UIImage(named: "smile")
        self.view.addSubview(smileImageV)
        
        let logoImage = UIImageView(frame: CGRect(x: 40, y: smileImageV.bottom, width: kSCREENWIDTH-30, height: 50))
        logoImage.image = UIImage(named: "logo")
        self.view.addSubview(logoImage)
        
        self.userTextF = JVFloatLabeledTextField(frame: CGRect(x: 30, y: logoImage.bottom+15, width: kSCREENWIDTH-60, height: 40))
        self.userTextF.layer.borderColor = mainColor.cgColor
        self.userTextF.layer.borderWidth = 0.5
        self.userTextF.layer.cornerRadius = 3
        self.userTextF.setValue(10, forKey: "paddingLeft")
        self.userTextF.delegate = self
        self.userTextF.font = UIFont(name: kFONT, size: 15)
        self.userTextF.placeholder = "用户名"
        self.view.addSubview(self.userTextF)
        
        self.passwordTextF = JVFloatLabeledTextField(frame: CGRect(x: 30, y: self.userTextF.bottom+15, width: kSCREENWIDTH-60, height: 40))
        self.passwordTextF.font = UIFont(name: kFONT, size: 15)
        self.passwordTextF.layer.borderColor = mainColor.cgColor
        self.passwordTextF.layer.borderWidth = 0.5
        self.passwordTextF.layer.cornerRadius = 3
        self.passwordTextF.setValue(10, forKey: "paddingLeft")
        self.passwordTextF.isSecureTextEntry = true
        self.passwordTextF.placeholder = "密码"
        self.passwordTextF.delegate = self
        self.view.addSubview(self.passwordTextF)
        
        let loginButton = UIButton(frame: CGRect(x: 30, y: self.passwordTextF.bottom+15, width: kSCREENWIDTH-60, height: 40))
        loginButton.titleLabel?.font = UIFont(name: kFONT, size: 15)
        loginButton.setTitle("登陆", for: .normal)
        loginButton.backgroundColor = mainColor
        loginButton.layer.cornerRadius = 2
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.addTarget(self, action: #selector(LoginViewController.loginAction), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        let registerButton = UIButton(frame: CGRect(x: kSCREENWIDTH/2-30, y: loginButton.bottom+15, width: 60, height: 30))
        registerButton.titleLabel?.font = UIFont(name: kFONT, size: 13)
        registerButton.setTitleColor(mainColor, for: .normal)
        registerButton.setTitle("用户注册", for: .normal)
        registerButton.addTarget(self, action: #selector(LoginViewController.registerAction), for: .touchUpInside)
        self.view.addSubview(registerButton)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.userTextF.layer.borderColor = mainColor.cgColor
        self.passwordTextF.layer.borderColor = mainColor.cgColor
    }
    
    func loginAction() {
        
        if (self.userTextF.text?.isEmpty)! {
            
            self.userTextF.layer.borderColor = UIColor.red.cgColor
            ProgressHUD.showError("请输入用户名")
            return
        }
        
        if (self.passwordTextF.text?.isEmpty)! {
            
            self.passwordTextF.layer.borderColor = UIColor.red.cgColor
            ProgressHUD.showError("请输入密码")
            return
        }
        
        AVUser.logInWithUsername(inBackground: self.userTextF.text!, password: self.passwordTextF.text!) { (success, error) in
            
            if (success != nil) {
                
                ProgressHUD.showSuccess("登录成功")
                self.dismiss(animated: true, completion: nil)
            }else {
                
                ProgressHUD.showSuccess("登录失败")
            }
        }
    }
    
    func registerAction() {
        
        let registerVC = RegisterViewController()
        self.present(registerVC, animated: true, completion: nil)
    }
}
