//
//  EditViewController.swift
//  Random-User-List
//
//  Created by iMaxiOS on 10/2/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//
import Foundation
import UIKit
import SDWebImage

class EditViewController: UIViewController, UITextFieldDelegate, AlertDisplayer {
    
    //MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var editImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var saveButton: UIBarButtonItem!
    var backButton: UIBarButtonItem!
    
    var viewModel: UsersViewModel?
    
    private var behavior: ButtonEnablingBehavior!
    
    //From UsersVC
    var dataOfUser: User?
    
    //From SavedTVC
    var dataSavedUser: UserOfRealm?
    
    var userDataFromTextFields = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editImageView.layer.cornerRadius = editImageView.frame.width / 2
        editImageView.clipsToBounds = true
        
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(barButtonSaveClicked))
        self.navigationItem.rightBarButtonItem  = saveButton
        
        //Behavior textFields
        behavior = ButtonEnablingBehavior(textFields: [firstNameTextField, lastNameTextField, phoneTextField, emailTextField]) { [unowned self] enable, nameTextField in
            if enable {
                self.saveButton.isEnabled = true
            } else {
                self.saveButton.isEnabled = false
                
                let title = "Attention".localizedString
                let message = "You entered invalid \(nameTextField)"
                let action = UIAlertAction(title: "OK".localizedString, style: .default)
                self.displayAlert(with: title , message: message, actions: [action])
                
            }
        }
        
        //Data acquisition
        firstNameTextField.text = dataOfUser?.first.capitalized            ?? dataSavedUser?.first.capitalized
        lastNameTextField.text = dataOfUser?.last.capitalized              ?? dataSavedUser?.last.capitalized
        phoneTextField.text = dataOfUser?.phone                            ?? dataSavedUser?.phone
        emailTextField.text = dataOfUser?.email                            ?? dataSavedUser?.email
        editImageView.sd_setImage(with: URL(string: (dataOfUser?.thumbnail ?? dataSavedUser?.thumbnail)!))
    }
    
    // MARK: - Navigation unwind
    @IBAction func unwindindEditVC(segue: UIStoryboardSegue) {
        if let savedTableViewController = segue.source as? SavedTableViewController,
            let selectedUserCell = savedTableViewController.infoUnwind {
            dataOfUser = nil
            dataSavedUser = selectedUserCell
        }
    }
    
    //MARK: - Save button
    @objc func barButtonSaveClicked(sender: UIBarButtonItem) {
        if let editImageView = editImageView.sd_imageURL() {
            userDataFromTextFields["thumbnail"] = String(describing: editImageView)
        }
        userDataFromTextFields["first"] = (firstNameTextField.text?.capitalized)
        userDataFromTextFields["last"] = (lastNameTextField.text?.capitalized)
        userDataFromTextFields["phone"] = (phoneTextField.text!)
        userDataFromTextFields["email"] = (emailTextField.text!)
        //Saving
        UserOfRealm.setupUserForRealm(objUser: userDataFromTextFields)
        
        //Push to SavedUserTVC
        navSavedUserTVC()
    }
    
    func navSavedUserTVC() {
        let mainTabController = storyboard?.instantiateViewController(withIdentifier: "mainTabController") as! MainTabController
        mainTabController.selectedViewController = mainTabController.viewControllers?[1]
        
        if navigationController?.tabBarController?.selectedIndex == 1 {
            navigationController?.popViewController(animated: true)
        } else {
            present(mainTabController, animated: true, completion: nil)
        }
    }
    
    //MARK: UITextFieldDelegate
    //Should process the press of the Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    //String length
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 30
    }
    
    //MARK: - KeyboardNotifications
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    @objc func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    deinit {
        removeKeyboardNotifications()
    }
}



