//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Hamna Usmani on 6/22/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var keyboardOnScreen = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        /*subscribeToNotification(.UIKeyboardWillShow, #selector(keyboardWillShow(_:)))
        subscribeToNotification(.UIKeyboardWillHide, #selector(keyboardWillHide(_:)))
        subscribeToNotification(.UIKeyboardDidShow, #selector(keyboardDidShow(_:)))
        subscribeToNotification(.UIKeyboardDidHide, #selector(keyboardDidHide(_:)))*/
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        userDidTapView(self)
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugTextLabel.text = "User or Password Empty"
        }else{
            setUIEnabled(false)
            let emailText = emailTextField.text!
            let passwordText = passwordTextField.text!
            
            UdacityClient.sharedInstance().authenticateUser(email: emailText, password: passwordText) { (success, error) in
                performUIUpdatesOnMain {
                    if let error = error {
                        self.displayError(error)
                    }else{
                        self.completeLogin()
                    }
                }
            }
        }
    }
    
    private func completeLogin(){
        debugTextLabel.text = ""
        setUIEnabled(true) //REMOVE LATER
    }
    private func displayError(_ error: NSError?){
        if let error = error {
            debugTextLabel.text = error.localizedDescription.description
        }
        setUIEnabled(true) //REMOVE LATER
    }
}


extension LoginViewController: UITextFieldDelegate {
    //Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        debugTextLabel.text = ""
    }
    @objc func keyboardWillShow(_ notification: Notification){
        if !keyboardOnScreen {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification){
        if keyboardOnScreen{
            view.frame.origin.y += keyboardHeight(notification)
        }
        
    }
    @objc func keyboardDidShow(_ notification: Notification){
        keyboardOnScreen = true
        
    }
    @objc func keyboardDidHide(_ notification: Notification){
        keyboardOnScreen = false
    }
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
        
    }
    func resignIfFirstResponder(_ textField: UITextField){
        if textField.isFirstResponder{
            textField.resignFirstResponder()
        }
    }
    //Handling Tap on VIEW
    @IBAction func userDidTapView(_ sender: AnyObject){
        resignIfFirstResponder(emailTextField)
        resignIfFirstResponder(passwordTextField)
    }
}
//Configure UI
private extension LoginViewController{
    func setUIEnabled(_ enabled: Bool){
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginBtn.isEnabled = enabled
        debugTextLabel.text = ""
        debugTextLabel.isEnabled = enabled
        
        if enabled{
            loginBtn.alpha = 1.0
        }else{
            loginBtn.alpha = 0.5
        }
    }
}
//Notifications
private extension LoginViewController {
    func subscribeToNotification(_ notification: NSNotification.Name, _ selector: Selector){
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    func unsubscribeFromAllNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
}

