//
//  AppDetail.swift
//  AppStoreFinance
//
//  Created by maccli1 on 2018. 1. 17..
//  Copyright © 2018년 myoung. All rights reserved.
//

import UIKit

class VcAppDetail: UIViewController {
    
    @IBOutlet weak var ivNaviIcon: UIImageView!
    @IBOutlet weak var btnNaviRight: UIButton!
    @IBOutlet weak var scContent: UIScrollView!
    @IBOutlet weak var ivIconImg: UIImageView!
    @IBOutlet weak var btnDown: UIButton!
    @IBOutlet weak var btnEtc: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var lbAverageTopRating: UILabel!
    @IBOutlet weak var lbAllTopRatingCount: UILabel!
    @IBOutlet weak var viewInfoAppDetail: UIView!
    @IBOutlet weak var lbRank: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbAge: UILabel!
    @IBOutlet weak var lbAgeDes: UILabel!
    @IBOutlet weak var viewVersion: UIView!
    @IBOutlet weak var lbRecentVersion: UILabel!
    @IBOutlet weak var lbRecentUpdateDay: UILabel!
    @IBOutlet weak var tvReleaseNote: UITextView!
    @IBOutlet weak var scPreview: UIScrollView!
    @IBOutlet weak var tvSummary: UITextView!
    @IBOutlet weak var lbDeveloper: UILabel!
    @IBOutlet weak var btnSeeAllReview: UIButton!
    @IBOutlet weak var lbAverageRating: UILabel!
    @IBOutlet weak var lbRatingCount: UILabel!
    @IBOutlet weak var ivRatingCrown: UIImageView!
    @IBOutlet weak var lbBestRating: UILabel!
    @IBOutlet weak var lbNotRatingDes: UILabel!
    @IBOutlet weak var viewAppInfo: UIView!
    @IBOutlet weak var lbSellerName: UILabel!
    @IBOutlet weak var lbFileSize: UILabel! 
    @IBOutlet weak var lbInfoCategory: UILabel!
    @IBOutlet weak var lbInfoAge: UILabel!
    @IBOutlet weak var lbInfoRanguageDes: UILabel!
    @IBOutlet weak var lbInfoRanguage: UILabel!
    @IBOutlet weak var ivInfoRanguageArrow: UIImageView!
    @IBOutlet weak var lbInfoSupportDes: UILabel!
    @IBOutlet weak var lbInfoSupport: UILabel!
    @IBOutlet weak var ivInfoSupport: UIImageView!
    @IBOutlet weak var contVersionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contVersionTextviewHeight: NSLayoutConstraint!
    @IBOutlet weak var contTvSummaryHeight: NSLayoutConstraint!
    @IBOutlet weak var contSummaryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contRatingViewHeight: NSLayoutConstraint!    
    @IBOutlet weak var contInfoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contRanguageHeight: NSLayoutConstraint!
    @IBOutlet weak var contRanguageArrowRight: NSLayoutConstraint!   
    @IBOutlet weak var contSupportDesHeight: NSLayoutConstraint!
    @IBOutlet weak var contSupportArrow: NSLayoutConstraint!
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var appID: String = "", appTitle: String = "", appSubTitle: String = "", category: String = "", appRank: String = ""
    var previewImg: UIImage?, arrPreviewImg: [Int :UIImage] = [:]
    var mdAppDetail: ModelAppDetail?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ## Init 메소드 ##
    func initMainView() {
        ivNaviIcon.image = previewImg
        ivNaviIcon.layer.cornerRadius = 5.0
        ivNaviIcon.layer.borderWidth = 0.5
        ivNaviIcon.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        ivNaviIcon.layer.masksToBounds = true
        
        btnNaviRight.layer.cornerRadius = btnNaviRight.frame.size.width/5.0
        
        ivIconImg.layer.cornerRadius = 10.0
        ivIconImg.layer.borderWidth = 0.5
        ivIconImg.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
        ivIconImg.layer.masksToBounds = true
        ivIconImg.image = previewImg
        
        btnDown.layer.cornerRadius = btnDown.frame.size.width/5.0
        btnEtc.layer.cornerRadius = btnEtc.frame.size.width/2.0
        
        print(appTitle)
        print(appSubTitle)
        
        lbTitle.text = appTitle
        lbSubTitle.text = appSubTitle
        lbRank.text = appRank
        lbCategory.text = category
        
        tvReleaseNote.textContainer.lineFragmentPadding = 0
        tvReleaseNote.textContainerInset = .zero
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tvTapGesture(_:)))
        tvReleaseNote.addGestureRecognizer(tapGesture)
        
        tvSummary.textContainer.lineFragmentPadding = 0
        tvSummary.textContainerInset = .zero
        let tapSummaryGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tvSummaryGesture(_:)))
        tvSummary.addGestureRecognizer(tapSummaryGesture)
        
        getFinanceAppDetailDataFromAppleUrl()
    }
    
    //MARK: ## 버튼 메소드 ##
    @IBAction func btnBackB(_ sender: UIButton) { //뒤로가기
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnVersionB(_ sender: UIButton) { //버전기록
        print("버전 기록")
    }
    
    @IBAction func btnDeveloperB(_ sender: UIButton) { //개발자 정보
        print("개발자 정보")
    }
    
    @IBAction func btnSeeAllReviewB(_ sender: UIButton) { //모든 리뷰 보기
        print("리뷰 보기")
    }
    
    @IBAction func btnNaviAppDownB(_ sender: UIButton) { //상단바 받기 버튼
        print("받기 버튼")
    }
    
    @IBAction func btnSellerWebSiteB(_ sender: UIButton) { //개발자 사이트로 이동
        if let strSellerUrl: String = mdAppDetail?.getSellerUrl() {
            if let reviewURL = URL(string: strSellerUrl), UIApplication.shared.canOpenURL(reviewURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(reviewURL)
                }
            }
        }
    }
    
    @IBAction func btnSupportB(_ sender: UIButton) { //호환성 펼치기
        if contSupportDesHeight.constant < 15.0 {
            lbInfoSupport.isHidden = true
            ivInfoSupport.isHidden = true
            if let support: String = mdAppDetail?.getSupportVersionAndDevice() { //언어 정보
                let attr: NSMutableAttributedString = NSMutableAttributedString(string: "호환성\n\n\(support)")
                attr.addAttributes([.foregroundColor: UIColor.lightGray], range: NSMakeRange(0, 2))
                attr.addAttributes([.foregroundColor: UIColor.black], range: NSMakeRange(5, support.count))
                lbInfoSupportDes.attributedText = attr
            }
            let fLabelSize = lbInfoSupportDes.sizeThatFits(lbInfoSupportDes.bounds.size)
            contInfoViewHeight.constant += fLabelSize.height
            contSupportDesHeight.constant = fLabelSize.height
        }
    }
    
    @IBAction func btnRanguageB(_ sender: UIButton) { //언어 펼치기        
        if (mdAppDetail?.supportRanguageCount)! > 2 {
            lbInfoRanguage.isHidden = true
            ivInfoRanguageArrow.isHidden = true
            if let ranguage: String = mdAppDetail?.getSupportRanguage(true) { //언어 정보
                let attr: NSMutableAttributedString = NSMutableAttributedString(string: "언어\n\n\(ranguage)")
                attr.addAttributes([.foregroundColor: UIColor.lightGray], range: NSMakeRange(0, 2))
                attr.addAttributes([.foregroundColor: UIColor.black], range: NSMakeRange(4, ranguage.count))
                lbInfoRanguageDes.attributedText = attr
            }
            let fLabelSize = lbInfoRanguageDes.sizeThatFits(lbInfoRanguageDes.bounds.size)
            contInfoViewHeight.constant += fLabelSize.height
            contRanguageHeight.constant = fLabelSize.height
        }
    }
    
    //MARK: ## 제스쳐 메소드 ##    
    @objc func tvTapGesture(_ recognizer: UITapGestureRecognizer) { //버전기록 탭제스쳐
        let fTvHeight = tvReleaseNote.sizeThatFits(tvReleaseNote.frame.size)        
        if fTvHeight.height > 45 && contVersionTextviewHeight.constant < fTvHeight.height {
            contVersionViewHeight.constant += (fTvHeight.height-45)
            contVersionTextviewHeight.constant = fTvHeight.height
        }
    }
    
    @objc func tvSummaryGesture(_ recognizer: UITapGestureRecognizer) { //설명 탭 제스쳐
        if let description: String = mdAppDetail?.getFullDescription(){
            tvSummary.text = description
            let fTvHeight = tvSummary.sizeThatFits(tvSummary.frame.size)
            if fTvHeight.height > 45 && contTvSummaryHeight.constant < fTvHeight.height {
                contSummaryViewHeight.constant += (fTvHeight.height-45)
                contTvSummaryHeight.constant = fTvHeight.height
            }            
        }
    }
    
    @objc func tapImgGesture(_ recognizer: UITapGestureRecognizer) { // 스크린샷 클릭시
        let vc: VcAppPreviewImgDetail = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VcAppPreviewImgDetail") as! VcAppPreviewImgDetail
        vc.arrImgs = arrPreviewImg
        vc.iClickIndex = (recognizer.view?.tag)! - 300
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: ## 기타 메소드 ##
    func getFinanceAppDetailDataFromAppleUrl() { // Get App Detail Data From Apple Server
        
        if let url : URL = URL(string: "https://itunes.apple.com/lookup?id=\(appID)&country=kr") {
            do {
                let data = try Data(contentsOf: url)
                var json: [String : Any]?
                do {
                    json = try JSONSerialization.jsonObject(with: data) as? [String : Any]
                } catch {
                    print(error)
                }
                guard let jsonResult: [String: Any] = json else { return }
                mdAppDetail = ModelAppDetail(jsonResult)
                DispatchQueue.main.async {
                    self.setViewContent()
                }
            } catch {
                print(error)
            }
        }        
    }
    
    func setViewContent() {
        lbAge.text = mdAppDetail?.getTrackContentRating() //연령
        if let releaseInfo: [Any] = mdAppDetail?.getReleaseNoteAndOtherData() {
            if let isInfo: Bool = releaseInfo[0] as? Bool, isInfo == true {
                guard let note: String = releaseInfo[1] as? String else { return }
                guard let version: String = releaseInfo[2] as? String else { return }
                guard let day: String = releaseInfo[3] as? String else { return }
                
                lbRecentVersion.text = "버전 " + version
                lbRecentUpdateDay.text = day
                
                tvReleaseNote.text = "\(note.dropFirst(3))"
                let fTvHeight = tvReleaseNote.sizeThatFits(tvReleaseNote.frame.size)
                if fTvHeight.height < 45 {
                    contVersionViewHeight.constant -= (45-fTvHeight.height)
                    contVersionTextviewHeight.constant = fTvHeight.height
                }
            } else {
                viewVersion.isHidden = true
                contVersionViewHeight.constant = 0.0
            }
            
            if let arrScreenShot: [String] = mdAppDetail?.getScreenShotUrlArr() { //이미지 스크린샷
                let scPreviewSize = scPreview.sizeThatFits(scPreview.frame.size)
                var fx: CGFloat = 20, fWidth: CGFloat = (scPreviewSize.width-60)*0.7
                for (index, element) in arrScreenShot.enumerated() {
                    let ivScreenShot: UIImageView = UIImageView(frame: CGRect(x: fx, y: 0, width: fWidth, height: scPreviewSize.height))
                    ivScreenShot.layer.cornerRadius = 10.0
                    ivScreenShot.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
                    ivScreenShot.layer.borderWidth = 0.5
                    ivScreenShot.layer.masksToBounds = true
                    ivScreenShot.isUserInteractionEnabled = true
                    ivScreenShot.tag = index+300
                    ivScreenShot.backgroundColor = UIColor(red: 248.0/255.0, green: 248.0/255.0, blue: 248.0/255.0, alpha: 1.0)
                    if let url = URL(string: element) {
                        DispatchQueue.global().async {
                            if let urlData = try? Data(contentsOf: url) {
                                DispatchQueue.main.async {
                                    if let iconImage = UIImage(data: urlData) {
                                        self.arrPreviewImg[index] = iconImage
                                        ivScreenShot.image = iconImage
                                    }
                                }
                            }
                        }
                    }
                    let tapImgScreenShot = UITapGestureRecognizer(target: self, action: #selector(tapImgGesture(_:)))
                    ivScreenShot.addGestureRecognizer(tapImgScreenShot)
                    
                    scPreview.addSubview(ivScreenShot)
                    fx += fWidth+20
                    scPreview.contentSize = CGSize(width: fx, height: scPreviewSize.height)
                }
            }
            
            if let description: String = mdAppDetail?.getDescriptionLineThree() {
                tvSummary.text = description
            }
            lbDeveloper.text = appSubTitle //개발자 정보
            
            if let tRatingInfo: (average: String, count: String) = mdAppDetail?.getRatingInfo() { // 레이팅 정보
                if tRatingInfo.average == "" {
                    lbAverageTopRating.isHidden = true
                    ivRatingCrown.isHidden = true
                    lbAllTopRatingCount.text = "평가 부족"
                    
                    lbNotRatingDes.isHidden = false
                    lbAverageRating.isHidden = true
                    lbRatingCount.isHidden = true
                    lbBestRating.isHidden = true
                    btnSeeAllReview.isHidden = true
                    contRatingViewHeight.constant = 60.0

                } else {
                    lbAverageTopRating.text = tRatingInfo.average
                    lbAllTopRatingCount.text = tRatingInfo.count
                    
                    lbAverageRating.text = tRatingInfo.average
                    lbRatingCount.text = tRatingInfo.count
                    
                    let tStarRating = mdAppDetail?.getRatingStarCaculator() // 점수 별 표시 해주기
                    for i in 0 ..< 5 {
                        guard let ivStar: UIImageView = viewInfoAppDetail.viewWithTag(i+20) as? UIImageView else { return }
                        if i < Int((tStarRating?.first)!) {
                            ivStar.image = UIImage(named: "star100_gray")
                            if i == Int((tStarRating?.first)!)-1 {
                                guard let ivStarRemainder: UIImageView = viewInfoAppDetail.viewWithTag(i+21) as? UIImageView else { return }
                                ivStarRemainder.image = tStarRating?.secondImg
                                break
                            }
                        }
                    }
                }
            }
            
            //정보
            lbInfoCategory.text = category
            lbInfoAge.text = mdAppDetail?.getTrackContentRating()
            
            if let tAppInfo = mdAppDetail?.getAppInfo() { //판매자, 파일 사이즈
                lbSellerName.text = tAppInfo.sellerName
                lbFileSize.text = tAppInfo.fileSizeBytes
            }
            
            if let ranguage: String = mdAppDetail?.getSupportRanguage(false) { //언어 정보
                if (mdAppDetail?.supportRanguageCount)! < 3 {
                    ivInfoRanguageArrow.isHidden = true
                    contRanguageArrowRight.constant = 0.0
                    
                }
                lbInfoRanguage.text = ranguage
            }
            lbInfoSupport.text = "이 iPhone용"
        }
    }
}

//MARK: UIScrollView Delegate
extension VcAppDetail: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 75 {
            ivNaviIcon.isHidden = false
            btnNaviRight.isHidden = false
        } else {
            ivNaviIcon.isHidden = true
            btnNaviRight.isHidden = true
        }
    }        
}
