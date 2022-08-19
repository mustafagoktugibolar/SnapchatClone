//
//  snapVC.swift
//  SnapchatClone
//
//  Created by Mustafa Göktuğ İbolar on 10.08.2022.
//

import UIKit
import ImageSlideshow
import Kingfisher


class snapVC: UIViewController {
    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()
    var timeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        let height = view.frame.size.height
        let width = view.frame.size.width
        
        if let snap = selectedSnap {
            
            timeLabel.text = "Time Left: \(snap.timeDifference)"
            timeLabel.frame = CGRect(x:width * 0.35, y: height * 0.05, width: width * 0.3, height: height * 0.05)
            view.addSubview(timeLabel)
            
            for imageUrl in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
            }
            
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: width * 0.05, y: height * 0.1 , width: width * 0.9, height: height * 0.78))
            imageSlideShow.backgroundColor = UIColor.yellow
            
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
            
        }
        

    }


}
