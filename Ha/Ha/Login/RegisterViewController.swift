//
//  RegisterViewController.swift
//  Ha
//
//  Created by zhy on 2017/4/22.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,UITextFieldDelegate {

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
        
        self.emailTextF = JVFloatLabeledTextField(frame: CGRect(x: 30, y: self.passwordTextF.bottom+15, width: kSCREENWIDTH-60, height: 40))
        self.emailTextF.font = UIFont(name: kFONT, size: 15)
        self.emailTextF.layer.borderColor = mainColor.cgColor
        self.emailTextF.layer.borderWidth = 0.5
        self.emailTextF.layer.cornerRadius = 3
        self.emailTextF.isSecureTextEntry = true
        self.emailTextF.setValue(10, forKey: "paddingLeft")
        self.emailTextF.placeholder = "邮箱"
        self.emailTextF.delegate = self
        self.view.addSubview(self.emailTextF)
        
        let loginButton = UIButton(frame: CGRect(x: 30, y: self.emailTextF.bottom+15, width: kSCREENWIDTH-60, height: 40))
        loginButton.titleLabel?.font = UIFont(name: kFONT, size: 15)
        loginButton.setTitle("注册", for: .normal)
        loginButton.backgroundColor = mainColor
        loginButton.layer.cornerRadius = 2
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.addTarget(self, action: #selector(RegisterViewController.registerAction), for: .touchUpInside)
        self.view.addSubview(loginButton)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.userTextF.layer.borderColor = mainColor.cgColor
        self.passwordTextF.layer.borderColor = mainColor.cgColor
        self.emailTextF.layer.borderColor = mainColor.cgColor
    }
    
    func registerAction() {
        
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
        
        if (self.emailTextF.text?.isEmpty)! {
            
            self.emailTextF.layer.borderColor = UIColor.red.cgColor
            ProgressHUD.showError("请输入邮箱")
            return
        }
        
        let user = AVUser()
        user.username = self.userTextF.text
        user.password = self.passwordTextF.text
        user.email = self.emailTextF.text
        user.signUpInBackground { (success, error) in
            
            if success {

                ProgressHUD.showSuccess("注册成功")
                self.dismiss(animated: true, completion: nil)
            }else {
                
                if (error! as NSError).code == 125 {
                    ProgressHUD.showError("邮箱不合法")
                }else if (error! as NSError).code == 203 {
                    
                    ProgressHUD.showError("该邮箱已注册")
                }else if (error! as NSError).code == 202 {
                    
                    ProgressHUD.showError("用户名已存在")
                }else {
                    
                    ProgressHUD.showError("注册失败")
                }
            }
        }
        
    }
    
    func cancleAction() {
        
        self.dismiss(animated: true, completion: nil)
    }

}
