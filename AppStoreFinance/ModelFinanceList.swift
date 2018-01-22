//
//  ModelFinanceList.swift
//  AppStoreFinance
//
//  Created by maccli1 on 2018. 1. 17..
//  Copyright © 2018년 myoung. All rights reserved.
//

import UIKit

class ModelFinanceList: NSObject {
    
    var arrInfo: [Int: [String: Any]] = [:]
    
    init(_ json: [Any]) {
        for (index, element) in json.enumerated() {
            guard let content: [String: Any] = element as? [String: Any] else { return }
            
            var dicTemp: [String: Any] = [:]
            dicTemp["rank"] = index+1 //랭킹
            
            guard let arrIdInfo: [String: Any] = content["id"] as? [String: Any] else { return }
            dicTemp["idInfo"] = arrIdInfo //아이디정보
            
            guard let arrNameInfo: [String: Any] = content["im:name"] as? [String: Any],
                let strAppName: String = arrNameInfo["label"] as? String  else { return }
            dicTemp["appName"] = strAppName //앱 이름
            
            guard let dicTitle: [String: Any] = content["title"] as? [String: Any],
                let strTitle: String = dicTitle["label"] as? String  else { return }
            dicTemp["title"] = strTitle //타이틀
            
            var arrImg: [Int: [String: Any]] = [:]
            guard let imgApp: [Any] = content["im:image"] as? [Any] else { return }
            for temp in imgApp {
                guard let element: [String: Any] = temp as? [String: Any] else { return }
                guard let attribute: [String: Any] = element["attributes"] as? [String: Any],
                    let size: Int = Int((attribute["height"] as? String)!),
                    let strUrl: String = element["label"] as? String else { return }
                
                arrImg[size] = ["img": NSNull(), "url": strUrl]
            }
            dicTemp["imageInfo"] = arrImg //이미지 정보
            
            guard let dicTempCategory: [String: Any] = content["category"] as? [String: Any],
                let dicCategory: [String: Any] = dicTempCategory["attributes"] as? [String: Any] else { return }
            dicTemp["category"] = dicCategory //카테고리
            
            guard let dicArtist: [String: Any] = content["im:artist"] as? [String: Any] else { return }
            dicTemp["artist"] = dicArtist
            
            arrInfo[index] = dicTemp
        }
    }
    
    
    //MARK: ## Getter Method ##
    func getAppNameFromIndex(_ index: Int) -> String { // get App Name
        guard let temp: [String: Any] = arrInfo[index] else { return "" }
        guard let appName: String = temp["appName"] as? String else { return "" }
        return appName        
    }
    
    func getAppRankFromIndex(_ index: Int) -> String { //get App Rank
        guard let temp: [String: Any] = arrInfo[index] else { return "" }
        guard let appRank: Int = temp["rank"] as? Int else { return "" }
        return String(appRank)
    }
    
    func getAppIconImgFromIndex(_ size: Int, index: Int) -> UIImage? { // get download img
        guard let temp: [String: Any] = arrInfo[index] else { return nil }
        guard let appIcon: [Int: [String: Any]] = temp["imageInfo"] as? [Int: [String: Any]] else { return nil }       
        guard let arrImgInfo: [String: Any] = appIcon[size]  else { return nil }
        guard let downImg: UIImage = arrImgInfo["img"] as? UIImage else { return nil }
        return downImg
    }
    
    func getAppIconImgUrlFromIndex(_ size: Int, index: Int) -> String { // get download img url
        guard let temp: [String: Any] = arrInfo[index] else { return "" }
        guard let appIcon: [Int: [String: Any]] = temp["imageInfo"] as? [Int: [String: Any]] else { return "" }
        guard let arrImgInfo: [String: Any] = appIcon[size]  else { return "" }
        guard let downUrl: String = arrImgInfo["url"] as? String else { return "" }
        return downUrl
    }
    
    func getAppCategoryFromIndex(_ index: Int) -> String { // get category name
        guard let temp: [String: Any] = arrInfo[index] else { return "" }
        guard let appCategory: [String: Any] = temp["category"] as? [String: Any] else { return "" }
        guard let category: String = appCategory["label"] as? String else { return "" }
        return category
    }
    
    func getAppIDFromIndex(_ index: Int) -> String { // get App ID
        guard let temp: [String: Any] = arrInfo[index] else { return "" }
        guard let dicAppId: [String: Any] = temp["idInfo"] as? [String: Any] else { return "" }
        guard let dicAttribute: [String: Any] = dicAppId["attributes"] as? [String: Any],
            let id: String = dicAttribute["im:id"] as? String else { return "" }
        return id
    }
    
    func getAppArtistNameFromIndex(_ index: Int) -> String { // get Artist name
        guard let temp: [String: Any] = arrInfo[index] else { return "" }
        guard let dicAppArtist: [String: Any] = temp["artist"] as? [String: Any] else { return "" }
        guard let artistName: String = dicAppArtist["label"] as? String else { return "" }
        return artistName
    }
    
    //MARK: ## Setter Method ##
    func setImgFromIndex(_ size: Int, img: UIImage, index: Int) { // set Download image
        guard var temp: [String: Any] = arrInfo[index] else { return }
        guard var appIcon: [Int: [String: Any]] = temp["imageInfo"] as? [Int: [String: Any]] else { return }
        guard var arrImgInfo: [String: Any] = appIcon[size],
            var dicImgOtherSize: [String: Any] = appIcon[100] else { return }
            
        let iconUrl: String = getAppIconImgUrlFromIndex(100, index: index)
        if let url = URL(string: iconUrl) {
            DispatchQueue.global().async {
                if let urlData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if let iconImage = UIImage(data: urlData) {
                            dicImgOtherSize["img"] = iconImage
                            arrImgInfo["img"] = img
                            appIcon[size] = arrImgInfo
                            appIcon[100] = dicImgOtherSize
                            temp["imageInfo"] = appIcon
                            self.arrInfo[index] = temp
                        }
                    }
                }
            }
        }
    }

}
