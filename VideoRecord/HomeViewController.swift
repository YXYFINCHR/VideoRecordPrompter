//
//  CameraViewController.swift
//  VideoRecord
//
//  Created by YXY on 2017/11/22.
//  Copyright © 2017年 YXY. All rights reserved.
//

import UIKit
import MobileCoreServices
import QuartzCore

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var textField: UITextView!
    let picker:UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        
        let panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(hideAction(sender:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 自定义函数
    // 拍摄
    @IBAction func useCamera(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("无相机权限")
            return
        }
        guard UIImagePickerController.isCameraDeviceAvailable(.rear) && UIImagePickerController.isCameraDeviceAvailable(.front) else {
            print("相机被占用，无法启用")
            return
        }
        
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraDevice = .front
        picker.cameraFlashMode = .off
        picker.mediaTypes = ["public.image","public.movie"] // 支持的拍摄类型
        picker.cameraCaptureMode = .video   // 初始摄像头模式
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
    
    // 保存
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 获取媒体类型
        guard let mediaType = info["UIImagePickerControllerMediaType"] as? String else {
            print("获取拍摄结果类型失败")
            return
        }
        
        // 如果是图片
        if mediaType == kUTTypeImage as String{
            let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }else{  // 视频
            // 获取视频的临时路径
            let urlStr = (info["UIImagePickerControllerMediaURL"] as! NSURL).path
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr!, self, #selector(video(videoPath:didFinishSavingWithError:contextInfo:)), nil)
        }
        self.dismiss(animated: true, completion: nil)
        
        // UIImageWriteToSavedPhotosAlbum(<#T##image: UIImage##UIImage#>, <#T##completionTarget: Any?##Any?#>, <#T##completionSelector: Selector?##Selector?#>, <#T##contextInfo: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)
        // Target:回调方法所在的对象     Selector:调用的回调方法    contextInfo:可选参数，保存了一个指向context数据的指针，它将传递给回调方法
    }
    
    // 回调函数
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            let alertController = UIAlertController(title: "保存成功", message: "已将图片保存至图库", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "保存失败", message: error?.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func video(videoPath: String, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer){
        if error == nil {
            let alertController = UIAlertController(title: "保存成功", message: "已将视频保存至图库", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "好的", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "保存失败", message: error?.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func hideAction(sender: UIPanGestureRecognizer) {
        self.textField.resignFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
