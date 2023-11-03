//
//  Created by Pete Smith
//  http://www.petethedeveloper.com
//
//
//  License
//  Copyright © 2017-present Pete Smith
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

import UIKit

/*
 This cell subclass is intended to be used together with ScalingCarouselView
 
 This class adds a method used to scale the cell
 in relation to the cell's position in the top level window.
 
 Collection view cells used with ScalingCarouselView should subclass this type
 */
open class ScalingCarouselCell: UICollectionViewCell {
    
    // MARK: - Properties (Public)
    
    /// The minimum value to scale to, should be set between 0 and 1
//    open var scaleMinimum: CGFloat = 0.9
    open var scaleMinimum: CGFloat = 0.7
    
    /// Divisior used when calculating the scale value.
    /// Lower values cause a greater difference in scale between subsequent cells.
    open var scaleDivisor: CGFloat = 10.0
    
    /// The minimum value to alpha to, should be set between 0 and 1
    open var alphaMinimum: CGFloat = 0.85
    
    /// The corner radius value of the cell's main view
    open var cornerRadius: CGFloat = 30
    
    // MARK: - IBOutlets
    
    // This property should be connected to the main cell subview
    @IBOutlet public var mainView: UIView!
    
    @IBOutlet weak var characterImageView: UIImageView!
    
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var nameBackgroundView: UIView!
    
    @IBOutlet weak var nameTrailingAnchor: NSLayoutConstraint!
    @IBOutlet weak var nameBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var nameLeadingAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    
    // MARK: - Overrides
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        guard let carouselView = superview as? ScalingCarouselView else { return }
        
        scale(withCarouselInset: carouselView.inset)
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        mainView.transform = CGAffineTransform.identity
        mainView.alpha = 1.0
        
        characterImageView.transform = CGAffineTransform.identity
        characterImageView.alpha = 1.0
        
        nameTextLabel.transform = CGAffineTransform.identity
        nameTextLabel.alpha = 1.0
        
        nameBackgroundView.transform = CGAffineTransform.identity
        nameBackgroundView.alpha = 1.0

    }
    
    /// Scale the cell when it is scrolled
    ///
    /// - parameter carouselInset: The inset of the related SPBCarousel view
    open func scale(withCarouselInset carouselInset: CGFloat) {
        
        // Ensure we have a superView, and mainView
        guard let superview = superview,
            let mainView = mainView,
              let imageView = characterImageView,
        let nameBgView = nameBackgroundView,
        let nameTextLabel = nameTextLabel else { return }
        
        // Get our absolute origin value and width/height based on the scroll direction
        var origin = superview.convert(frame, to: superview.superview).origin.x
        var contentWidthOrHeight = frame.size.width
        if let collectionView = superview as? ScalingCarouselView, collectionView.scrollDirection == .vertical {
            origin = superview.convert(frame, to: superview.superview).origin.y
            contentWidthOrHeight = frame.size.height
        }
        
        // Calculate our actual origin.x value using our inset
        let originActual = origin - carouselInset
        
        // Calculate our scale values
        let scaleCalculator = abs(contentWidthOrHeight - abs(originActual))
        let percentageScale = (scaleCalculator/contentWidthOrHeight)
        
        let scaleValue = scaleMinimum
            + (percentageScale/scaleDivisor)
        
        let alphaValue = alphaMinimum
            + (percentageScale/scaleDivisor)
        
        let affineIdentity = CGAffineTransform.identity
        
        let isFocused = scaleValue >= 0.78
        
        // Scale our mainView and set it's alpha value
        mainView.transform = affineIdentity.scaledBy(x: scaleValue, y: scaleValue)
        mainView.layer.cornerRadius = cornerRadius
        
        imageView.transform = affineIdentity.scaledBy(x: scaleValue, y: scaleValue)
        imageView.layer.cornerRadius = cornerRadius
        
        nameBgView.transform = affineIdentity.scaledBy(x: scaleValue, y: scaleValue)
        nameBgView.clipsToBounds = true
        nameBgView.layer.cornerRadius = cornerRadius
        nameBgView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        UIView.animate(withDuration: 0.3) {
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = isFocused ?  AtoStudyColor.Primary900.color.cgColor : UIColor.clear.cgColor
            
            self.nameTrailingAnchor.constant = isFocused ? -2 : 0
            self.nameBottomAnchor.constant = isFocused ? -2 : 0
            self.nameLeadingAnchor.constant = isFocused ? 2 : 0
        }
        
        let imageMinY = imageView.frame.minY
        
        self.nameBottomAnchor.constant = (imageMinY+9)*scaleValue
        
        self.layoutIfNeeded()
        self.setNeedsLayout()
        
        nameTextLabel.transform = affineIdentity.scaledBy(x: scaleValue, y: scaleValue)

        mainView.layer.masksToBounds = false
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0, height: 10)
        mainView.layer.shadowRadius = 5
        mainView.layer.shadowOpacity = 0.2

        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        nameTextLabel.font = UIFont(name: AtoStudyFont.Bold.font, size: 16)
    }
}
