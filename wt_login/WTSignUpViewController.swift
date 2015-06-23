//
//  WTSignUpViewController.swift
//  wt_login
//
//  Created by Margge Guiza
//  Copyright (c) 2015 Margge Guiza. All rights reserved.
//

import UIKit

class WTSignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    var userId: String = "test"
    var user: UserModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUpUser(sender: AnyObject) {
        
        if self.verifyPassword() {
        
            signUpService(userNameTextField.text, lastname: lastNameTextField.text, email: emailTextField.text, address:addressTextField.text, phone: phoneTextField.text, password: passwordTextField.text) { (successful) -> () in
                
                if (successful && self.userId != "test"){
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                    nextViewController.newUser = self.user
                    self.presentViewController(nextViewController, animated:true, completion:nil)
                    
                }else{
                    WTAppUtils.showErrorMessage("Registration error", alertMessage: "Please verify your information", viewController: self)
                }
            }
        }else{
            WTAppUtils.showErrorMessage("Registration error", alertMessage: "Please verify your password and try again", viewController: self)
        }
    }
    
    func signUpService(username: String, lastname: String, email: String, address: String, phone: String, password: String, complete:(successful:Bool)->()){
        
        //Set params
        var ob1 = [nameParam:"USR",valueParam:appUsr]
        var ob2 = [nameParam:"PASS",valueParam:appPass]
        var ob3 = [nameParam:"CLIENTEID",valueParam:appClientId]
        var ob4 = [nameParam:"PHONE",valueParam:phone]
        var ob5 = [nameParam:"NAME",valueParam:username]
        var ob6 = [nameParam:"LASTNAME",valueParam:lastname]
        var ob7 = [nameParam:"ADDRESS",valueParam:address]
        var ob8 = [nameParam:"MAIL",valueParam:email]
        var ob9 = [nameParam:"PASSWORD",valueParam:password]
        var ob10 = [nameParam:"ID",valueParam:"0"]
        var ob11 = [nameParam:"METHOD",valueParam:signUp]
        var params = ["GP":[ob1,ob2,ob3,ob4,ob5,ob6,ob7,ob8,ob9,ob10,ob11]]
        
        sharedManager.POST(urlApi, parameters: params, success: { (operation, response) -> () in
            
            //sucessful
            var json = JSON(response)
            println(json)
            
            var gp = json["GP"].arrayValue
            
            self.user.usr = appUsr
            self.user.pass = appPass
            self.user.clientId = appClientId
            self.user.phone = phone
            self.user.username = username
            self.user.lastname = lastname
            self.user.address = address
            self.user.mail = email
            self.user.password = password
            self.user.userId = "0"
            
            for subJson in gp {
                if subJson["Name"].stringValue == "ID" {
                    println(subJson["Value"].stringValue)
                    self.userId = subJson["Value"].stringValue
                    self.user.userId = subJson["Value"].stringValue
                }
            }
            
            complete(successful: true)
            
            }) { (operation, error) -> () in
                println(error)
                //error
                complete(successful: false)
        }
    }
    
    func verifyPassword()-> Bool{
        return passwordTextField.text == verifyPasswordTextField.text
    }
}
