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

class LottieAnimationViewController: UIViewController, URLSessionDownloadDelegate {
    
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
    
    @objc func startDownload(button: UIButton) {
        button.isHidden = true
        createDownloadTask()
    }
    
    func createDownloadTask() {
        let downloadRequest = URLRequest(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/8/8f/Whole_world_-_land_and_oceans_12000.jpg")!)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        downloadTask = session.downloadTask(with:downloadRequest)
        downloadTask!.resume()
    }
    
    func createUploadTask() {
        let yourUrl = "http://159.65.94.180/v1/predict-price"
        
        let imageToUpload = UIImage(named:"startBackgroundImage")
        let params: Parameters = ["rooms_count": "1", "floor": "2", "has_balcony" : "true", "total_square" : "22", "latitude" : "53.1", "longitude" : "57" ]
        Alamofire.upload(multipartFormData:
            {
                (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(imageToUpload!, 0.1)!, withName: "photo_0", fileName: "file.jpeg", mimeType: "image/jpeg")
                for (key, value) in params
                {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
        }, to:yourUrl,headers:nil)
        { (result) in
            switch result {
            case .success(let upload,_,_ ):
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                })
                upload.responseJSON
                    { response in
                        //print response.result
                        if response.result.value != nil
                        {
                            let dict :NSDictionary = response.result.value! as! NSDictionary
                            let status = dict.value(forKey: "status")as! String
                            if status=="1"
                            {
                                print("DATA UPLOAD SUCCESSFULLY")
                            }
                        }
                }
            case .failure(let _):
                
                break
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // Pause the animation and disable looping.
        boatAnimation!.pause()
        boatAnimation!.loopAnimation = false
        // Speed up animation to finish out the current loop.
        boatAnimation!.animationSpeed = 4
        
        boatAnimation!.play(toProgress: 0.5) {[weak self] (_) in
            // At this time the animation is at the halfway point. Reset sped to 1 and play through the completion animation.
            self?.boatAnimation!.animationSpeed = 1
            self?.boatAnimation!.play(toProgress: 1, withCompletion: nil)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        positionInterpolator?.currentProgress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
    }
    
}

