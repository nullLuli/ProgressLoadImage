//
//  ViewController.swift
//  LoadImage
//
//  Created by nullLuli on 2018/3/25.
//  Copyright © 2018年 nullLuli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgPath = Bundle.main.path(forResource: "a", ofType: "jpg")
        if let imgPath = imgPath {
            let imgURL = URL.init(fileURLWithPath: imgPath)
            do {
                let imageV = UIImageView.init()
                self.view.addSubview(imageV)
                imageV.frame = self.view.bounds
                imageV.backgroundColor = UIColor.yellow
                
                let imgData = try Data.init(contentsOf: imgURL)
                //把imgdata切成三段
                let data1 = imgData.subdata(in: Range(uncheckedBounds: (lower: 0, upper: imgData.count/3)))
                let data2 = imgData.subdata(in: Range(uncheckedBounds: (lower: imgData.count/3, upper: imgData.count*2/3)))
                let data3 = imgData.subdata(in: Range(uncheckedBounds: (lower: imgData.count*2/3, upper: imgData.count)))
                
                let imageSource = CGImageSourceCreateIncremental(nil)
                let time = DispatchTime.now() + 3
                var partData = Data()
                
                // 创建一个日期格式器
                let dformatter = DateFormatter()
                dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
                DispatchQueue.main.asyncAfter(deadline: time) {
                    print("time \(dformatter.string(from: Date()))")
                    let dataAndImage = self.appenData(data: data1, isEnd: false, sumData: partData, imageSource: imageSource)
                    partData = dataAndImage.0
                    imageV.image = dataAndImage.1
                    
                    let time = DispatchTime.now() + 3
                    DispatchQueue.main.asyncAfter(deadline: time) {
                        print("time \(dformatter.string(from: Date()))")
                        let dataAndImage = self.appenData(data: data2, isEnd: false, sumData: partData, imageSource: imageSource)
                        partData = dataAndImage.0
                        imageV.image = dataAndImage.1
                        
                        let time = DispatchTime.now() + 3
                        DispatchQueue.main.asyncAfter(deadline: time) {
                            print("time \(dformatter.string(from: Date()))")
                            let dataAndImage = self.appenData(data: data3, isEnd: true, sumData: partData, imageSource: imageSource)
                            partData = dataAndImage.0
                            imageV.image = dataAndImage.1
                        }
                    }
                }
                
            }
            catch{
                print("data 初始化失败")
            }
        }
        else
        {
            print("path为空")
        }
    }
    
    func appenData(data:Data, isEnd:Bool, sumData:Data, imageSource:CGImageSource) -> (Data,UIImage) {
        var sumData = sumData
        var imageUI : UIImage!
        sumData.append(data)
        CGImageSourceUpdateData(imageSource, sumData as CFData, isEnd)
        let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        if let image = image {
            imageUI = UIImage.init(cgImage: image)
        }
        else
        {
            print("从data1中取图片失败")
        }
        return (sumData,imageUI)
    }
}

