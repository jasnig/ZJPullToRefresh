# ZJRefreshView
easy way to customize loding animation written in swift(下拉刷新, 上拉刷新, 简单方便自定义加载动画)

#####使用效果:

![refreshView.gif](http://upload-images.jianshu.io/upload_images/1271831-5434455197dcb468.gif?imageMogr2/auto-orient/strip)


![refreshView1.gif](http://upload-images.jianshu.io/upload_images/1271831-50d07a6254f41a3c.gif?imageMogr2/auto-orient/strip)


![refreshView2.gif](http://upload-images.jianshu.io/upload_images/1271831-751dade0bb824f47.gif?imageMogr2/auto-orient/strip)


![refreshView3.gif](http://upload-images.jianshu.io/upload_images/1271831-62d0770244cd0084.gif?imageMogr2/auto-orient/strip)


![refreshView4.gif](http://upload-images.jianshu.io/upload_images/1271831-f7641fd91a5dc5a2.gif?imageMogr2/auto-orient/strip)


* 使用方法
NormalAnimator

```
        let normal = NormalAnimator.normalAnimator()
                /// 指定存储刷新时间的key, 如果不指定或设置为nil, 那么将会和其他未指定的使用相同的key(记录的时间相同, MJRefresh是所有的控件使用相同的时间的)
        normal.lastRefreshTimeKey = "DemoKey1"
        
        /// 隐藏时间显示
//        normal.lastTimelabel.hidden = true

        
        /// 自定义提示文字
//        normal.setupDescriptionForState { (refreshState,refreshType) -> String in
//            switch refreshState {
//            case .loading:
//                return "努力加载中"
//            case .normal:
//                return "休息中"
//            case .pullToRefresh:
//                if refreshType == .header {
//                    return "继续下下下下"
//
//                } else {
//                    return "继续上上上上"
//                }
//            case .releaseToFresh:
//                return "放开我"
//            };
//        }
        
        /// 自定义时间显示
//        normal.setupLastFreshTime { (date) -> String in
//            return ...
//        }

        tableView.zj_addRefreshHeader(normal, refreshHandler: {[weak self] in
            /// 多线程中不要使用 [unowned self]
            /// 注意这里的gcd是为了模拟网络加载的过程, 在实际的使用中, 不
            需要这段gcd代码, 直接在这里进行网络请求, 在请求完毕后, 调用分类方法, 结束刷新
            dispatch_async(dispatch_get_global_queue(0, 0), { 
                for i in 0...50000 {
                    if i <= 10 {
                        self?.data.append(i)

                    }
                    /// 延时
                    print("加载数据中")
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self?.tableView.reloadData()
                    /// 刷新完毕, 停止动画
                    self?.tableView.zj_stopHeaderAnimation()

                })
            })
            
        })
   ```
   
   * GifAnimator的使用

```
/// 设置高度
let gifAnimatorHeader = GifAnimator.gifAnimatorWithHeight(100.0)
        gifAnimatorHeader.lastRefreshTimeKey = "exampleHeader4"
        
        /// 为不同的state设置不同的图片
        /// 闭包需要返回一个元组: 图片数组和gif动画每一帧的执行时间
        /// 一般需要设置loading状态的图片(必须), 作为加载的gif
        /// 和pullToRefresh状态的图片数组(可选择设置), 作为拖拽时的加载动画
         gifAnimatorHeader.setupImagesForRefreshstate { (refreshState) -> (images: [UIImage], duration: Double)? in
            if refreshState == .loading {
                var images = [UIImage]()
                for index in 1...47 {
                    let image = UIImage(named: "loading\(index)")!
                    images.append(image)
                }
                return (images, 1.0)
            }
            else if  refreshState == .pullToRefresh {
                var images = [UIImage]()
                for index in 1...47 {
                    let image = UIImage(named: "loading\(index)")!
                    images.append(image)
                }
                return (images, 0.25)
            }
               return nil
        }

        tableView.zj_addRefreshHeader(gif, refreshHandler: {[weak self] in
            /// 多线程中不要使用 [unowned self]
            /// 注意这里的gcd是为了模拟网络加载的过程, 在实际的使用中, 不需要这段gcd代码, 直接在这里进行网络请求, 在请求完毕后, 调用分类方法, 结束刷新
            dispatch_async(dispatch_get_global_queue(0, 0), { 
                for i in 0...50000 {
                    if i <= 10 {
                        self?.data.append(i)

                    }
                    /// 延时
                      print("加载数据中")
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self?.tableView.reloadData()
                    /// 刷新完毕, 停止动画
                    self?.tableView.zj_stopHeaderAnimation()

                })
            })
            
        })
```








####如果对你有帮助,请随手给个star 
####如果你在使用中遇到问题: 可以联系我QQ: 854136959
## License

ZJRefreshView is released under the MIT license. See LICENSE for details.
