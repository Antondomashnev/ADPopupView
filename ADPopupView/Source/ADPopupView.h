//
//  GraphCheckinPopup.h
//  InFlow
//
//  Created by Anton Domashnev on 22.02.13.
//
//

#import <UIKit/UIKit.h>

@class ADPopupView;

@protocol ADPopupViewDelegate<NSObject>

@optional
- (void)ADPopupViewDidTap:(ADPopupView *)popup;

@end

@interface ADPopupView : UIView

- (id)initAtPoint:(CGPoint)point delegate:(id<ADPopupViewDelegate>)theDelegate withMessage:(NSString *)theMessage;

- (id)initAtPoint:(CGPoint)point delegate:(id<ADPopupViewDelegate>)theDelegate withContentView:(UIView *)contentView;

- (void)hide:(BOOL)animated;

- (void)showInView:(UIView *)view animated:(BOOL)animated;

/*
 Popup message
*/
@property (nonatomic, strong) NSString *message;

/*
 Popup message font
*/
@property (nonatomic, strong) UIFont *messageLabelFont;

/*
 Popup message color
*/
@property (nonatomic, strong) UIColor *messageLabelTextColor;

/*
 Background color
 */
@property (nonatomic, strong) UIColor *popupColor;

@end
