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
    var userRequestParam: RegistParam? = RegistParam(snsType: SnsType.apple.snsText, nickname: "", character: 1)
    
    //회원가입 후 유저 응답 정보
    var result: Bool?
    var message: String?
    
    var userSns: String?
    var userNickname: String?
    var userCharacterKo: String?
    
    // 로그아웃 시 유저정보 지우는 함수
    func cleanUserInfo() {
        userRequestParam = nil
        userSns = nil
        userNickname = nil
        userCharacterKo = nil
    }
    
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
    /* MARK: Model Decoding Issue
     회원가입 성공과 실패 Model의 "data" 타입이 달라 다른 모델로 같은 API 두 번 호출
     추후 Error Case RegistModel의 data 영역을 null 값으로 보내면 하나만 호출하도록 변경
     현재 error case의 data에서 String(User nickname)으로 내려오고 있어 이슈 있음.
     */
    func postRegist(canRegist: @escaping (Bool) -> Void) {
        postRegistUser { apiResult in
            if apiResult {
                canRegist(true)
            } else {
                // 디코딩 실패하면 false를 던져 postRegistErrorUser 한 번 더 호출
                self.postRegistErrorUser {
                    canRegist(false)
                }
            }
        }
    }
    
    //MARK: 회원가입 함수
    func postRegistUser(isCompleted: @escaping (Bool) -> Void) {
        guard let param = userRequestParam else { return }
        AtoStudyAPI.postRegist(param: param)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .next(let item):
                    if item.result ?? false {
                        saveSnsType(self?.userRequestParam?.snsType ?? "")
                        
                        self?.userSns = item.data?.snsType ?? ""
                        self?.userNickname = item.data?.nickname ?? ""
                        self?.userCharacterKo = item.data?.characterName ?? ""
                    }
                    self?.result = item.result ?? false
                    self?.message  = item.message ?? ""
                    
                    isCompleted(true)
                case .error(let error):
                    print("Error: \(error.localizedDescription)")
                    // 디코딩 실패하면 false를 던져 postRegistErrorUser 한 번 더 호출
                    isCompleted(false)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    // 회원가입 디코드 에러 났을떄 해당 함수 실행 됨
    func postRegistErrorUser(action: @escaping () -> Void) {
        guard let param = userRequestParam else { return }
        AtoStudyAPI.postRegistError(param: param)
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
