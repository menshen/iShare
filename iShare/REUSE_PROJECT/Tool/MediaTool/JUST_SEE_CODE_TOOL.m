//
//  JUST_SEE_CODE_TOOL.m
//  hihi
//
//  Created by 伍松和 on 15/1/12.
//  Copyright (c) 2015年 伍松和. All rights reserved.
//

#import "JUST_SEE_CODE_TOOL.h"

@implementation JUST_SEE_CODE_TOOL
//- (void)fixFrame
//{
//    CGRect frame = [UIScreen mainScreen].bounds;
//    if (OSVersionIsAtLeastiOS7 == YES) {
//        // self.edgesForExtendedLayout = UIRectEdgeBottom;
//        self.edgesForExtendedLayout = UIRectEdgeBottom;//UIRectEdgeBottom
//        self.extendedLayoutIncludesOpaqueBars = NO;
//        self.modalPresentationCapturesStatusBarAppearance = NO;
//        self.automaticallyAdjustsScrollViewInsets = YES;
//    }else{
//        frame.size.height -= 20 + 44;
//    }
//
//    self.view.frame = frame;
//    self.view.bounds = frame;
//}
//-(void)handleWillHideKeyboard:(NSNotification *)notification{
//
//    [self keyboardWillChange:notification];
//
//
//}
//-(void)handleWillShowKeyboard:(NSNotification *)notification{
//    [self keyboardWillChange:notification];
//
//}
//-(void)keyboardWillChange:(NSNotification*)notification{
//
//    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    BOOL  showKeyborad= ([notification.name isEqualToString:UIKeyboardWillShowNotification]) ? YES : NO;
//
//    UIViewAnimationOptions options =[self RDRAnimationOptionsForCurve:curve];
//    [UIView animateWithDuration:duration
//                          delay:0.0
//                        options:options
//                     animations:^{
//                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
//
//                         CGRect inputViewFrame = self.messageInputView.frame;
//                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
//
//                         // for ipad modal form presentations
//                         CGFloat messageViewFrameBottom = self.view.frame.size.height - inputViewFrame.size.height;
//                         if (inputViewFrameY > messageViewFrameBottom)
//                             inputViewFrameY = messageViewFrameBottom;
//
//                         self.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
//                                                                  inputViewFrameY,
//                                                                  inputViewFrame.size.width,
//                                                                  inputViewFrame.size.height);
//
//                         [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
//                          - self.messageInputView.frame.origin.y];
//                         if (showKeyborad)
//                             [self scrollToBottomAnimated:NO];
//                     }
//                     completion:nil];
//
//
//}
#pragma mark -切换键盘/其他
//- (void)layoutOtherMenuViewHiden:(BOOL)hide {
//    [self.messageInputView.textView resignFirstResponder];
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        __block CGRect inputViewFrame = self.messageInputView.frame;
//        __block CGRect otherMenuViewFrame;
//
//        void (^InputViewAnimation)(BOOL hide) = ^(BOOL hide) {
//            inputViewFrame.origin.y = (hide ? (CGRectGetHeight(self.view.bounds) - CGRectGetHeight(inputViewFrame)) : (CGRectGetMinY(otherMenuViewFrame) - CGRectGetHeight(inputViewFrame)));
//            self.messageInputView.frame = inputViewFrame;
//        };
//
//        void (^EmotionManagerViewAnimation)(BOOL hide) = ^(BOOL hide) {
//            otherMenuViewFrame = self.emotionManagerView.frame;
//            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
//            self.emotionManagerView.alpha = !hide;
//            self.emotionManagerView.frame = otherMenuViewFrame;
//        };
//
//        void (^ShareMenuViewAnimation)(BOOL hide) = ^(BOOL hide) {
//            otherMenuViewFrame = self.shareMenuView.frame;
//            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
//            self.shareMenuView.alpha = !hide;
//            self.shareMenuView.frame = otherMenuViewFrame;
//        };
//
//        if (hide) {
//           EmotionManagerViewAnimation(hide);
//            ShareMenuViewAnimation(hide);
//
//        } else {
//
//            // 这里需要注意block的执行顺序，因为otherMenuViewFrame是公用的对象，所以对于被隐藏的Menu的frame的origin的y会是最大值
//            switch (self.textViewInputViewType) {
//                case BaseInputViewTypeFace: {
//                    // 1、先隐藏和自己无关的View
//                    ShareMenuViewAnimation(!hide);
//                    // 2、再显示和自己相关的View
//                    EmotionManagerViewAnimation(hide);
//                    break;
//                }
//                case BaseInputViewTypeOther: {
//                    // 1、先隐藏和自己无关的View
//                    EmotionManagerViewAnimation(!hide);
//                    // 2、再显示和自己相关的View
//                    ShareMenuViewAnimation(hide);
//                    break;
//                }
//                default:
//                    break;
//            }
//        }
//
//        InputViewAnimation(hide);
//
//        [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
//         - self.messageInputView.frame.origin.y];
//        [self scrollToBottomAnimated:NO];
//
//    } completion:^(BOOL finished) {
//    }];
//}



@end
