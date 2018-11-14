//
//  RegisterViewController.swift
//  GG Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import Photos

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var profilePhotoButton: UIButton!
    @IBOutlet var agreeSwitch: UISwitch!
    
    var index = 0
    
    //var imagePicker = UIImagePickerController()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "b1b9c1")
        
        //imagePicker.delegate = self
        
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: segue to go to chat page
    func goToCategories(action: UIAlertAction) {
        self.performSegue(withIdentifier: "goToCategories", sender: self)
    }
  
    
    
    // MARK: email address validation
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    // MARK: password validation
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
//         at least one uppercase,
//         at least one digit
//         at least one lowercase
//         8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    
    
    // MARK: action of pressing register button
    @IBAction func registerPressed(_ sender: AnyObject) {
        //SVProgressHUD.show()
        
        if isValidEmail(testStr: emailTextfield.text!) != true || isValidPassword(testStr: passwordTextfield!.text) != true || self.index != 1
                {
                    let registerAlert = UIAlertController(title: "Registration error!", message: "Please check your email or password, make sure you've chosen a profile photo and agreed the End-User License Agreement. The password must contain: at least one uppercase, at least one lowercase, at least one digitand and 8 characters at least.", preferredStyle: .alert)
                    registerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(registerAlert, animated: true)
                }
        
        else {
            
                        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
                            
                            if error != nil
                            {
                                print(error!)
                                
                                let alert1 = UIAlertController(title: "User already exist.", message: nil, preferredStyle: .alert)
                                alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert1, animated: true)
                                
                            }
                            else
                            {
                                        print("Registration Successful!")
                                
                                        // create a database child and upload each UserId to it.
                                        let userDB = Database.database().reference().child("UserIds")
                                        let userDictionary = ["userId": self.emailTextfield.text!]
                                
                                        userDB.childByAutoId().setValue(userDictionary) {
                                            (error, reference) in
                                            
                                            if error != nil {
                                                print(error!)
                                            }
                                            else {
                                                print("UserId saved successfully!")
                                            }
                                            
                                        }
                                
                                        let alert2 = UIAlertController(title: "Registration Successful!", message: nil, preferredStyle: .alert)
                                        alert2.addAction(UIAlertAction(title: " Let's go to GG Chat", style: .default, handler: self.goToCategories))
                                        self.present(alert2, animated: true)
                                
                                        }
                                
                            
                            }
            
            
            }
    }
    

    
    
   
    
    
    
    @IBAction func agreeSwitchChanged(_ sender: Any) {
        if self.agreeSwitch.isOn == true {
            index = 1
        }
        else {
            index = 0
        }
    }
    
    
    
    
   
    
}



