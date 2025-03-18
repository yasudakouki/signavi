import UIKit

/// UIPageViewController がページ切り替え完了時に、現在ページを親に通知するためのプロトコル
protocol TutorialPageDelegate: AnyObject {
    func pageDidChange(to index: Int)
}

/// 親: 下部に UIPageControl を配置し、中央の ContainerView で TutorialPageViewController をEmbed
class TutorialContainerViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!  // Storyboardで配置した UIPageControl(下部のページ示すやつ)
    
    /// 子の TutorialPageViewController への参照（任意だが、使いたい場合に保持する）
    weak var pageVC: TutorialPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // スライド数に応じて初期設定
        pageControl.numberOfPages = 7   // 今回は7枚想定
        pageControl.currentPage = 0

        // **ダークモード対応の色設定**
        updatePageControlColors()
    }
    
    /// ContainerView の Embed Segue で呼ばれる。子ViewController が生成される
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let childVC = segue.destination as? TutorialPageViewController {
            // 子VCを保持
            self.pageVC = childVC
            // 親が子からの通知を受け取るようにdelegate設定
            childVC.pageDelegate = self
        }
    }
    
    /// **ダークモード/ライトモードが切り替わった時に呼ばれる**
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // UIモードが変更されたら、PageControl の色を更新
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updatePageControlColors()
        }
    }

    /// **PageControl の色を更新する**
    func updatePageControlColors() {
        if traitCollection.userInterfaceStyle == .dark {
            pageControl.pageIndicatorTintColor = UIColor.lightGray   // 非アクティブなドット (ダークモード時)
            pageControl.currentPageIndicatorTintColor = UIColor.white  // アクティブなドット (ダークモード時)
        } else {
            pageControl.pageIndicatorTintColor = UIColor.lightGray   // 非アクティブなドット (ライトモード時)
            pageControl.currentPageIndicatorTintColor = UIColor.black  // アクティブなドット (ライトモード時)
        }
    }
}

// MARK: - TutorialPageDelegate
extension TutorialContainerViewController: TutorialPageDelegate {
    /// 子VCから「ページが index に変わったよ」と通知を受け取る
    func pageDidChange(to index: Int) {
        pageControl.currentPage = index
    }
}
