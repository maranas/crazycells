//
//  GLSTableViewCell.swift
//  crazycells
//
//  Created by Moises Anthony Aranas on 7/11/15.
//  Copyright © 2015 ganglion software. All rights reserved.
//

import UIKit

enum GLSTableViewCellAnimationType:Int {
    case Zoom
    case SlideFromRight, SlideFromLeft
    case CardShuffle
    case Blinds
    case FlipIn, FlipInLeft, FlipInRight
    
    static func random() -> GLSTableViewCellAnimationType {
        let max = FlipInRight.rawValue
        return GLSTableViewCellAnimationType(rawValue:Int(arc4random_uniform(UInt32(max + 1))))!
    }
}

class GLSTableViewCell: UITableViewCell {
    var animationType:GLSTableViewCellAnimationType = GLSTableViewCellAnimationType.FlipIn
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func zoomAnimation(duration:NSTimeInterval)
    {
        self.contentView.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1.0)
        let oldColor:UIColor? = self.contentView.backgroundColor
        weak var weakSelf = self
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            weakSelf?.contentView.layer.transform = CATransform3DIdentity
            weakSelf?.contentView.backgroundColor = oldColor
            }, completion: nil)
    }
    
    func slideAnimation(startX:CGFloat, duration:NSTimeInterval)
    {
        weak var weakSelf = self
        self.contentView.layer.transform = CATransform3DMakeTranslation(startX, 0, 0);
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            weakSelf?.contentView.layer.transform = CATransform3DIdentity
            }, completion: nil)
    }
    
    func animateFromTransform(transform:CATransform3D, duration:NSTimeInterval)
    {
        weak var weakSelf = self
        let oldColor:UIColor? = self.contentView.backgroundColor
        self.contentView.backgroundColor = UIColor.grayColor()
        self.contentView.layer.transform = transform
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            weakSelf?.contentView.layer.transform = CATransform3DIdentity
            weakSelf?.contentView.backgroundColor = oldColor
            }, completion: nil)
    }
    
    func shuffleTransform(z:CGFloat, scale:CGFloat) -> CATransform3D
    {
        var transform:CATransform3D = CATransform3DIdentity;
        transform.m34 = 1.0 / z;
        transform = CATransform3DScale(transform, scale, scale, scale)
        transform = CATransform3DTranslate(transform, 0.0, (-self.contentView.frame.size.height)/2, 0.0)
        transform = CATransform3DRotate(transform, CGFloat(M_PI/2.0), 1.0, 0.0, 0.0)
        transform = CATransform3DTranslate(transform, 0.0, (self.contentView.frame.size.height)/2, 0.0)
        return transform
    }
    
    func flipInTransform() -> CATransform3D
    {
        var transform:CATransform3D = CATransform3DIdentity;
        transform.m34 = 1.0 / -600;
        transform = CATransform3DRotate(transform, CGFloat(M_PI/2.0), 0.0, 1.0, 0.0)
        return transform
    }
    
    func flipInLeftTransform() -> CATransform3D
    {
        var transform:CATransform3D = CATransform3DIdentity;
        transform.m34 = 1.0 / -600;
        transform = CATransform3DTranslate(transform, (-self.contentView.frame.size.width)/2, 0.0, 0.0)
        transform = CATransform3DRotate(transform, CGFloat(M_PI/2.0), 0.0, 1.0, 0.0)
        transform = CATransform3DTranslate(transform, (self.contentView.frame.size.width)/2, 0.0, 0.0)
        return transform
    }
    
    func flipInRightTransform() -> CATransform3D
    {
        var transform:CATransform3D = CATransform3DIdentity;
        transform.m34 = 1.0 / -600;
        transform = CATransform3DTranslate(transform, (self.contentView.frame.size.width)/2, 0.0, 0.0)
        transform = CATransform3DRotate(transform, CGFloat(M_PI/2.0), 0.0, 1.0, 0.0)
        transform = CATransform3DTranslate(transform, (-self.contentView.frame.size.width)/2, 0.0, 0.0)
        return transform
    }
    
    func animateIn(duration:NSTimeInterval) {
        weak var weakSelf = self
        self.contentView.hidden = true
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if let unwrappedType = weakSelf?.animationType {
                weakSelf?.contentView.hidden = false
                switch unwrappedType as GLSTableViewCellAnimationType
                {
                    case GLSTableViewCellAnimationType.SlideFromRight:
                        weakSelf?.slideAnimation((weakSelf?.contentView.frame.size.width)!, duration:duration)
                    case GLSTableViewCellAnimationType.SlideFromLeft:
                        weakSelf?.slideAnimation(-(weakSelf?.contentView.frame.size.width)!, duration:duration)
                    case GLSTableViewCellAnimationType.CardShuffle:
                        weakSelf?.animateFromTransform((weakSelf?.shuffleTransform(-600, scale:0.7))!, duration: duration)
                    case GLSTableViewCellAnimationType.Blinds:
                        weakSelf?.animateFromTransform((weakSelf?.shuffleTransform(-300, scale:1.0))!, duration: duration)
                    case GLSTableViewCellAnimationType.FlipIn:
                        weakSelf?.animateFromTransform((weakSelf?.flipInTransform())!, duration: duration)
                    case GLSTableViewCellAnimationType.FlipInLeft:
                        weakSelf?.animateFromTransform((weakSelf?.flipInLeftTransform())!, duration: duration)
                    case GLSTableViewCellAnimationType.FlipInRight:
                        weakSelf?.animateFromTransform((weakSelf?.flipInRightTransform())!, duration: duration)
                    default:
                        weakSelf?.zoomAnimation(duration)
                }
            }
        }
    }
    
    func animateOut() {
        
    }

}
