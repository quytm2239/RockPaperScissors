//
//  Toast.swift
//  Pods
//
//  Created by LINAICAI on 2017/11/21.
//
import UIKit
import Foundation
import SnapKit
public class Toast {
    //Toast展示的时间
    public enum Duration {
        case short
        case long
        case custom(TimeInterval)
    }
    //Toast展示的位置
    public enum Gravity {
        case top
        case center
        case bottom
        case left
        case right
        case custom(CGPoint)
    }
    
    ///Toast提示内容文本
    public var text:String?
    
    ///Toast弹出位置(默认为枚举量.center)
    public var gravity:Gravity = .center
    
    ///Toast弹出位置偏移(默认为枚举量.zero)
    public var offset:CGPoint = CGPoint.zero
    
    ///Toast持续时间(默认为枚举量.short)
    public var duration:Duration = .short
    
    ///Toast内边距(默认值)
    public var padding:CGFloat = 15
    
    ///Toast外边距(默认值)
    public var margin:CGFloat = 50
    
    ///Toast圆角(默认值)
    public var cornerRadius:CGFloat = 8
    
    private lazy var contentView: UIView = {
        let view:UIView = UIView()
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        let label:UILabel = UILabel()
        label.text = self.text
        label.numberOfLines = 0
        label.textColor = UIColor.white
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.edges.equalTo(UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
            
        }
        return view
    }()
    public var view: UIView {
        get {
            return self.contentView
        }
        set {
            self.contentView = newValue
        }
    }
    ///便利构造器
    public required convenience init(_ text:String? = nil , _ gravity:Gravity = .center) {
        self.init()
        self.text = text
        self.gravity = gravity
    }
    ///展示一个Toast视图
    public func show(_ view:UIView? , _ duration:Duration = .short) {
        let contentView = self.contentView
        view?.addSubview(contentView)
        contentView.snp.makeConstraints({ (make) in
            make.width.lessThanOrEqualToSuperview().offset(-margin)
            
            let gravity:Gravity = self.gravity
            let offset:CGPoint = self.offset
            switch gravity {
            case .center:
                make.centerX.equalToSuperview().offset(offset.x)
                make.centerY.equalToSuperview().offset(offset.y)
                break
            case .top:
                make.centerX.equalToSuperview().offset(offset.x)
                make.top.equalToSuperview().offset(offset.y+margin)
                break
            case .bottom:
                make.centerX.equalToSuperview().offset(offset.x)
                make.bottom.equalToSuperview().offset(offset.y-margin)
                break
            case .left:
                make.left.equalToSuperview().offset(offset.x+margin)
                make.centerY.equalToSuperview().offset(offset.y)
                break
            case .right:
                make.right.equalToSuperview().offset(offset.x-margin)
                make.centerY.equalToSuperview().offset(offset.y)
                break
            case .custom(let gravity):
                make.centerX.equalTo(gravity.x)
                make.centerY.equalTo(gravity.y)
                break
            }
            
        })
        
        ///动画
        contentView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        contentView.alpha = 0.0
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            contentView.transform = CGAffineTransform.identity
            contentView.alpha = 1.0
        }) { (_) in
            
        }
        ///展示时间
        var time: TimeInterval
        switch duration {
        case .short:
            time = 1.5
            break
        case .long:
            time = 3.0
            break
        case .custom(let customTime):
            time = customTime
            break
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            UIView.animate(withDuration: 0.25, animations: {
                contentView.alpha = 0.0
            }, completion: { (_) in
                contentView.removeFromSuperview()
            })
        }
    }
}
