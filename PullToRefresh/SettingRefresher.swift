//
//  SettingRefresher.swift
//  PullToRefresh
//
//  Created by ZeroJ on 16/7/29.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit


///
class TestNormal {
    class func normal() -> NormalAnimator {
        let normal = NormalAnimator.normalAnimator()
        /// 隐藏时间显示
        //        normal.lastTimelabel.hidden = true
        /// 指定存储刷新时间的key, 如果不指定或设置为nil, 那么将会和其他未指定的使用相同的key(记录的时间相同, MJRefresh是所有的控件使用相同的时间的)
        normal.lastRefreshTimeKey = "DemoKey1"
        normal.setupDescriptionForState { (refreshState ,refreshType) -> String in
            switch refreshState {
            case .loading:
                return "努力加载中"
            case .normal:
                return "休息中"
            case .pullToRefresh:
                if refreshType == .header {
                    return "继续下下下下"
                    
                } else {
                    return "继续上上上上"
                }
            case .releaseToFresh:
                return "放开我"
            }
        }
        return normal
    }
}

class TestGif {
    
    class func gif() -> GifAnimator {
        let gif = GifAnimator.gifAnimatorWithHeight(100.0)
        gif.lastRefreshTimeKey = "DemoKey2"

        /// 为不同的state设置不同的图片
        /// 闭包需要返回一个元组: 图片数组和gif动画每一帧的执行时间
        /// 一般需要设置loading状态的图片(必须), 作为加载的gif
        /// 和pullToRefresh状态的图片数组(可选择设置), 作为拖拽时的加载动画
        gif.setupImagesForRefreshstate { (refreshState) -> (images: [UIImage], duration: Double)? in
            if refreshState == .loading {
                var images = [UIImage]()
                for index in 1...47 {
                    let image = UIImage(named: "loading\(index)")!
                    images.append(image)
                }
                return (images, 1.0)
            }
            else if  refreshState == .pullToRefresh {
                var images = [UIImage]()
                for index in 1...47 {
                    let image = UIImage(named: "loading\(index)")!
                    images.append(image)
                }
                return (images, 0.25)
            }
            return nil
        }
        
        return gif
    }
}
