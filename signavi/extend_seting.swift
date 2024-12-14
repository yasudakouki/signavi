import UIKit

// @IBDesignableを付与する事で、Storyboard上に設定した値が反映される
@IBDesignable
class TapAreaExpandableButton: UIButton {
    private var _minTapArea = CGSize(width: 0, height: 0)
    private var _previewArea = false

    // @IBInspectableを付与した変数は、Interface Builder側で編集できる
    @IBInspectable var minTapArea: CGSize {
        get { return _minTapArea }
        set { _minTapArea = newValue }
    }
    
    @IBInspectable var previewArea: Bool {
        get { return _previewArea }
        set { _previewArea = newValue }
    }
    
    open override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
        if isHidden || !isUserInteractionEnabled { return false }
        return expandedArea.contains(point)
    }
    
    private var expandedArea: CGRect {
        let buttonSize = self.bounds.size
        let widthToAdd = max(_minTapArea.width - buttonSize.width, 0)
        let heightToAdd = max(_minTapArea.height - buttonSize.height, 0)
        return self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        if previewArea { setupPreviewArea() }
    }
    
    private func setupPreviewArea() {
        let tapGuideView = UIView(frame: expandedArea)
        let previewLineColor = UIColor.gray.cgColor // 直接UIColorを使用
        let lineLayer = CAShapeLayer()
        lineLayer.frame = tapGuideView.bounds
        lineLayer.strokeColor = previewLineColor
        lineLayer.lineWidth = 1
        lineLayer.lineDashPattern = [2, 2]
        lineLayer.fillColor = nil
        lineLayer.path = UIBezierPath(rect: lineLayer.frame).cgPath
        tapGuideView.isUserInteractionEnabled = false
        tapGuideView.backgroundColor = UIColor.clear
        tapGuideView.isHidden = false
        tapGuideView.layer.addSublayer(lineLayer)
        addSubview(tapGuideView)
    }
}
