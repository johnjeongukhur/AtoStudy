//
//  LoginVM.swift
//  atoStudy
//
//  Created by John Hur on 2023/11/01.
//

import Foundation
import RxSwift
import RxRelay

class SignUpVM {
    
    let disposeBag = DisposeBag()
    
    var characterItems = BehaviorRelay<CharacterModel?>(value: nil)
    
    //회원가입 요청 정보
    var userRequestParam: RegistParam = RegistParam(snsType: SnsType.apple.snsText, nickname: "", character: 1)
    
    //회원가입 후 유저 응답 정보
    var result: Bool?
    var message: String?
    
    var userSns: String?
    var userNickname: String?
    var userCharacterKo: String?
    
    // Get Character func
    func getCharacterItems(action: @escaping () -> Void) {
        AtoStudyAPI.getCharacter()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .next(let item):
                    if item.result ?? false {
                        self?.characterItems.accept(item)
                    } else {
                        //TODO: 실패 Alert 띄우기
                    }
                    
                    action()
                case .error(let error):
                    print("Error: \(error.localizedDescription)")
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    // 회원가입 성공과 실패 Model의 "data" 타입이 달라 다른 모델로 같은 API 두 번 호출
    // 추후 Error Case RegistModel의 data 영역을 null 값으로 보내면 하나만 호출하도록 변경
    func postRegist(action: @escaping (Bool) -> Void) {
        postRegistUser { apiResult in
            if apiResult {
                print("가입 성공")
                action(true)
            } else {
                // 디코딩 실패하면 false를 던져 postRegistErrorUser 한 번 더 호출
                self.postRegistErrorUser {
                    action(false)
                }
            }
        }
    }
    
    //MARK: 회원가입 함수
    func postRegistUser(action: @escaping (Bool) -> Void) {
        AtoStudyAPI.postRegist(param: userRequestParam)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .next(let item):
                    if item.result ?? false {
                        saveSnsType(self?.userRequestParam.snsType ?? "")
                        
                        self?.userSns = item.data?.snsType ?? ""
                        self?.userNickname = item.data?.nickname ?? ""
                        self?.userCharacterKo = item.data?.characterName ?? ""
                    }
                    self?.result = item.result ?? false
                    self?.message  = item.message ?? ""
                    
                    action(true)
                case .error(let error):
                    print("Error: \(error.localizedDescription)")
                    // 디코딩 실패하면 false를 던져 postRegistErrorUser 한 번 더 호출
                    action(false)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    func postRegistErrorUser(action: @escaping () -> Void) {
        AtoStudyAPI.postRegistError(param: userRequestParam)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .next(let item):
                    self?.result = item.result ?? false
                    self?.message  = item.message ?? ""
                    action()
                case .error(let error):
                    print("Error: \(error.localizedDescription)")
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}
