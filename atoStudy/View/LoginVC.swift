//
//  ViewController.swift
//  atoStudy
//
//  Created by John Hur on 2023/11/01.
//

import UIKit

enum SnsType {
    case apple
    case kakao
    case naver
    case google
    
    var snsText: String {
        switch self {
        case .apple: return "APPLE"
        case .kakao: return "KAKAO"
        case .naver: return "NAVER"
        case .google: return "GOOGLE"
        }
    }
}

class LoginVC: UIViewController {
    
    let viewModel = SignUpVM()
    
    @IBOutlet weak var appleLoginBtn: UIButton!
    @IBOutlet weak var kakaoLoginBtn: UIButton!
    @IBOutlet weak var naverLoginBtn: UIButton!
    @IBOutlet weak var googleLoginBtn: UIButton!
    
    @IBOutlet weak var recentLoginBackgroundView: UIImageView!
    @IBOutlet weak var recentLoginLabel: UILabel!
    
    
    @IBAction func appleLoginActionButton(_ sender: Any) {
        viewModel.userRequestParam.snsType = SnsType.apple.snsText
        performSegue(withIdentifier: "goToNickNameVC", sender: self)
    }
    
    @IBAction func kakaoLoginActionButton(_ sender: Any) {
        viewModel.userRequestParam.snsType = SnsType.kakao.snsText
        performSegue(withIdentifier: "goToNickNameVC", sender: self)
    }
    
    @IBAction func naverLoginActionButton(_ sender: Any) {
        viewModel.userRequestParam.snsType = SnsType.naver.snsText
        performSegue(withIdentifier: "goToNickNameVC", sender: self)
    }
    
    @IBAction func googleLoginActionButton(_ sender: Any) {
        viewModel.userRequestParam.snsType = SnsType.google.snsText
        performSegue(withIdentifier: "goToNickNameVC", sender: self)
    }
    
    @IBOutlet weak var recentLoginMidX: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        checkRecentLogin()
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNickNameVC" {
            if let signUpNickNameVC = segue.destination as? SignUpNickNameVC {
                signUpNickNameVC.viewModel = self.viewModel
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        checkRecentLogin()
    }
    
    func setUpUI() {
        recentLoginLabel.setLineSpacing(spacing: 2)
        recentLoginLabel.textAlignment = .center
        recentLoginLabel.font = UIFont(name: AtoStudyFont.Regular.font, size: 12)
    }
    

    
    func checkRecentLogin() {
        if ((getSnsType()?.isEmpty) == nil) {
            recentLoginBackgroundView.isHidden = true
            recentLoginLabel.isHidden = true
        } else {
            recentLoginBackgroundView.isHidden = false
            recentLoginLabel.isHidden = false
        }
        
        if getSnsType() == SnsType.apple.snsText {
            recentLoginMidX.constant = 0
        } else if getSnsType() == SnsType.kakao.snsText {
            recentLoginMidX.constant = 72
        } else if getSnsType() == SnsType.naver.snsText {
            recentLoginMidX.constant = 72*2
        } else if getSnsType() == SnsType.google.snsText {
            recentLoginMidX.constant = 72*3
        }
    }

}

