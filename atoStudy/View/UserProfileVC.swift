//
//  UserProfileVC.swift
//  atoStudy
//
//  Created by John Hur on 2023/11/01.
//

import UIKit

class UserProfileVC: UIViewController {
    
    var viewModel: SignUpVM!
    
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
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
            
        snsInfoTextLabel.text = viewModel.userSns ?? ""
        nickNameInfoTextLabel.text = viewModel.userNickname ?? ""
        characterInfoTextLabel.text = viewModel.userCharacterKo ?? ""
        
        setUpUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func setUpUI() {
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
