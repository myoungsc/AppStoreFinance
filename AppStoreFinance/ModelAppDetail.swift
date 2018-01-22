//
//  ModelAppDetail.swift
//  AppStoreFinance
//
//  Created by maccli1 on 2018. 1. 17..
//  Copyright © 2018년 myoung. All rights reserved.
//

import UIKit

class ModelAppDetail: NSObject {
    
    var dicContent: [String: Any] = [:]
    var screenShotCount: Int = 0, supportRanguageCount: Int = 0
    let arrStarReminder: [UIImage] = [ UIImage(named: "star_gray")!,
                                       UIImage(named: "star20_gray")!,
                                       UIImage(named: "star40_gray")!,
                                       UIImage(named: "star60_gray")!,
                                       UIImage(named: "star80_gray")! ]
    
    init(_ json: [String: Any]) { //init method
        guard let content: [Any] = json["results"] as? [Any] else { return }
        for element in content {
            dicContent = (element as? [String: Any])!
        }
        print(dicContent)
    }
    
    //MARK: ## Get Method ##
    func getTrackContentRating() -> String { //나이 정보 받아오기
        guard let rating: String = dicContent["trackContentRating"] as? String else { return "" }
        return rating        
    }
    
    func getReleaseNoteAndOtherData() -> [Any] { //릴리즈 노트 여부에 따라 데이터 결정
        guard let releaseNote: String = dicContent["releaseNotes"] as? String else { return [false] }
        guard let releaseVesion: String = dicContent["version"] as? String else { return [false] }
        guard let releaseDate: String = dicContent["currentVersionReleaseDate"] as? String else { return [false] }
        
        let interval = funcReleaseDateCaculator(releaseDate)
        return [true, "버전 " + releaseNote, releaseVesion, interval]
    }
    
    func getScreenShotUrlArr() -> [String] { //스크린샷 이미지 Array 보내기
        guard let arrScreenShot: [String] = dicContent["screenshotUrls"] as? [String] else { return [] }
        screenShotCount = arrScreenShot.count
        return arrScreenShot
    }
    
    func getDescriptionLineThree() -> String { // 라인 3줄 설명 받아오기
        guard let description: String = dicContent["description"] as? String else { return "" }
        let arrDesComponents = description.components(separatedBy: "\n")
        var returnDes: String = "", count: Int = 0
        for element in arrDesComponents {
            if element != "" {
                returnDes += element + "\n"
                count += 1
                if count == 3 { break }
            }
        }
        return returnDes
    }
    
    func getFullDescription() -> String { //전체 설명 받아오기
        guard let description: String = dicContent["description"] as? String else { return "" }
        return description
    }
    
    func getRatingInfo() -> (average: String, count: String) { // 평균 점수, 리뷰 갯수 받아오기
        guard let average: Double = dicContent["averageUserRating"] as? Double else { return (average: "", count: "") }
        guard let userRatingCount: Int = dicContent["userRatingCount"] as? Int else { return (average: "", count: "") }
        let ratingCount: String = "\(userRatingCount)개의 평가"
        return (average: "\(average)", count: ratingCount)
    }
    
    func getSellerUrl() -> String { // 개발자 웹사이트 받아오기
        guard let sellerUrl: String = dicContent["sellerUrl"] as? String else { return "" }
        return sellerUrl
    }
    
    func getAppInfo() -> (sellerName: String, fileSizeBytes: String) { // 판매자 이름, 파일 사이즈
        guard let sellerName: String = dicContent["sellerName"] as? String else { return ("", "") }
        guard let fileSizeBytes: String = dicContent["fileSizeBytes"] as? String else { return ("", "") }
        var fileSizeMB: Double = Double(fileSizeBytes)! / 1000 / 1000
        return (sellerName: sellerName, fileSizeBytes: "\(fileSizeMB.roundToPlaces(1))MB")
    }
    
