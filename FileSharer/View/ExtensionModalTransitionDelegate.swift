//
//  ExtensionTransitionDelegate.swift
//  FileSharer
//
//  Created by modao on 2018/2/7.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit

class EXModalTransitionExtensionDelegate: NSObject, UIViewControllerTransitioningDelegate {


    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let overlayAnimationController = OverlayAnimationController()
        return overlayAnimationController
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let overlayAnimationController = OverlayAnimationController()
        return overlayAnimationController
    }


    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        let presentationController = OverlayPresentationController(presentedViewController: presented,
                                                                   presenting: presenting)
        return presentationController
    }
}

class OverlayAnimationController:NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController =  transitionContext.viewController(forKey: .from),
            let toController = transitionContext.viewController(forKey: .to) else {
            return
        }
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        if toController.isBeingPresented, let toView = toController.view {
            containerView.addSubview(toView)
            toView.center = containerView.center
            toView.bounds = CGRect(origin: .zero,
                                   size: CGSize(width: contentWidth,
                                                height: contentHeight))
            toView.transform = CGAffineTransform(a: 0.01,
                                                 b: 0,
                                                 c: 0,
                                                 d: 0.01,
                                                 tx: 0,
                                                 ty: 0)
            UIView.animate(withDuration: duration,
                           delay: 0,
                           options: .curveEaseIn, animations: {
                            toView.transform = CGAffineTransform(a: 1.05,
                                                                 b: 0,
                                                                 c: 0,
                                                                 d: 1.05,
                                                                 tx: 0,
                                                                 ty: 0)
            }) { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    toView.transform = CGAffineTransform(a: 1,
                                                         b: 0,
                                                         c: 0,
                                                         d: 1,
                                                         tx: 0,
                                                         ty: 0)
                }) { isComplete in
                    toView.transform = .identity
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled && isComplete)
                }
            }
        }
         //Dismissal 转场中不要将 toView 添加到 containerView
        fromViewController.view.transform = CGAffineTransform(a: 1,
                                                              b: 0,
                                                              c: 0,
                                                              d: 1,
                                                              tx: 0,
                                                              ty: 0)
        if fromViewController.isBeingDismissed {
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                fromViewController.view.transform =  CGAffineTransform(a: 0.01,
                                                                       b: 0,
                                                                       c: 0,
                                                                       d: 0.01,
                                                                       tx: 0,
                                                                       ty: 0)
            }) { isCompleted in
                fromViewController.view.transform = .identity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled && isCompleted)
            }
        }
    }
}

class OverlayPresentationController: UIPresentationController {

    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.bounds = CGRect(origin: .zero,
                             size: CGSize(width: contentWidth,
                                          height: contentWidth))
        view.backgroundColor = .clear
        return view
    }()

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }
        containerView.addSubview(dimmingView)
        dimmingView.center = containerView.center
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.bounds = containerView.bounds
        })
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }

    override func containerViewWillLayoutSubviews(){
        guard let containerView = containerView else {
            return
        }
        dimmingView.center = containerView.center
        dimmingView.bounds = containerView.bounds
        presentedView?.center = containerView.center
        presentedView?.bounds = CGRect(x: 0, y: 0, width: contentWidth, height: contentHeight)
    }
}
