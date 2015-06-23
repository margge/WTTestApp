//
//  WTLoginViewController.swift
//  wt_login
//
//  Created by Margge Guiza
//  Copyright (c) 2015 Margge Guiza. All rights reserved.
//

import UIKit

class WTLoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var user: UserModel = UserModel()
    var loginSucessful: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logInUser(sender: AnyObject) {
        loginUserService(emailTextField.text, pass: passwordTextField.text) { (successful) -> () in
            
            if successful && self.loginSucessful{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let mainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                    mainViewController.newUser = self.user
                self.presentViewController(mainViewController, animated:true, completion:nil)
                println(self.emailTextField)
                println(self.passwordTextField)
            }else{
                WTAppUtils.showErrorMessage("Authetication error", alertMessage: "Please verify your information", viewController: self)
            }
        }
    }
    
    func loginUserService(email:String,pass:String, complete:(successful:Bool)->()){
        
        var ob1 = [nameParam:"USR",valueParam:appUsr]
        var ob2 = [nameParam:"PASS",valueParam:appPass]
        var ob3 = [nameParam:"CLIENTEID",valueParam:appClientId]
        var ob4 = [nameParam:"MAIL",valueParam:email]
        var ob5 = [nameParam:"PASSWORD",valueParam:pass]
        var ob6 = [nameParam:"METHOD",valueParam:getUserLogin]
        var ob7 = [nameParam:"IMEI",valueParam:appImei]
        var params = ["GP":[ob1,ob2,ob3,ob4,ob5,ob6,ob7]]
        
        sharedManager.POST(urlApi, parameters: params, success: { (operation, response) -> () in
            
            //successfully
            var json = JSON(response)
            println(json)
            var gp = json["GP"].arrayValue
            
            for subJson in gp {
                if subJson[nameParam].stringValue == "FNAME" {
                    self.loginSucessful = true
                    self.user.usr = appUsr
                    self.user.pass = appPass
                    self.user.clientId = appClientId
                    self.user.username = subJson["Value"].stringValue
                }
                if subJson[nameParam].stringValue == "LNAME" {
                    self.user.lastname = subJson["Value"].stringValue
                }
                if subJson[nameParam].stringValue == "PHONE" {
                    self.user.phone = subJson["Value"].stringValue
                }
                if subJson[nameParam].stringValue == "EMAIL" {
                    self.user.mail = subJson["Value"].stringValue
                }
                if subJson[nameParam].stringValue == "PASSWORD" {
                    self.user.password = subJson["Value"].stringValue
                }
                if subJson[nameParam].stringValue == "ID" {
                    self.user.userId = subJson["Value"].stringValue
                }
            }
            
            complete(successful: true)
          }) { (operation, error) -> () in
            //error
            complete(successful: false)
        }
    }
}
