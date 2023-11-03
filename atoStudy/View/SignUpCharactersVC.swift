//
//  SignUpCharactersVC.swift
//  atoStudy
//
//  Created by John Hur on 2023/11/01.
//

import UIKit
import Kingfisher

class SignUpCharactersVC: UIViewController {
    
    var viewModel: SignUpVM!

    @IBOutlet weak var explainTextLabel: UILabel!
    
    @IBOutlet weak var carouselView: ScalingCarouselView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func doneActionButton(_ sender: Any) {
        viewModel.postRegist { value in
            if value {
                self.performSegue(withIdentifier: "goToUserProfileVC", sender: self)
            } else {
                self.showAlert(message: self.viewModel.message ?? "")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView.delegate = self
        carouselView.dataSource = self
        
        viewModel.getCharacterItems {
            self.carouselView.reloadData()
        }
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        carouselView.deviceRotated()
    }

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUserProfileVC" {
            if let signUpNickNameVC = segue.destination as? UserProfileVC {
                signUpNickNameVC.viewModel = self.viewModel
            }
        }
    }
    
    func setUpUI() {
        let backButton = UIBarButtonItem(image: UIImage(named: "chevron_left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        explainTextLabel.setLineSpacing(spacing: 5)
        explainTextLabel.font = UIFont(name: AtoStudyFont.Medium.font, size: 24.0)
        
        doneButton.layer.cornerRadius = 16.0
        doneButton.titleLabel?.font = UIFont(name: AtoStudyFont.Bold.font, size: 16.0)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SignUpCharactersVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.characterItems.value?.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let scalingCell = cell as? ScalingCarouselCell {
            if let imageUrlString = viewModel.characterItems.value?.data?[indexPath.item].filePath,
               let imageUrl = URL(string: imageUrlString) {
                scalingCell.characterImageView.kf.setImage(with: imageUrl)
            }
            scalingCell.nameTextLabel.text = viewModel.characterItems.value?.data?[indexPath.item].korName ?? ""
        }

        DispatchQueue.main.async {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        return cell
    }
}

extension SignUpCharactersVC: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carouselView.didScroll()
        
        guard let currentCenterIndex = carouselView.currentCenterCellIndex?.row else { return }
        
        if let charSeq = viewModel.characterItems.value?.data?[currentCenterIndex].characterSeq {
            viewModel.characterSeq = charSeq
        }
    }
}

extension SignUpCharactersVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}
 
extension SignUpCharactersVC {
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
            completion?()
        }
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
