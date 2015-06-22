//
//  WTEditProfileViewController.swift
//  wt_login
//
//  Created by Margge Guiza.
//  Copyright (c) 2015 Margge Guiza. All rights reserved.
//

import UIKit

class WTEditProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var lastnameEditText: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var userProfile: UserModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func updateProfile(sender: AnyObject) {
        editUserService(usernameTextField.text, lastname: lastnameEditText.text, email: emailTextField.text, address:addressTextField.text, phone:phoneTextField.text ) { (successful) -> () in
            if successful{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
                let mainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                    mainViewController.newUser = self.userProfile
                self.presentViewController(mainViewController, animated:true, completion:nil)
            }else{
                println("**** Error editando los datos del usuario")
            }
        }
    }
    
    func editUserService(username: String, lastname: String, email: String, address: String, phone: String, complete:(successful:Bool)->()){
        
        //Set params
        var ob1 = [nameParam:"USR","Value":userProfile.usr]
        var ob2 = [nameParam:"PASS","Value":userProfile.pass]
        var ob3 = [nameParam:"CLIENTEID","Value":userProfile.clientId]
        var ob4 = [nameParam:"PHONE","Value":phone]
        var ob5 = [nameParam:"NAME","Value":username]
        var ob6 = [nameParam:"LASTNAME","Value":lastname]
        var ob7 = [nameParam:"ADDRESS","Value":address]
        var ob8 = [nameParam:"MAIL","Value":email]
        var ob9 = [nameParam:"PASSWORD","Value":userProfile.password]
        var ob10 = [nameParam:"ID","Value":userProfile.userId]
        var ob11 = [nameParam:"METHOD","Value":"SINGUP"]
        var params = ["GP":[ob1,ob2,ob3,ob4,ob5,ob6,ob7,ob8,ob9,ob10,ob11]]
        
        sharedManager.POST(urlApi, parameters: params, success: { (operation, response) -> () in
            
            //sucessful
            var json = JSON(response)
            println(json)
            
            var gp = json["GP"].arrayValue
            
            for subJson in gp {
                if subJson["Name"].stringValue == "ID" {
                    println(subJson["Value"].stringValue)
                    //Update user
                    self.userProfile.phone = phone
                    self.userProfile.username = username
                    self.userProfile.address = address
                    self.userProfile.lastname = lastname
                    self.userProfile.address = address
                    self.userProfile.mail = email
                }
            }
            
            complete(successful: true)
            
            }) { (operation, error) -> () in
                println(error)
                //error
                complete(successful: false)
            }
     }
}
