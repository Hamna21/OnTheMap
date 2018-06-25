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
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var signUpTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        
        //Text to be displayed in SignUpView
        //let signUpText = "Don't have an account? Sign Up"
        let attributedString = NSMutableAttributedString(string: "Don't have an account? Sign Up")
        attributedString.addAttribute(.link, value: "https://www.udacity.com", range: NSRange(location: 23, length: 7))
        attributedString.addAttribute(.paragraphStyle, value: titleParagraphStyle, range: NSRange(location: 0, length: 30))
        
        signUpTextView.attributedText = attributedString
    
        /*subscribeToNotification(.UIKeyboardWillShow, #selector(keyboardWillShow(_:)))
        subscribeToNotification(.UIKeyboardWillHide, #selector(keyboardWillHide(_:)))
        subscribeToNotification(.UIKeyboardDidShow, #selector(keyboardDidShow(_:)))
        subscribeToNotification(.UIKeyboardDidHide, #selector(keyboardDidHide(_:)))*/
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    //Login Button tapped
    @IBAction func loginBtnPressed(_ sender: Any) {
        userDidTapView(self)
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            presentAlertController("Email or Password empty")
        }else{
            setUIEnabled(false)
            let emailText = emailTextField.text!
            let passwordText = passwordTextField.text!
            
            UdacityClient.sharedInstance().authenticateUser(email: emailText, password: passwordText) { (success, error) in
                performUIUpdatesOnMain {
                    if let error = error {
                        self.presentAlertController(error)
                        self.setUIEnabled(true)
                    }else{
                        self.completeLogin()
                    }
                }
            }
        }
    }
    
    private func completeLogin(){
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        present(controller,animated: true) {
            self.setUIEnabled(true)
        }
    }
}


extension LoginViewController: UITextFieldDelegate {
    //Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

extension LoginViewController : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let app = UIApplication.shared
        app.open(URL, options: [:])
        return true
    }
}

//Configure UI
private extension LoginViewController{
    func setUIEnabled(_ enabled: Bool){
        emailTextField.isEnabled = enabled
        passwordTextField.isEnabled = enabled
        loginBtn.isEnabled = enabled
       
        if enabled{
            loginBtn.alpha = 1.0
            emailTextField.text = ""
            passwordTextField.text = ""
        }else{
            loginBtn.alpha = 0.5
        }
    }
    
    func presentAlertController(_ message: String? = nil){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
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

