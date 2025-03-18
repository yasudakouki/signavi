import UIKit

/// 子: スワイプ操作で複数のスライドを切り替える UIPageViewController
class TutorialPageViewController: UIPageViewController,
                                 UIPageViewControllerDataSource,
                                 UIPageViewControllerDelegate {
    // カスタムinit
    required init?(coder aDecoder: NSCoder) {
        // .scroll や .horizontalを指定
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
    }
    
    /// 親に対してページ切り替えを通知するdelegate
    weak var pageDelegate: TutorialPageDelegate?

    /// スライド一覧 (7枚想定)
    var slides: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self

        // Storyboard上の Slide1ViewController ~ Slide7ViewController を生成
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let s1 = sb.instantiateViewController(withIdentifier: "Slide1ViewController")
        let s2 = sb.instantiateViewController(withIdentifier: "Slide2ViewController")
        let s3 = sb.instantiateViewController(withIdentifier: "Slide3ViewController")
        let s4 = sb.instantiateViewController(withIdentifier: "Slide4ViewController")
        let s5 = sb.instantiateViewController(withIdentifier: "Slide5ViewController")
        let s6 = sb.instantiateViewController(withIdentifier: "Slide6ViewController")
        let s7 = sb.instantiateViewController(withIdentifier: "Slide7ViewController")

        slides = [s1, s2, s3, s4, s5, s6, s7]

        // 最初のページを表示
        if let firstVC = slides.first {
            setViewControllers([firstVC],
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
    }

    // MARK: - UIPageViewControllerDataSource

    /// 前のページ
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = slides.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return slides[index - 1]
    }

    /// 次のページ
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = slides.firstIndex(of: viewController), index < slides.count - 1 else {
            return nil
        }
        return slides[index + 1]
    }

    // MARK: - UIPageViewControllerDelegate

    /// スワイプ完了(ページ切り替え後)に呼ばれる
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed,
           let currentVC = viewControllers?.first,
           let index = slides.firstIndex(of: currentVC) {
            
            // 親に通知: 現在何番目のページ？
            pageDelegate?.pageDidChange(to: index)
        }
    }
}
