//
//  RefreshViewDelegate.swift
//  PullToRefresh
//
//  Created by ZeroJ on 16/7/20.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit
public enum RefreshViewState {
    /// 正在加载状态
    case loading
    /// 正常状态
    case normal
    /// 下拉状态
    case pullToRefresh
    /// 松开手即进入刷新状态
    case releaseToFresh
}


public enum RefreshViewType {
    case header, footer
}

public protocol RefreshViewDelegate {
    /// 你应该为每一个header或者footer设置一个不同的key来保存时间, 否则将公用同一个key使用相同的时间
    var lastRefreshTimeKey: String? { get }
    /// 是否刷新完成后自动隐藏 默认为false
    var isAutomaticlyHidden: Bool { get }
    /// 上次刷新时间, 有默认赋值和返回
    var lastRefreshTime: NSDate? { get set }
    /// repuired 三个必须实现的代理方法
    
    /// 开始进入刷新(loading)状态, 这个时候应该开启自定义的(动画)刷新
    func refreshDidBegin(refreshView: RefreshView, refreshViewType: RefreshViewType)
    
    /// 刷新结束状态, 这个时候应该关闭自定义的(动画)刷新
    func refreshDidEnd(refreshView: RefreshView, refreshViewType: RefreshViewType)
    
    /// 刷新状态变为新的状态, 这个时候可以自定义设置各个状态对应的属性
    func refreshDidChangeState(refreshView: RefreshView, fromState: RefreshViewState, toState: RefreshViewState, refreshViewType: RefreshViewType)
    
    /// optional 两个可选的实现方法
    /// 允许在控件添加到scrollView之前的准备
    func refreshViewDidPrepare(refreshView: RefreshView, refreshType: RefreshViewType)
    
    /// 拖拽的进度, 可用于自定义实现拖拽过程中的动画
    func refreshDidChangeProgress(refreshView: RefreshView, progress: CGFloat, refreshViewType: RefreshViewType)
    
}

/// default doing
extension RefreshViewDelegate {
    public func refreshViewDidPrepare(refreshView: RefreshView, refreshType: RefreshViewType) { }
    public func refreshDidChangeProgress(refreshView: RefreshView, progress: CGFloat, refreshViewType: RefreshViewType) { }
    public var isAutomaticlyHidden: Bool { return false }
    
    public var lastRefreshTime: NSDate? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(lastRefreshTimeKey ?? RefreshView.ConstantValue.commonRefreshTimeKey) as? NSDate
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: lastRefreshTimeKey ?? RefreshView.ConstantValue.commonRefreshTimeKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    public var lastRefreshTimeKey: String? {
        return nil
    }
}


public class RefreshView: UIView {
    /// KVO Constant
    struct ConstantValue {
        static var RefreshViewContext: UInt8 = 0
        static let ScrollViewContentOffsetPath = "contentOffset"
        static let ScrollViewContentSizePath = "contentSize"
        static let commonRefreshTimeKey = "ZJCommonRefreshTimeKey"
        static let LastRefreshTimeKey = NSProcessInfo().globallyUniqueString
    }
    ///
    typealias RefreshHandler = Void -> Void
    // MARK: - internal property
    var canBegin = false {
        didSet {
            if canBegin == oldValue { return }
            if canBegin {
                // 开始
                startAnimation()
            } else {
                // 结束
                stopAnimation()
            }
        }
    }
    
    // MARK: - private property
    private var refreshViewState: RefreshViewState = .normal {
        didSet {
            if refreshViewState == .normal {
                hidden = refreshAnimator.isAutomaticlyHidden
            }
            else { hidden = false }
            
            if refreshViewState != oldValue {
                if refreshViewState == .loading {
                    refreshAnimator.lastRefreshTime = NSDate()
                    
                }
                refreshAnimator.refreshDidChangeState(self, fromState: oldValue, toState: refreshViewState, refreshViewType: refreshViewType)
                
            }
        }
    }
    
