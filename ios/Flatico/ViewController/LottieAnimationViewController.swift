//
//  LottieAnimationViewController.swift
//  Flatico
//
//  Created by Anthony Marchenko on 3/11/18.
//  Copyright © 2018 Anthony Marchenko. All rights reserved.
//

import UIKit
import Lottie
import Alamofire

class LottieAnimationViewController: UIViewController {
    
    private var downloadTask: URLSessionDownloadTask?
    private var boatAnimation: LOTAnimationView?
    var positionInterpolator: LOTPointInterpolatorCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create Boat Animation
        boatAnimation = LOTAnimationView(name: "Boat_Loader")
        // Set view to full screen, aspectFill
        boatAnimation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        boatAnimation!.contentMode = .scaleAspectFill
        boatAnimation!.frame = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y, width: view.bounds.width/1.5, height: view.bounds.height/1.5)//view.bounds
        boatAnimation!.center = CGPoint(x:view.bounds.midX, y:view.bounds.midY-120);
        // Add the Animation
        view.addSubview(boatAnimation!)
        
        
        // The center of the screen, where the boat will start
        let screenCenter = CGPoint(x:view.bounds.midX, y:view.bounds.midY)
        // The center one screen height above the screen. Where the boat will end up when the download completes
        let offscreenCenter = CGPoint(x:view.bounds.midX, y:-view.bounds.midY)
        
        // Convert points into animation view coordinate space.
        let boatStartPoint = boatAnimation!.convert(screenCenter, toKeypathLayer: LOTKeypath(string: "Boat"))
        let boatEndPoint = boatAnimation!.convert(offscreenCenter, toKeypathLayer: LOTKeypath(string: "Boat"))
        
        // Set up out interpolator, to be driven by the download callback
        positionInterpolator = LOTPointInterpolatorCallback(from: boatStartPoint, to: boatEndPoint)
        // Set the interpolator on the animation view for the Boat.Transform.Position keypath.
        boatAnimation!.setValueDelegate(positionInterpolator!, for:LOTKeypath(string: "Boat.Transform.Position"))
        
        //Play the first portion of the animation on loop until the download finishes.
        boatAnimation!.loopAnimation = true
        boatAnimation!.play()
        
        createUploadTask()
        
    }
    
    
    func createUploadTask() {
        
        let url = "http://159.65.94.180:8080/v1/predict-price"
        
        let imageToUpload = QueryModel.shared.imageToUpload//UIImage(named:"startBackgroundImage")!
        let imageData = UIImageJPEGRepresentation(imageToUpload, 1.0)
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        let parameters: Parameters = ["rooms_count": QueryModel.shared.roomCount, "floor": QueryModel.shared.floor, "has_balcony" : QueryModel.shared.isBalconExist, "total_square" : QueryModel.shared.totalSquere, "latitude" : QueryModel.shared.latitude, "longitude" : QueryModel.shared.longitude]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData {
                multipartFormData.append(data, withName: "photo_0", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    print("\(response)")
                    
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "finalViewControllerKey") as! FinalViewController
                    vc.finalPriceValue = 10
                    self.navigationController?.pushViewController(vc,
                                                             animated: true)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                // onError?(error)
            }
        }
    }
}


//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        // Pause the animation and disable looping.
//        boatAnimation!.pause()
//        boatAnimation!.loopAnimation = false
//        // Speed up animation to finish out the current loop.
//        boatAnimation!.animationSpeed = 4
//
//        boatAnimation!.play(toProgress: 0.5) {[weak self] (_) in
//            // At this time the animation is at the halfway point. Reset sped to 1 and play through the completion animation.
//            self?.boatAnimation!.animationSpeed = 1
//            self?.boatAnimation!.play(toProgress: 1, withCompletion: nil)
//        }
//    }
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        positionInterpolator?.currentProgress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
//    }


