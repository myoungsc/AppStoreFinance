//
//  ViewController.swift
//  AppStoreFinance
//
//  Created by maccli1 on 2018. 1. 16..
//  Copyright © 2018년 myoung. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var tbFinanceList: UITableView!
    @IBOutlet weak var indiBottom: UIActivityIndicatorView!
    
    @IBOutlet weak var contTbBottom: NSLayoutConstraint!
    
    var mdFinanceList: ModelFinanceList?
    var limit: Int = 50
    var isRefresh: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shadowImage = UIImage()
       
        getFinanceDataFromAppleUrl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ## 버튼 메소드 ##
    @IBAction func btnBackB(_ sender: UIButton) { //뒤로가기 버튼
        print("뒤로가기 버튼")
    }
    
    @IBAction func btnCategoryB(_ sender: UIButton) { //카테고리 버튼
        print("카테고리 버튼")
    }
    
    //MARK: ## 서버 통신 메소드 ##
    func getFinanceDataFromAppleUrl() { //Get Data from apple url
        let url = URL(string: "https://itunes.apple.com/kr/rss/topfreeapplications/limit=\(limit)/genre=6015/json")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            var json: [String : Any]?
            do {
                json = try JSONSerialization.jsonObject(with: data!) as? [String : Any]
            } catch {
                print(error)
            }
            guard let jsonTemp: [String: Any] = json else { return }
            guard let jsonFeed: [String: Any] = jsonTemp["feed"] as? [String: Any] else { return }
            guard let jsonEntry: [Any] = jsonFeed["entry"] as? [Any] else { return }
            self.mdFinanceList = ModelFinanceList(jsonEntry)
            
            DispatchQueue.main.async {
                if self.indiBottom.isAnimating {
                    self.contTbBottom.constant = 0.0
                    self.indiBottom.stopAnimating()
                    self.indiBottom.isHidden = true
                    self.isRefresh = false
                }                
                self.tbFinanceList.reloadData()
            }
        }
        task.resume()
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index: Int = sender as? Int else { return }
        if let id: String = mdFinanceList?.getAppIDFromIndex(index),
            let appTitle: String = mdFinanceList?.getAppNameFromIndex(index),
            let appArtist: String =  mdFinanceList?.getAppArtistNameFromIndex(index),
            let appCategory: String = mdFinanceList?.getAppCategoryFromIndex(index) {
            
            let vcAppDetail = segue.destination as! VcAppDetail
            vcAppDetail.appID = id
            vcAppDetail.previewImg = mdFinanceList?.getAppIconImgFromIndex(100, index: index)            
            vcAppDetail.appTitle = appTitle
            vcAppDetail.appSubTitle = appArtist
            vcAppDetail.category = appCategory
            vcAppDetail.appRank = "#\(index+1)"
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cellCount: Int = mdFinanceList?.arrInfo.count else {
            indiBottom.isHidden = true
            return 0
        }
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellFinanceList
        cell.ivIcon.image = UIImage()
        
        if let iconImg: UIImage = mdFinanceList?.getAppIconImgFromIndex(75, index: indexPath.row) {
            cell.ivIcon.image = iconImg
        } else {
            if let iconUrl: String = mdFinanceList?.getAppIconImgUrlFromIndex(75, index: indexPath.row) {
                if let url = URL(string: iconUrl) {
                    DispatchQueue.global().async {
                        if let urlData = try? Data(contentsOf: url) {
                            DispatchQueue.main.async {
                                if let iconImage = UIImage(data: urlData) {
                                    cell.ivIcon.image = iconImage
                                    self.mdFinanceList?.setImgFromIndex(75, img: iconImage, index: indexPath.row)
                                }
                            }
                        }
                    }
                }
            }            
        }
        cell.lbRank.text = mdFinanceList?.getAppRankFromIndex(indexPath.row)
        cell.lbtitle.text = mdFinanceList?.getAppNameFromIndex(indexPath.row)
        cell.lbSummary.text = mdFinanceList?.getAppCategoryFromIndex(indexPath.row)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SegueAppDetail", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            if !isRefresh && limit < 200 {
                limit += 50
                isRefresh = true
                contTbBottom.constant = 40
                indiBottom.isHidden = false
                indiBottom.startAnimating()
                getFinanceDataFromAppleUrl()
            }
        }
    }
}

