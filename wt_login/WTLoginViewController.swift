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
                self.showErrorMessage()
            }
        }
    }
    
    func loginUserService(email:String,pass:String, complete:(successful:Bool)->()){
        
        var ob1 = [nameParam:"USR","Value":"taxi"]
        var ob2 = [nameParam:"PASS","Value":"taxi"]
        var ob3 = [nameParam:"CLIENTEID","Value":"33047"]
        var ob4 = [nameParam:"MAIL","Value":email]
        var ob5 = [nameParam:"PASSWORD","Value":pass]
        var ob6 = [nameParam:"METHOD","Value":"GETUSERLOGIN"]
        var ob7 = [nameParam:"IMEI","Value":"353922053883383"]
        var params = ["GP":[ob1,ob2,ob3,ob4,ob5,ob6,ob7]]
        
        sharedManager.POST(urlApi, parameters: params, success: { (operation, response) -> () in
            
            //successfully
            var json = JSON(response)
            println(json)
            var gp = json["GP"].arrayValue
            
            for subJson in gp {
                if subJson["Name"].stringValue == "FNAME" {
                    self.loginSucessful = true
                    self.user.usr = "taxi"
                    self.user.pass = "taxi"
                    self.user.clientId = "33047"
                    self.user.username = subJson["Value"].stringValue
                }
                if subJson["Name"].stringValue == "LNAME" {
                    self.user.lastname = subJson["Value"].stringValue
                }
                if subJson["Name"].stringValue == "PHONE" {
                    self.user.phone = subJson["Value"].stringValue
                }
                if subJson["Name"].stringValue == "EMAIL" {
                    self.user.mail = subJson["Value"].stringValue
                }
                if subJson["Name"].stringValue == "PASSWORD" {
                    self.user.password = subJson["Value"].stringValue
                }
                if subJson["Name"].stringValue == "ID" {
                    self.user.userId = subJson["Value"].stringValue
                }
            }
            
            complete(successful: true)
          }) { (operation, error) -> () in
            //error
            complete(successful: false)
        }
    }
    
    func showErrorMessage(){
        var alert = UIAlertController(title: "Authetication error", message: "Please verify your information", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
