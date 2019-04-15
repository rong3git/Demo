//
//  GALBaseViewController.swift
//  galley
//
//  Created by rongc on 6/24/18.
//  Copyright © 2018 RongchangLei. All rights reserved.
//

import UIKit
import AVFoundation

class GALBaseViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, iCarouselDataSource, iCarouselDelegate {
 
    fileprivate let reuseIdentifier = "videoCell"
    fileprivate var responseData: [GALVideoAndImageItem] = []
    fileprivate let networkQuery = GALNetworking()
    
    @IBOutlet weak var videoPlayerCollectionView: UICollectionView!
    @IBOutlet weak var rotaryCarouselView: iCarousel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoPlayerCollectionView.delegate = self
        self.videoPlayerCollectionView.dataSource = self
        self.rotaryCarouselView.delegate = self
        self.rotaryCarouselView.dataSource = self
        self.rotaryCarouselView.type = .rotary
        self.loadData()
    }
    
    //MARK: iCarousel Delegate Methods
    func carouselWillBeginScrollingAnimation(_ carousel: iCarousel) {
        DispatchQueue.main.async {
            self.videoPlayerCollectionView.scrollToItem(at: IndexPath(row: carousel.currentItemIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return responseData.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        var resizedImage = UIImage()
        imageView.contentMode = .center
        let item = self.responseData[index]
        let imageURL = URL(string:item.imageURL)
        DispatchQueue.global(qos: .default).async {
            if let fetchImageURL = imageURL {
                do {
                    let imageData = try Data(contentsOf:fetchImageURL)
                    let image = UIImage(data:imageData)
                    
                    resizedImage = UIImage.resizingImage(image, newSize: CGSize(width: 200, height: 200))!
                } catch {
                    print("Unable to load data: \(error)")
                }
            }
            DispatchQueue.main.async {
                imageView.image = resizedImage
            }
        }
        return imageView
    }

    //MARK: UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        rotaryCarouselView.scrollToItem(at: indexPath.row, animated: false)
    }
    //MARK: UICollectionView Datasource Delegate
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return responseData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.videoPlayerCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GALVideoCollectionViewCell
        let item = self.responseData[indexPath.row]
        let urlString = item.videoURL
        let videoURL = URL(string: urlString)
        let avPlayer = AVPlayer(url: videoURL!)
        avPlayer.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        let videoLayer = AVPlayerLayer(player: avPlayer)
        videoLayer.frame = cell.videoContainerView.bounds
        videoLayer.videoGravity = .resizeAspectFill
        cell.videoContainerView.layer.addSublayer(videoLayer)
        avPlayer.play()
        return cell
    }
    
    //MARK: Helper Methods
    func loadData() {
        networkQuery.fetchNetworkData() {results in
            self.responseData = results
            DispatchQueue.main.async {
                self.videoPlayerCollectionView.reloadData()
                self.rotaryCarouselView.reloadData()
            }
        }
    }
    
    @objc func playerItemDidReachEnd(_ notification: Notification?) {
        let p = notification?.object as? AVPlayerItem
        p?.seek(to: CMTime.zero, completionHandler: nil)
    }
}
