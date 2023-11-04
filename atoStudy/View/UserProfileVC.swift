//
//  UserProfileVC.swift
//  atoStudy
//
//  Created by John Hur on 2023/11/01.
//

import UIKit

class UserProfileVC: UIViewController {
    
    var viewModel: SignUpVM!
    var isNewUser: Bool = false
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var infoBackgroundView: UIView!

    @IBOutlet weak var snsTextLabel: UILabel!
    @IBOutlet weak var snsInfoTextLabel: UILabel!
    
    @IBOutlet weak var nickNameTextLabel: UILabel!
    @IBOutlet weak var nickNameInfoTextLabel: UILabel!
    
    @IBOutlet weak var characterTextLabel: UILabel!
    @IBOutlet weak var characterInfoTextLabel: UILabel!

    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func logoutActionButton(_ sender: Any) {
        showLogoutAlert()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()

        navigationController?.setNavigationBarHidden(true, animated: false)
            
        snsInfoTextLabel.text = viewModel.userSns ?? ""
        nickNameInfoTextLabel.text = viewModel.userNickname ?? ""
        characterInfoTextLabel.text = viewModel.userCharacterKo ?? ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func setUpUI() {
        // 회원가입 API 호출 후 해당 Alert 추가
        if isNewUser {
            showNewUserAlert()
        }
        
        infoBackgroundView.layer.cornerRadius = 8
        logoutButton.layer.cornerRadius = 16
        
        snsTextLabel.font = UIFont(name: AtoStudyFont.Medium.font, size: 14)
        snsTextLabel.textColor = AtoStudyColor.Black800.color
        
        nickNameTextLabel.font = UIFont(name: AtoStudyFont.Medium.font, size: 14)
        nickNameTextLabel.textColor = AtoStudyColor.Black800.color

        characterTextLabel.font = UIFont(name: AtoStudyFont.Medium.font, size: 14)
        characterTextLabel.textColor = AtoStudyColor.Black800.color

        snsInfoTextLabel.font = UIFont(name: AtoStudyFont.Regular.font, size: 14)
        snsInfoTextLabel.textColor = AtoStudyColor.Black900.color
        
        nickNameInfoTextLabel.font = UIFont(name: AtoStudyFont.Regular.font, size: 14)
        nickNameInfoTextLabel.textColor = AtoStudyColor.Black900.color

        characterInfoTextLabel.font = UIFont(name: AtoStudyFont.Regular.font, size: 14)
        characterInfoTextLabel.textColor = AtoStudyColor.Black900.color
        
        //로그아웃 텍스트
        logoutButton.titleLabel?.font = UIFont(name: AtoStudyFont.Bold.font, size: 16.0)
    }
}

extension UserProfileVC {
    func showLogoutAlert(completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "알림", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.navigationController?.popToRootViewController(animated: true)
            completion?()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive) { _ in
            completion?()
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UserProfileVC {
    func showNewUserAlert(completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "알림", message: "회원가입을 축하드립니다!", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

