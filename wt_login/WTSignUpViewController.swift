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
    
    var userId: String = "test"
    var user: UserModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUpUser(sender: AnyObject) {
        
        signUpService(userNameTextField.text, lastname: lastNameTextField.text, email: emailTextField.text, address:addressTextField.text, phone: phoneTextField.text) { (successful) -> () in
            if (successful && self.userId != "test"){
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                nextViewController.newUser = self.user
                self.presentViewController(nextViewController, animated:true, completion:nil)
                
            }else{
                self.showErrorMessage()
            }
        }
    }
    
    func signUpService(username: String, lastname: String, email: String, address: String, phone: String, complete:(successful:Bool)->()){
        
        //Set params
        var ob1 = [nameParam:"USR","Value":"taxi"]
        var ob2 = [nameParam:"PASS","Value":"taxi"]
        var ob3 = [nameParam:"CLIENTEID","Value":"33047"]
        var ob4 = [nameParam:"PHONE","Value":phone]
        var ob5 = [nameParam:"NAME","Value":username]
        var ob6 = [nameParam:"LASTNAME","Value":lastname]
        var ob7 = [nameParam:"ADDRESS","Value":address]
        var ob8 = [nameParam:"MAIL","Value":email]
        var ob9 = [nameParam:"PASSWORD","Value":"12345"]
        var ob10 = [nameParam:"ID","Value":"0"]
        var ob11 = [nameParam:"METHOD","Value":"SINGUP"]
        var params = ["GP":[ob1,ob2,ob3,ob4,ob5,ob6,ob7,ob8,ob9,ob10,ob11]]
        
        sharedManager.POST(urlApi, parameters: params, success: { (operation, response) -> () in
            
            //sucessful
            var json = JSON(response)
            println(json)
            
            var gp = json["GP"].arrayValue
            
            self.user.usr = "taxi"
            self.user.pass = "taxi"
            self.user.clientId = "33047"
            self.user.phone = phone
            self.user.username = username
            self.user.lastname = lastname
            self.user.address = address
            self.user.mail = email
            self.user.password = "12345"
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
    
    
    func showErrorMessage(){
        println("**** Error realizando el registro del usuario")
        var alert = UIAlertController(title: "Registration error", message: "Please verify your information", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
