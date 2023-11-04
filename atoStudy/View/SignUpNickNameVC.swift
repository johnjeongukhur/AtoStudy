//
//  SignUpNickNameVC.swift
//  atoStudy
//
//  Created by John Hur on 2023/11/01.
//

import UIKit

class SignUpNickNameVC: UIViewController {
    
    var viewModel: SignUpVM!
    
    @IBOutlet weak var explainTextLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var nickNameBottomLine: UIView!
    
    @IBOutlet weak var textFieldRemoveButton: UIButton!
    
    @IBOutlet weak var cautionTextLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func textFieldRemoveActionButton(_ sender: Any) {
        clearNicknameTextField()
    }
    
    @IBAction func nextActionButton(_ sender: Any) {
        if let nickname = nickNameTextField.text, isNicknameValid(nickname) {
            viewModel.userRequestParam?.nickname = nickname
            performSegue(withIdentifier: "goToCharacterVC", sender: self)
        } else {
            cautionTextLabel.isHidden = false
            cautionTextAnimation()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nickNameTextField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setUpUI() {
        let backButton = UIBarButtonItem(image: UIImage(named: "chevron_left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        explainTextLabel.setLineSpacing(spacing: 5)
        explainTextLabel.font = UIFont(name: AtoStudyFont.Medium.font, size: 24.0)
        
        nickNameBottomLine.backgroundColor = AtoStudyColor.Black400.color
        
        textFieldRemoveButton.isHidden = true
        
        cautionTextLabel.isHidden = true
        cautionTextLabel.font = UIFont(name: AtoStudyFont.Regular.font, size: 12.0)
        cautionTextLabel.textColor = AtoStudyColor.Primary900.color
        
        nextButton.layer.cornerRadius = 16.0
        nextButton.titleLabel?.font = UIFont(name: AtoStudyFont.Bold.font, size: 16.0)
    }

    //Navigation Back button
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCharacterVC" {
            if let signUpNickNameVC = segue.destination as? SignUpCharactersVC {
                signUpNickNameVC.viewModel = self.viewModel
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nickNameTextField)
    }

    @objc func textFieldDidChange(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            if let text = self.nickNameTextField.text, !text.isEmpty {
                self.nickNameBottomLine.backgroundColor = AtoStudyColor.Primary900.color
                self.textFieldRemoveButton.isHidden = false
                
                if let nickname = self.nickNameTextField.text, self.isNicknameValid(nickname) {
                    self.nextButton.backgroundColor = AtoStudyColor.Primary900.color
                    self.cautionTextLabel.isHidden = true
                } else {
                    self.nextButton.backgroundColor = AtoStudyColor.Black500.color
                    self.cautionTextLabel.isHidden = false
                }
            } else {
                self.nickNameBottomLine.backgroundColor = AtoStudyColor.Black400.color
                self.textFieldRemoveButton.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var nextButtonBottomAnchor: NSLayoutConstraint!
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height-15, right: 0.0)
            
            UIView.animate(withDuration: 0.3) {
                self.nextButtonBottomAnchor.constant = contentInsets.bottom
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.nextButtonBottomAnchor.constant = 40.0
        }
    }
    
    func clearNicknameTextField() {
        UIView.animate(withDuration: 0.3) {
            self.nickNameTextField.text = ""
            self.nickNameBottomLine.backgroundColor = AtoStudyColor.Black400.color
            self.textFieldRemoveButton.isHidden = true
            self.nextButton.backgroundColor = AtoStudyColor.Black500.color
        }
    }
    
    func cautionTextAnimation() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.cautionTextLabel.transform = CGAffineTransform(translationX: 5, y: 0)
        }, completion: nil)
        
        //Stop Animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * 6) {
            self.cautionTextLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            self.cautionTextLabel.layer.removeAllAnimations()
        }
    }
    
    // 닉네임 유효성 체크
    func isNicknameValid(_ nickname: String) -> Bool {
        let regex = "^[가-힣a-zA-Z0-9]{2,12}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: nickname)
    }

    
    
}
