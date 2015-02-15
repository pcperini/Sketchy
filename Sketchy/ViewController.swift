//
//  ViewController.swift
//  Sketchy
//
//  Created by Patrick Perini on 2/14/15.
//  Copyright (c) 2015 pcperini. All rights reserved.
//

import UIKit
import GPUImage

class ViewController: UIViewController {
    
    @IBOutlet var pictureView: UIImageView?
    @IBOutlet var cameraButton: UIBarButtonItem?
    @IBOutlet var edgeSlider: UISlider?
    @IBOutlet var shareButton: UIBarButtonItem?
    
    var originalPicture: UIImage?

    override func viewDidAppear(animated: Bool) {
        if self.pictureView?.image == nil {
            self.cameraButtonWasPressed(self.cameraButton!)
        }
    }

    @IBAction func cameraButtonWasPressed(sender: UIBarButtonItem) {
        let camera = UIImagePickerController()
        camera.sourceType = UIImagePickerControllerSourceType.Camera
        camera.delegate = self
        
        self.presentViewController(camera,
            animated: true,
            completion: nil)
    }
    
    @IBAction func edgeSliderDidChangeValue(sender: UISlider) {
        let filterableImage = GPUImagePicture(image: self.originalPicture)
        let filter = GPUImageSketchFilter()
        filter.edgeStrength = CGFloat(self.edgeSlider!.value * 4.0)
        
        filterableImage.addTarget(filter)
        filter.useNextFrameForImageCapture()
        filterableImage.processImage()
        
        self.pictureView?.image = filter.imageFromCurrentFramebufferWithOrientation(UIImageOrientation.Right)
    }
    
    @IBAction func shareButtonWasPressed(sender: UIBarButtonItem) {
        let shareSheet = UIActivityViewController(activityItems: [self.pictureView!.image!],
            applicationActivities: nil)
        
        self.presentViewController(shareSheet,
            animated: true,
            completion: nil)
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.originalPicture = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.edgeSlider?.value = 0.5
        
        self.edgeSliderDidChangeValue(self.edgeSlider!)
        self.dismissViewControllerAnimated(true,
            completion: nil)
    }
}

