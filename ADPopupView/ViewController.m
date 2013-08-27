//
//  ViewController.m
//  ADPopupView
//
//  Created by Anton Domashnev on 26.02.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "ViewController.h"
#import "ADPopupView.h"

@interface ViewController ()<ADPopupViewDelegate>

@property (nonatomic, strong) ADPopupView *visiblePopup;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TestPopupContentView

+ (float)randFloatBetween:(float)low and:(float)high {

    float diff = high - low;
    return (((float)rand() / RAND_MAX) * diff) + low;
}

- (CGSize)randomContentViewSize {

    float minWidth = 50;
    float maxWidth = 200;

    float minHeight = 30;
    float maxHeight = 100;

    return CGSizeMake([ViewController randFloatBetween:minWidth and:maxWidth], [ViewController randFloatBetween:minHeight and:maxHeight]);
}

- (UIView *)contentView {

    CGRect contentViewFrame = CGRectZero;
    contentViewFrame.size = [self randomContentViewSize];

    UIView *contentView = [[UIView alloc] initWithFrame:contentViewFrame];

    contentView.backgroundColor = [UIColor redColor];

    return contentView;
}

- (void)presentPopupAtPointWithContentViewAtPoint:(CGPoint)point {

    //[self.visiblePopup hide: YES];

    if (arc4random_uniform(2)) {

        self.visiblePopup = [[ADPopupView alloc] initAtPoint:point delegate:self withMessage:@"ADPopupView is very useful view to show some text or whatever UIVIew content"];

        [self.visiblePopup showInView:self.view animated:YES];
    }
    else {

        self.visiblePopup = [[ADPopupView alloc] initAtPoint:point delegate:self withContentView:[self contentView]];

        [self.visiblePopup showInView:self.view animated:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];

    [self presentPopupAtPointWithContentViewAtPoint:touchPoint];
}

@end
