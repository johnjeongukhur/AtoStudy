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
    var snsType: SnsType?
    var nickname: String?
    var characterSeq: Int?
    
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
    
    // 회원가입 성공과 실패 Model의 "data" 타입이 달라 다른 모델 두번 호출
    // 추후 Error Case RegistModel의 data 영역을 null 값으로 보내면 하나만 호출하도록 변경
    func postRegist(action: @escaping () -> Void) {
        postRegistUser {
            action()
        }
        postRegistErrorUser {
            action()
        }
    }
    
    //TODO: 회원가입 함수 지정
    func postRegistUser(action: @escaping () -> Void) {
        AtoStudyAPI.postRegist(param: RegistParam(snsType: snsType?.snsText ?? "", nickname: nickname ?? "", character: characterSeq ?? 1))
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .next(let item):
                    if item.result ?? false {
                        saveSnsType(self?.snsType?.snsText ?? "")
                        
                        self?.userSns = item.data?.snsType ?? ""
                        self?.userNickname = item.data?.nickname ?? ""
                        self?.userCharacterKo = item.data?.characterName ?? ""
                    }
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
    
    func postRegistErrorUser(action: @escaping () -> Void) {
        AtoStudyAPI.postRegistError(param: RegistParam(snsType: snsType?.snsText ?? "", nickname: nickname ?? "", character: characterSeq ?? 1))
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] event in
                switch event {
                case .next(let item):
//                    if item.result ?? false {
//                        saveSnsType(self?.snsType?.snsText ?? "")
//
//                    } else {
//                        //TODO: 실패 Alert 띄우기
//                        print("\(item)")
//                    }
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
