//
//  ViewController.swift
//  PullToRefresh
//
//  Created by ZeroJ on 16/7/20.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit


class TestController: UIViewController {
    static let cellID = "cellID"

    lazy var tableView: UITableView = UITableView(frame: self.view.bounds, style: .Plain)
    var data: [Int] = [1,2,3,4]
    var row: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.tableFooterView = UIView()
        
        tableView.sectionHeaderHeight = 100.0
        
        switch row! {
        case 0:
            example1()
        case 1:
            example2()
        case 2:
            example3()
        case 3:
            example4()
        case 4:
            example5()
        case 5:
            example6()
        case 6:
            example7()
        default:
            break
        }

    }
    
    func example1() {
        let normalHeader = NormalAnimator.normalAnimator()
        normalHeader.lastRefreshTimeKey = "exampleHeader1"
        
        let normalFooter = NormalAnimator.normalAnimator()
        normalFooter.lastRefreshTimeKey = "exampleFooter1"

        addHeader(normalHeader, footer: normalFooter)
    }
    func example2() {
        let normalHeader = NormalAnimator.normalAnimator()
        normalHeader.lastRefreshTimeKey = "exampleHeader2"
        normalHeader.lastTimelabel.hidden = true
        
        let normalFooter = NormalAnimator.normalAnimator()
        normalFooter.lastRefreshTimeKey = "exampleFooter2"

        addHeader(normalHeader, footer: normalFooter)
    }
    func example3() {
        let normalHeader = NormalAnimator.normalAnimator()
        normalHeader.lastRefreshTimeKey = "exampleHeader3"
        
        /// 自定义提示文字
        normalHeader.setupDescriptionForState { (refreshState,refreshType) -> String in
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
            };
        }
        
        /// 自定义时间显示
        //        normalHeader.setupLastFreshTime { (date) -> String in
        //            return ...
        //        }
        let normalFooter = NormalAnimator.normalAnimator()
        normalFooter.lastRefreshTimeKey = "exampleFooter3"
        addHeader(normalHeader, footer: normalFooter)

    }
    func example4() {
        
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
        
        let gifAnimatorFooter = GifAnimator.gifAnimatorWithHeight(100.0)
        gifAnimatorFooter.lastRefreshTimeKey = "exampleFooter4"
        
        /// 为不同的state设置不同的图片
        /// 闭包需要返回一个元组: 图片数组和gif动画每一帧的执行时间
        /// 一般需要设置loading状态的图片(必须), 作为加载的gif
        /// 和pullToRefresh状态的图片数组(可选择设置), 作为拖拽时的加载动画
        gifAnimatorFooter.setupImagesForRefreshstate { (refreshState) -> (images: [UIImage], duration: Double)? in
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
        
        addHeader(gifAnimatorHeader, footer: gifAnimatorFooter)
    }
    func example5() {
        let gifAnimatorHeader = GifAnimator.gifAnimatorWithHeight(100.0)
        gifAnimatorHeader.lastRefreshTimeKey = "exampleHeader5"
        gifAnimatorHeader.descriptionLabel.hidden = true
        gifAnimatorHeader.lastTimeLabel.hidden = true
        
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
        
        let gifAnimatorFooter = GifAnimator.gifAnimatorWithHeight(100.0)
        gifAnimatorFooter.lastRefreshTimeKey = "exampleFooter5"
        /// 为不同的state设置不同的图片
        /// 闭包需要返回一个元组: 图片数组和gif动画每一帧的执行时间
        /// 一般需要设置loading状态的图片(必须), 作为加载的gif
        /// 和pullToRefresh状态的图片数组(可选择设置), 作为拖拽时的加载动画
        gifAnimatorFooter.setupImagesForRefreshstate { (refreshState) -> (images: [UIImage], duration: Double)? in
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
        
        addHeader(gifAnimatorHeader, footer: gifAnimatorFooter)

    }
    func example6() {
        let gifAnimatorHeader = GifAnimator.gifAnimatorWithHeight(100.0)
        gifAnimatorHeader.lastRefreshTimeKey = "exampleHeader6"
        
        
        gifAnimatorHeader.setupDescriptionForState { (refreshState,refreshType) -> String in
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
            };
        }
        
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
        
        let gifAnimatorFooter = GifAnimator.gifAnimatorWithHeight(100.0)
        gifAnimatorFooter.lastRefreshTimeKey = "exampleFooter5"
        
        gifAnimatorFooter.setupDescriptionForState { (refreshState,refreshType) -> String in
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
            };
        }
        
        /// 为不同的state设置不同的图片
        /// 闭包需要返回一个元组: 图片数组和gif动画每一帧的执行时间
        /// 一般需要设置loading状态的图片(必须), 作为加载的gif
        /// 和pullToRefresh状态的图片数组(可选择设置), 作为拖拽时的加载动画
        gifAnimatorFooter.setupImagesForRefreshstate { (refreshState) -> (images: [UIImage], duration: Double)? in
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
        
        addHeader(gifAnimatorHeader, footer: gifAnimatorFooter)
   
    }
    func example7() {
        let header = TestGif.gif()
        header.lastRefreshTimeKey = "exampleHeader7"

        tableView.zj_addRefreshHeader(header, refreshHandler: {[weak self] in
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
        
        let footer = TestNormal.normal()
        footer.lastRefreshTimeKey = "exampleFooter7"
        tableView.zj_addRefreshFooter(footer) {[weak self] in
            
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
                    self?.tableView.zj_stopFooterAnimation()
                    
                })
            })
        }

    }
    
    func addHeader<Animator where Animator: UIView, Animator: RefreshViewDelegate>(header: Animator, footer: Animator) {
        tableView.zj_addRefreshHeader(header, refreshHandler: {[weak self] in
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
        
        tableView.zj_addRefreshFooter(footer) {[weak self] in
            
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
                    self?.tableView.zj_stopFooterAnimation()
                    
                })
            })
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //        tableView.zj_startHeaderAnimation()
        
    }
    
    deinit {
        print("xiaoghui-----\(self)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension TestController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(TestController.cellID)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: TestController.cellID)
        }
        cell?.textLabel?.text = "测试数据-----\(indexPath.row)"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "header"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showViewController(UIViewController(), sender: nil)
    }
}

