//
//  GameViewController.swift
//  KongShoot
//
//  Created by Alex Wayne on 4/7/20.
//  Copyright © 2020 Wayne Apps. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import SCSDKCreativeKit
import FacebookShare
import Photos
import MessageUI
import StoreKit

class GameViewController: UIViewController, GADInterstitialDelegate, GADRewardedAdDelegate, MFMessageComposeViewControllerDelegate, SharingDelegate {
    
    
    func messageComposeViewController( _ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    var scene: GameScene?
    
    var interstitial: GADInterstitial!
    var rewardedAd: GADRewardedAd?
    
    fileprivate lazy var snapAPI = {
        return SCSDKSnapAPI()
    }()
    
    let url = "https://apps.apple.com/us/app/doot-tap-to-play/id1506887655?ls=1"


    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad presented.")
    }

    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
      print("Rewarded ad failed to present.")
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad dismissed.")
        
        reloadRewardAd()
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
      print("Reward received with currency: \(reward.type), amount \(reward.amount).")
        
      scene!.getReward()
    }
    
    func reloadRewardAd(){
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3058646248757517/9158638014")
        rewardedAd!.load(GADRequest()) { error in
            
          if let error = error {
            // Handle ad failed to load case.
          } else {
            // Ad successfully loaded.
            print("Reward loaded")
          }
        }
    }

    func createAndLoadInterstitial() -> GADInterstitial {

        var interstitial = GADInterstitial(adUnitID:  "ca-app-pub-3058646248757517/4034728878")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }

    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
      print("interstitialDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
      print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      print("interstitialWillPresentScreen")
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
      print("interstitialWillDismissScreen")
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        interstitial = createAndLoadInterstitial()

    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
      print("interstitialWillLeaveApplication")
    }

    public func showAd(){
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasnt ready")
        }
    }
    
    public func showRewardAd(){
        if rewardedAd?.isReady == true {
           rewardedAd?.present(fromRootViewController: self, delegate:self)
        }
    }
    
    public func askForRating(){
        if #available( iOS 10.3,*){
        SKStoreReviewController.requestReview()
        }
    }
    
    @objc func setimage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
    }
    
    func save(_ sender: Any, image: UIImage) {

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(setimage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    
    public func share(image: UIImage){
    //  let image = getScreenshot()
      let items = [image, URL(string: url)] as [Any]
      let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
      present(ac, animated: true)
    }
    
    func shareTextOnFaceBook(image: UIImage) {
        let shareContent = ShareLinkContent()
        shareContent.contentURL = URL.init(string: url)! //your link
        save(self, image: image)
        ShareDialog(fromViewController: self, content: shareContent, delegate: self as! SharingDelegate).show()
    }

    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        if sharer.shareContent.pageID != nil {
            print("Share: Success")
        }
    }
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Share: Fail")
    }
    func sharerDidCancel(_ sharer: Sharing) {
        print("Share: Cancel")
    }
    
    func shareText(image: UIImage){
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.body = url
            messageVC.addAttachmentURL(URL(string: url)!, withAlternateFilename: "appstore")
            var imageData = image.pngData()
            messageVC.addAttachmentData(imageData!, typeIdentifier: "public.data", filename: "image.png")
         self.present(messageVC, animated: true, completion: nil)
        }
        else {
            print("User hasn't setup Messages.app")
        }
    }
    
    
    
    func shareToInstagramStories(image: UIImage) {
        // NOTE: you need a different custom URL scheme for Stories, instagram-stories, add it to your Info.plist!

        
        guard let instagramUrl = URL(string: "instagram-stories://share") else {
            return
        }

        if UIApplication.shared.canOpenURL(instagramUrl) {
            let pasterboardItems = [["com.instagram.sharedSticker.backgroundImage": image as Any, "com.instagram.sharedSticker.contentURL" : url]]
            UIPasteboard.general.setItems(pasterboardItems)
            UIApplication.shared.open(instagramUrl)
        } else {
            // Instagram app is not installed or can't be opened, pop up an alert
        }
    }
    
    public func postImageToInstagram(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if error != nil {
                print(error)
            }

            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

            if let lastAsset = fetchResult.firstObject as? PHAsset {

                let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)")!

                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Instagram is not installed", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }

            }
    }
    
    let api = SCSDKSnapAPI()


    
    public func shareOnSnapchat(image: UIImage){
        let photo = SCSDKSnapPhoto(image: image)
        let photoContent = SCSDKPhotoSnapContent(snapPhoto: photo)
        photoContent.attachmentUrl = url
        
//        SCSDKSnapAPI(content: photoContent).startSnapping() { (error: Error?) in
//
//        }
        
        snapAPI.startSending(photoContent, completionHandler: {error in
            if let error = error {
                print("EROROREOREO ")
                print(error.localizedDescription)
            } else {
                print("SUCESS")
                // Success
            }
        })
    }
    
    public func shareOnTwitter(image: UIImage){
        

        let shareString = "https://twitter.com/intent/tweet?url=\(url)"

        // encode a space to %20 for example
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

        // cast to an url
        let url = URL(string: escapedShareString)
        
        save(self, image: image)

        // open in safari
        UIApplication.shared.openURL(url!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
       
        interstitial = createAndLoadInterstitial()
        interstitial.delegate = self
        
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3058646248757517/9158638014")
        rewardedAd?.load(GADRequest()) { error in
            
          if let error = error {
            // Handle ad failed to load case.
          } else {
            // Ad successfully loaded.
            print("Reward loaded")
          }
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
             scene = GameScene(fileNamed: "GameScene")

                // Set the scale mode to scale to fit the window
            scene!.scaleMode = .aspectFill
            scene!.controller = self
                // Present the scene
                view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .portrait
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