    /// action handler
    private let refreshHandler: RefreshHandler
    /// handler refresh !! must be UIView which conform to RefreshViewDelegate protocol
    private var refreshAnimator: RefreshViewDelegate
    /// header or footer
    private var refreshViewType: RefreshViewType = .header
    /// to distinguish if is refreshing
    private var isRefreshing = false
    /// to distinguish if dragging begins
    private var isGestureBegin = false
    /// save scrollView's contentOffsetY when the footer should appear
    private var beginAnimatingOffsetY: CGFloat = 0
    private var insetTopDelta: CGFloat = 0
    /// 标注结束的动画是否执行完成
    private var isAnimating = false
    /// store it to reset scrollView' after animating
    private var scrollViewOriginalValue:(bounces: Bool, contentInsetTop: CGFloat, contentInsetBottom: CGFloat, contentOffset: CGPoint) = (false, 0.0, 0.0, CGPoint())
    /// superView
    private weak var scrollView: UIScrollView? {
        return self.superview as? UIScrollView
    }
    
    //MARK: - life cycle
    ///
    init<Animator:UIView where Animator: RefreshViewDelegate>(frame: CGRect, refreshType: RefreshViewType, refreshAnimator: Animator, refreshHandler: RefreshHandler) {
        self.refreshViewType = refreshType
        self.refreshAnimator = refreshAnimator
        self.refreshHandler = refreshHandler
        super.init(frame: frame)
        // 添加刷新控件
        addSubview(refreshAnimator)
        /// needed 添加约束
        autoresizingMask = .FlexibleWidth
        addConstraint()
        /// animator can prepare to do something 调用代理 准备的方法
        self.refreshAnimator.refreshViewDidPrepare(self, refreshType: self.refreshViewType)
        ///
        hidden = refreshAnimator.isAutomaticlyHidden
    }
    ///
    private func addConstraint() {
        guard let refreshAnimatorView = refreshAnimator as? UIView else { return }
        let leading = NSLayoutConstraint(item: refreshAnimatorView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        let top = NSLayoutConstraint(item: refreshAnimatorView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let trailing = NSLayoutConstraint(item: refreshAnimatorView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: refreshAnimatorView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        
        refreshAnimatorView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([leading, top, trailing, bottom])
    }
    ///
    required public init?(coder aDecoder: NSCoder) {
        fatalError("there is no need to suport xib")
    }
    
    deinit {
        removeObserverOf(scrollView)
    }
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if newSuperview == nil {
            // 移除kvo监听者
            removeObserverOf(scrollView);
        }
        
        if let newScrollView = newSuperview as? UIScrollView {
            ///  can drag anytime 开启始终支持bounces
            newScrollView.alwaysBounceVertical = true
            // 添加kvo监听者
            addObserverOf(newScrollView)
            // 记录scrollView初始的状态, 便于在执行完成之后恢复
            scrollViewOriginalValue = (newScrollView.bounces, newScrollView.contentInset.top, newScrollView.contentInset.bottom, newScrollView.contentOffset)
  
            if refreshViewType == .footer {// reset frame
                self.frame.origin.y = newScrollView.contentSize.height
            }
            else {
                self.frame.origin.y = -self.frame.size.height
            }
        }
    }
    
}

extension RefreshView {
    private func startAnimation() {
        guard let validScrollView = scrollView else { return }
        validScrollView.bounces = false
        isRefreshing = true
        /// may update UI
        dispatch_async(dispatch_get_main_queue(), {[weak self] in
            guard let validSelf = self else { return }
            
            UIView.animateWithDuration(0.25, animations: {
                if validSelf.refreshViewType == .header {
                    validScrollView.contentInset.top = validSelf.scrollViewOriginalValue.contentInsetTop + validSelf.bounds.height
                } else {
                    let offPartHeight = validScrollView.contentSize.height - validSelf.heightOfContentOnScreenOfScrollView(validScrollView)
                    /// contentSize改变的时候设置的self.y不同导致不同的结果
                    /// 所有内容高度>屏幕上显示的内容高度
                    let notSureBottom = validSelf.scrollViewOriginalValue.contentInsetBottom + validSelf.bounds.height
                    validScrollView.contentInset.bottom = offPartHeight>=0 ? notSureBottom : notSureBottom - offPartHeight // 加上
                    
                }
                
                }, completion: { (_) in
                    /// 这个时候才正式刷新
                    validScrollView.bounces = true
                    validSelf.isGestureBegin = false
                    validSelf.refreshViewState = .loading
                    validSelf.refreshAnimator.refreshDidBegin(validSelf, refreshViewType: validSelf.refreshViewType)
                    validSelf.refreshHandler()
            })
            
        })
        
    }
    
    private func stopAnimation() {
        guard let validScrollView = scrollView else { return }
        if !isRefreshing { return }
        isRefreshing = false
        isAnimating = true
//        print("endAnimation ---    \(scrollViewOriginalValue.contentInset.top)")

        dispatch_async(dispatch_get_main_queue(), {[weak self] in
            guard let validSelf = self else { return }
            
            UIView.animateWithDuration(0.25, animations: {
                if validSelf.refreshViewType == .header {
                    validScrollView.contentInset.top += validSelf.insetTopDelta;
                } else {
                    validScrollView.contentInset.bottom = validSelf.scrollViewOriginalValue.contentInsetBottom
                }
                
                }, completion: { (_) in
                    
                    // refresh end
                    validScrollView.bounces = validSelf.scrollViewOriginalValue.bounces
//                    print("endAnimation ---    \(self!.scrollView?.contentInset.top)")
                    validSelf.isAnimating = false
                    validSelf.refreshAnimator.refreshDidChangeProgress(validSelf, progress: 1.0, refreshViewType: validSelf.refreshViewType)
                    validSelf.refreshAnimator.refreshDidEnd(validSelf, refreshViewType: validSelf.refreshViewType)
                    validSelf.refreshViewState = .normal
                    validSelf.hidden = validSelf.refreshAnimator.isAutomaticlyHidden;
            })
            
        })
        
    }
    
}

// MARK: - KVO
extension RefreshView {
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &ConstantValue.RefreshViewContext {
            
            if keyPath == ConstantValue.ScrollViewContentSizePath {
                
                guard let validScrollView = scrollView,
                    let oldSize = change?[NSKeyValueChangeOldKey]?.CGSizeValue(),
                    let newSize = change?[NSKeyValueChangeNewKey]?.CGSizeValue()
                    where oldSize != newSize &&
                        refreshViewType == .footer
                    else { return }
                
                /// 设置刷新控件self的位置
                let contentOnScreenHeight = heightOfContentOnScreenOfScrollView(validScrollView)
                /// 添加在scrollView"外面"
                // 当scrollView的内容总高度 < scrollView的高度的时候, 设置为contentOnScreenHeight
                self.frame.origin.y = max(newSize.height, contentOnScreenHeight)
                //                print("old--*\(oldSize.height)--------*\(newSize.height)")
                
            }
            else if keyPath == ConstantValue.ScrollViewContentOffsetPath {
                
                if let validScrollView = scrollView where object as? UIScrollView == validScrollView {
//                    print(validScrollView.contentInset.top);
                    if refreshViewType == .header {
                        adjustHeaderWhenScrollViewIsScrolling(validScrollView)
                    } else {
                        adjustFooterWhenScrollViewIsScrolling(validScrollView)
                    }
                }
            }
            else {
                super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
                
            }
            
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    private func adjustFooterWhenScrollViewIsScrolling(scrollView: UIScrollView) {
        
        if isRefreshing || isAnimating {/**正在刷新直接返回*/ return }
        
        scrollViewOriginalValue.contentInsetBottom = scrollView.contentInset.bottom
        if scrollView.panGestureRecognizer.state == .Began {// 手势拖拽才能进入下拉状态
            isGestureBegin = true
            /// 计算将出现的OffsetY
            beginAnimatingOffsetY = frame.origin.y - scrollView.bounds.height

            hidden = false
            return
        }
        
        if !isGestureBegin {/**没有拖拽直接返回*/ return }
        
        // 还未出现
        if scrollView.contentOffset.y < beginAnimatingOffsetY {/**底部视图(隐藏)并且还没到显示的临界点*/ return }
        // 计算出现的比例
        let progress = (scrollView.contentOffset.y - beginAnimatingOffsetY) / self.bounds.height
        // 处理状态的改变 -- 和 下拉刷新完全一样
        adjustRefreshViewWithProgress(progress, scrollView: scrollView)
        
    }
    
    
    private func adjustHeaderWhenScrollViewIsScrolling(scrollView: UIScrollView) {
        if isRefreshing {/**正在刷新直接返回*/

            if self.window == nil {
                return
            }
            /// 需要处理这个时候滚动时sectionHeader悬停的问题
            /// 参照MJRefresh
            var insetsTop: CGFloat = 0
            if scrollView.contentOffset.y > -scrollViewOriginalValue.contentInsetTop {
                insetsTop = scrollViewOriginalValue.contentInsetTop
            } else {
                insetsTop = -scrollView.contentOffset.y
            }
            
            insetsTop = min(scrollViewOriginalValue.contentInsetTop + self.bounds.height, insetsTop)
            scrollView.contentInset.top = insetsTop
            insetTopDelta = scrollViewOriginalValue.contentInsetTop - insetsTop;
//            print("--------******   \(scrollView.contentInset.top)")
            return
        }
        /// 刷新状态的时候不能记录为原始的
        if isAnimating {/**stop动画还未执行完成*/ return }
        /// 不在刷新状态的时候都随时记录原始的contentInset
        
        scrollViewOriginalValue.contentInsetTop = scrollView.contentInset.top
        if scrollView.panGestureRecognizer.state == .Began {// 手势拖拽才能进入下拉状态
            isGestureBegin = true
            hidden = false
            return
        }
        
        
        if !isGestureBegin {/**没有拖拽直接返回*/ return }
        
        
        //        print("\(scrollView.contentOffset.y)------*\(-scrollViewOriginalValue.contentInset.top)")
        if scrollView.contentOffset.y > -scrollViewOriginalValue.contentInsetTop {/**头部视图(隐藏)并且还没到显示的临界点*/ return }
        
        // 已经进入拖拽状态, 刷新控件将出现 进行相关操作
        let progress = (-scrollViewOriginalValue.contentInsetTop - scrollView.contentOffset.y) / self.bounds.height
        
        adjustRefreshViewWithProgress(progress, scrollView: scrollView)
    }
    
    private func adjustRefreshViewWithProgress(progress: CGFloat, scrollView: UIScrollView) {
        
//        print(progress)
        
        if scrollView.tracking {
            
            if progress >= 1.0 {
                refreshViewState = .releaseToFresh
                
            } else if progress <= 0.0 {
                refreshViewState = .normal
            } else {
                refreshViewState = .pullToRefresh
            }
            
        }
        else if refreshViewState == .releaseToFresh {// releaseToFreah 2 refresh
            canBegin = true// begin refresh
        }
        else {// release
            if progress <= 0.0 {
                refreshViewState = .normal
            }
            
        }
        
        var actualProgress = min(1.0, progress)
        actualProgress = max(0.0, actualProgress)
        refreshAnimator.refreshDidChangeProgress(self, progress: actualProgress, refreshViewType: refreshViewType)
    }
    
    /// 显示在屏幕上的内容高度
    private func heightOfContentOnScreenOfScrollView(scrollView: UIScrollView) -> CGFloat {
        return scrollView.bounds.height - scrollView.contentInset.top - scrollView.contentInset.bottom
    }
    
    
    private func addObserverOf(scrollView: UIScrollView?) {
        scrollView?.addObserver(self, forKeyPath: ConstantValue.ScrollViewContentOffsetPath, options: .Initial, context: &ConstantValue.RefreshViewContext)
        scrollView?.addObserver(self, forKeyPath: ConstantValue.ScrollViewContentSizePath, options: [.Old, .New], context: &ConstantValue.RefreshViewContext)
        
    }
    
    private func removeObserverOf(scrollView: UIScrollView?) {
        scrollView?.removeObserver(self, forKeyPath: ConstantValue.ScrollViewContentOffsetPath, context: &ConstantValue.RefreshViewContext)
        scrollView?.removeObserver(self, forKeyPath: ConstantValue.ScrollViewContentSizePath, context: &ConstantValue.RefreshViewContext)
        
    }
}
