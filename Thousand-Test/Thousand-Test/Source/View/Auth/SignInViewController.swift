//
//  SignInViewController.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift

class SignInViewController: UIViewController {
    
    private var titleLabel: UILabel = {
        var titleLabel = UILabel()
        let title = "Sign In"
        let attributedText = NSMutableAttributedString(
            string: title,
            attributes: [
                NSAttributedString.Key.font : UIFont.init(name: "Didot", size: 28)!, NSAttributedString.Key.foregroundColor : UIColor.black ]
        )
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedText
        return titleLabel
    }()
    
    private var wrapperViewForUsername: UIView = {
        var view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rgb(red: 210, green: 210, blue: 210, alpha: 1).cgColor
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    private var usernameAddressTextField: UITextField = {
        var tf = UITextField()
        tf.borderStyle = .none
        tf.autocapitalizationType = .none
        let placeholderAttr = NSAttributedString(
            string: "Username",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 170, green: 170, blue: 170, alpha: 1)
            ]
        )
        tf.attributedPlaceholder = placeholderAttr
        tf.textColor = .rgb(red: 99, green: 99, blue: 99, alpha: 1)
        return tf
    }()
    
    private var wrapperViewForPassword: UIView = {
        var view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.rgb(red: 210, green: 210, blue: 210, alpha: 1).cgColor
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()
    
    private var passwordTextField: UITextField = {
        var tf = UITextField()
        tf.borderStyle = .none
        tf.autocapitalizationType = .none
        let placeholderAttr = NSAttributedString(
            string: "Password( 8+ Characters)",
            attributes: [
                NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 170, green: 170, blue: 170, alpha: 1)
            ]
        )
        tf.attributedPlaceholder = placeholderAttr
        tf.textColor = UIColor.rgb(red: 99, green: 99, blue: 99, alpha: 1)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private var signInBtn: UIButton = {
        var btn = UIButton()
        btn.backgroundColor = .black
        btn.setTitle("Sign In", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(signInDidTaped), for: .touchUpInside)
        return btn
    }()
    
    private var dontHaveAccountBtn: UIButton = {
        var btn = UIButton()
        let attributedText = NSMutableAttributedString(
            string: "Dont't have an account? ",
            attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.65)
            ]
        )
        let attributedSubText = NSMutableAttributedString(
            string: "Sign Up",
            attributes: [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.init(white: 0, alpha: 0.65)
            ]
        )
        attributedText.append(attributedSubText)
        btn.setAttributedTitle(attributedText, for: .normal)
        btn.addTarget(self, action: #selector(moveToSignUpPage), for: .touchUpInside)
        return btn
    }()
    
    private var forgotPasswordBtn: UIButton = {
        var btn = UIButton()
        btn.setTitle("Forgot Password ?", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(moveToResetPasswordPage), for: .touchUpInside)
        return btn
    }()
    
    private let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        makeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}


// MARK: ConfigUI and Constraints
extension SignInViewController {
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(wrapperViewForUsername)
        wrapperViewForUsername.addSubview(usernameAddressTextField)
        view.addSubview(wrapperViewForPassword)
        wrapperViewForPassword.addSubview(passwordTextField)
        view.addSubview(signInBtn)
        view.addSubview(dontHaveAccountBtn)
        view.addSubview(forgotPasswordBtn)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        wrapperViewForUsername.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        usernameAddressTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        wrapperViewForPassword.snp.makeConstraints { (make) in
            make.top.equalTo(wrapperViewForUsername.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        signInBtn.snp.makeConstraints {
            (make) in
            make.top.equalTo(wrapperViewForPassword.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        dontHaveAccountBtn.snp.makeConstraints { (make) in
            make.top.equalTo(signInBtn.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
        }
        
        forgotPasswordBtn.snp.makeConstraints { (make) in
            make.bottomMargin.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(30)
        }
    }
}


// MARK: Actions
extension SignInViewController {
    
    @objc func moveToResetPasswordPage() {
        //        let resetPasswordPage = ResetPasswordViewController()
        //        navigationController?.pushViewController(resetPasswordPage , animated: true)
    }
    
    @objc func moveToSignUpPage() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func signInDidTaped() {
        self.view.endEditing(true)
        viewModel.user = User(username: usernameAddressTextField.text, password: passwordTextField.text)
        viewModel.validateFields()
        viewModel.signIn(onSuccess: {
            let mySceneDelegate = self.view.window?.windowScene?.delegate
            (mySceneDelegate as! SceneDelegate).confugureInitialViewController()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error)
        }
    }
}