    func getSupportRanguage(_ isFull: Bool) -> String { //languageCodesISO2A 취급언어
        guard let arrLanguageCode: [String] = dicContent["languageCodesISO2A"] as? [String] else { return "" }
        supportRanguageCount = arrLanguageCode.count
        if isFull { //전체 다 보내줄때
            var strFullRanguage: String = ""
            for (i, element) in arrLanguageCode.enumerated() {
                if i == arrLanguageCode.count - 1 {
                    strFullRanguage += funcRanguageCodeToString(element)
                } else {
                    strFullRanguage += funcRanguageCodeToString(element) + ", "
                }
            }
            return strFullRanguage
        } else { // 하나 또는 두개이상일때
            if arrLanguageCode.count == 1 {
                return funcRanguageCodeToString(arrLanguageCode[0])
            } else {
                return "\(funcRanguageCodeToString(arrLanguageCode[0])) 및 \(funcRanguageCodeToString(arrLanguageCode[1]))"
            }
        }
    }
    
    func getSupportVersionAndDevice() -> String { //버전 및 호환 기기
        guard let minimumOsVersion: String = dicContent["minimumOsVersion"] as? String else { return "" }
        guard let arrSupportedDevices: [String] = dicContent["supportedDevices"] as? [String] else { return "" }
        let currentDevice = UIDevice.current.model
        var strDes: String = "iOS \(minimumOsVersion) 버전 이상이 필요. \(currentDevice),"
        var supportDevice: [String] = []
        for element in arrSupportedDevices {
            if element.contains("iPhone") && currentDevice != "iPhone" {
                if !supportDevice.contains("iPhone") {
                    supportDevice.append("iPhone")
                }
            } else if element.contains("iPodTouch") && currentDevice != "iPod touch"{
                if !supportDevice.contains("iPodTouch") {
                    supportDevice.append("iPodTouch")
                }
            } else if element.contains("iPad") && currentDevice != "iPad" {
                if !supportDevice.contains("iPad") {
                    supportDevice.append("iPad")
                }
            }
        }
        for (index, element) in supportDevice.enumerated() {
            if index == supportDevice.count - 1 {
                strDes += element + "와(과) 호환"
                break
            }
            strDes += element + " 및 "
        }        
        return strDes
    }
    
    func getRatingStarCaculator() -> (first: Int, secondImg: UIImage) { // 레이팅 점수 계산해주기
        guard let ratingScore = Double(getRatingInfo().average) else { return (0, UIImage()) }
        let firstItem = Int(ratingScore / 1.0)
        let secondItem = Int((ratingScore - Double(firstItem)) / 0.2)        
        return (first: firstItem, secondImg: arrStarReminder[secondItem])
    }
    
    //MARK: ## 기타 메소드 ##
    func funcReleaseDateCaculator(_ dtDay: String) -> String{
        //2018-01-13T02:10:00Z
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let returnDate: Date = dateFormatter.date(from: dtDay) else { return "" }
        let date_current = Date()
        let cal = Calendar.current
        let c1 = (cal as NSCalendar).components([.day, .hour, .minute], from:returnDate, to:date_current, options:[])
        if c1.day! < 8 {
            if c1.day == 0 {
                if c1.hour == 0 {
                    if c1.minute == 0 {
                        return "방금 전"
                    }else {
                        return "\(c1.minute!)분 전"
                    }
                } else {
                    return "\(c1.hour!)시간 전"
                }
            }else {
                return "\(c1.day!)일 전"
            }
        } else {
            let week = c1.day! / 7
            if week < 5 {
                return "\(week)주 전"
            } else {
                let month = c1.day! / 31
                return "\(month)개월 전"
            }
        }
    }
    
    func funcRanguageCodeToString(_ code: String) -> String { // 코드를 설명으로 변경
        switch code {
        case "KO": return "한국어"
        case "EN": return "영어"
        case "JA": return "일본어"
        case "PT": return "포루투갈어"
        case "RU": return "러시아어"
        case "ZH": return "중국어"
        case "ES": return "스페인어"
        default: return ""
        }
    }    
}

extension Double {
    mutating func roundToPlaces(_ places:Int) -> Double { // 소수점 자리수에 맞춰서 반올림하기
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}
