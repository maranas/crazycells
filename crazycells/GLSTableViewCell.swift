//
//  GLSTableViewCell.swift
//  crazycells
//
//  Created by Moises Anthony Aranas on 7/11/15.
//  Copyright © 2015 ganglion software. All rights reserved.
//

import UIKit

enum GLSTableViewCellAnimationType:Int {
    case zoom
    case slideFromRight, slideFromLeft
    case cardShuffle
    case blinds
    case flipIn, flipInLeft, flipInRight
    
    static func random() -> GLSTableViewCellAnimationType {
        let max = flipInRight.rawValue
        return GLSTableViewCellAnimationType(rawValue:Int(arc4random_uniform(UInt32(max + 1))))!
    }
}

class GLSTableViewCell: UITableViewCell {
    var animationType:GLSTableViewCellAnimationType = GLSTableViewCellAnimationType.flipIn
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func zoomAnimation(_ duration:TimeInterval)
    {
        self.contentView.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1.0)
        let oldColor:UIColor? = self.contentView.backgroundColor
        weak var weakSelf = self
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            weakSelf?.contentView.layer.transform = CATransform3DIdentity
            weakSelf?.contentView.backgroundColor = oldColor
            }, completion: nil)
    }
    
    func slideAnimation(_ startX:CGFloat, duration:TimeInterval)
    {
        weak var weakSelf = self
        self.contentView.layer.transform = CATransform3DMakeTranslation(startX, 0, 0);
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            weakSelf?.contentView.layer.transform = CATransform3DIdentity
            }, completion: nil)
    }
    
    func animateFromTransform(_ transform:CATransform3D, duration:TimeInterval)
    {
        weak var weakSelf = self
        let oldColor:UIColor? = self.contentView.backgroundColor
        self.contentView.backgroundColor = UIColor.gray
        self.contentView.layer.transform = transform
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
            weakSelf?.contentView.layer.transform = CATransform3DIdentity
            weakSelf?.contentView.backgroundColor = oldColor
            }, completion: nil)
    }
    
    func shuffleTransform(_ z:CGFloat, scale:CGFloat) -> CATransform3D
    {
        var transform:CATransform3D = CATransform3DIdentity;
        transform.m34 = 1.0 / z;
        transform = CATransform3DScale(transform, scale, scale, scale)
        transform = CATransform3DTranslate(transform, 0.0, (-self.contentView.frame.size.height)/2, 0.0)
        transform = CATransform3DRotate(transform, CGFloat(Double.pi/2.0), 1.0, 0.0, 0.0)
        transform = CATransform3DTranslate(transform, 0.0, (self.contentView.frame.size.height)/2, 0.0)
        return transform
    }
    
    func flipInTransform() -> CATransform3D
    {
        var transform:CATransform3D = CATransform3DIdentity;
        transform.m34 = 1.0 / -600;
        transform = CATransform3DRotate(transform, CGFloat(Double.pi/2.0), 0.0, 1.0, 0.0)
        return transform
    }
    
    func flipInLeftTransform() -> CATransform3D
    {
        var transform:CATransform3D = CATransform3DIdentity;
        transform.m34 = 1.0 / -600;
        transform = CATransform3DTranslate(transform, (-self.contentView.frame.size.width)/2, 0.0, 0.0)
        transform = CATransform3DRotate(transform, CGFloat(Double.pi/2.0), 0.0, 1.0, 0.0)
        transform = CATransform3DTranslate(transform, (self.contentView.frame.size.width)/2, 0.0, 0.0)
        return transform
    }
    
    func flipInRightTransform() -> CATransform3D
    {
        var transform:CATransform3D = CATransform3DIdentity;
        transform.m34 = 1.0 / -600;
        transform = CATransform3DTranslate(transform, (self.contentView.frame.size.width)/2, 0.0, 0.0)
        transform = CATransform3DRotate(transform, CGFloat(Double.pi/2.0), 0.0, 1.0, 0.0)
        transform = CATransform3DTranslate(transform, (-self.contentView.frame.size.width)/2, 0.0, 0.0)
        return transform
    }
    
    func animateIn(_ duration:TimeInterval) {
        weak var weakSelf = self
        self.contentView.isHidden = true
        DispatchQueue.main.async { () -> Void in
            if let unwrappedType = weakSelf?.animationType {
                weakSelf?.contentView.isHidden = false
                switch unwrappedType as GLSTableViewCellAnimationType
                {
                    case GLSTableViewCellAnimationType.slideFromRight:
                        weakSelf?.slideAnimation((weakSelf?.contentView.frame.size.width)!, duration:duration)
                    case GLSTableViewCellAnimationType.slideFromLeft:
                        weakSelf?.slideAnimation(-(weakSelf?.contentView.frame.size.width)!, duration:duration)
                    case GLSTableViewCellAnimationType.cardShuffle:
                        weakSelf?.animateFromTransform((weakSelf?.shuffleTransform(-600, scale:0.7))!, duration: duration)
                    case GLSTableViewCellAnimationType.blinds:
                        weakSelf?.animateFromTransform((weakSelf?.shuffleTransform(-300, scale:1.0))!, duration: duration)
                    case GLSTableViewCellAnimationType.flipIn:
                        weakSelf?.animateFromTransform((weakSelf?.flipInTransform())!, duration: duration)
                    case GLSTableViewCellAnimationType.flipInLeft:
                        weakSelf?.animateFromTransform((weakSelf?.flipInLeftTransform())!, duration: duration)
                    case GLSTableViewCellAnimationType.flipInRight:
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
