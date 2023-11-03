//
//  AtoStudyAPI.swift
//  atoStudy
//
//  Created by John Hur on 2023/11/01.
//

import Foundation
import Alamofire
import RxSwift

enum AtoStudyAPI {
    static let baseURL = URL(string: "https://code.millionz.kr/api/ato/test/")!
    
    static let token = "Bearer " + "AtoStudy10_Lp!S7vN1e@XyJ&2oBw"
    
    static func headers() -> HTTPHeaders {
        return [
            "Authorization": "\(token)",
//            "Content-Language": "ko",
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
    }
}

extension AtoStudyAPI {
    static private func makeRequest<T: Codable>(_ url: URL, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?) -> Observable<T> {
        return Observable.create { observer in
            let request = AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    static func post<T: Decodable, P: Encodable>(_ url: URL, jsonParameters: P, method: HTTPMethod, headers: HTTPHeaders?) -> Observable<T> {
        let encoder = JSONEncoder()
        guard let jsonData = try? encoder.encode(jsonParameters) else {
            return Observable.error(APIError.invalidJSON)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        return Observable.create { observer in
            let dataRequest = AF.request(request)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        
                        
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }

    
    
    
    static func get<T: Codable>(_ url: URL) -> Observable<T> {
        return makeRequest(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: AtoStudyAPI.headers())
    }
    
//    static func post<T: Decodable>(_ url: URL, parameters: [String: Any]) -> Observable<T> {
//        return makeRequest(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: AtoStudyAPI.headers())
//    }
    
//    static func post<P: Codable>(_ url: URL, parameters: [String: Any]) -> Observable<P> {
//        return makeRequest(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: AtoStudyAPI.headers())
//    }


    
}

extension AtoStudyAPI {
    static let characteUrl = "character"
    static let registUrl = "regist"
    
    static func getCharacter() -> Observable<CharacterModel> {
        return get(baseURL.appendingPathComponent(characteUrl))
    }
    
    static func postRegist(param: RegistParam) -> Observable<RegistModel> {
        return post(baseURL.appendingPathComponent(registUrl), jsonParameters: param, method: .post, headers: AtoStudyAPI.headers())
    }
    
    static func postRegistError(param: RegistParam) -> Observable<RegistErrorModel> {
        return post(baseURL.appendingPathComponent(registUrl), jsonParameters: param, method: .post, headers: AtoStudyAPI.headers())
    }
}

struct RegistParam: Codable {
    var snsType: String
    var nickname: String
    var character: Int
}

enum APIError: Error {
    case invalidJSON
}
