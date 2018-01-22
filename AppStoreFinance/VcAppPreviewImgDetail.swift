//
//  AppPreviewImgDetail.swift
//  AppStoreFinance
//
//  Created by myoung on 2018. 1. 21..
//  Copyright © 2018년 myoung. All rights reserved.
//

import UIKit

class VcAppPreviewImgDetail: UIViewController {
    
    @IBOutlet weak var scImg: UIScrollView!
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var arrImgs: [Int: UIImage] = [:]
    var iClickIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMAinView()        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: ## init 메소드 ##
    func initMAinView() {
        var fx: CGFloat = 20.0
        for i in 0 ..< arrImgs.count {
            
            if let img: UIImage = arrImgs[i] {
                let ivPreviewImg = UIImageView(frame: CGRect(x: fx, y: 0, width: screenWidth-40, height: screenHeight-114))
                ivPreviewImg.image = img
                ivPreviewImg.layer.cornerRadius = 10.0
                ivPreviewImg.layer.borderColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0).cgColor
                ivPreviewImg.layer.borderWidth = 0.5
                ivPreviewImg.layer.masksToBounds = true
                ivPreviewImg.contentMode = .scaleAspectFill
                scImg.addSubview(ivPreviewImg)
                
                fx += screenWidth
            }
        }
        scImg.setContentOffset(CGPoint(x: screenWidth*CGFloat(iClickIndex), y: 0), animated: false)
        scImg.contentSize = CGSize(width: fx-20, height: scImg.frame.size.height)
    }
    
    //MARK: ## 버튼 메소드 ##
    @IBAction func btnComplete(_ sender: UIButton) { // 완료 버튼
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: ## 제스쳐 메소드 ##
    @IBAction func swipeDownDismiss(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
