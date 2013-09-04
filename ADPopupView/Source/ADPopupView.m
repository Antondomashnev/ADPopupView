//
//  GraphCheckinPopup.m
//  InFlow
//
//  Created by Anton Domashnev on 22.02.13.
//
//

#import "ADPopupView.h"

typedef enum {
    ptUpLeft,
    ptUpRight,
    ptDownLeft,
    ptDownRight
} EnumPopupType;

#define ALPHA_ANIMATION_DURATION .4f
#define POPUP_CORNER_RADIUS 6.

#define POPUP_MINIMUM_SIZE CGSizeMake(50, 46)
#define POPUP_MAXIMUM_SIZE CGSizeMake(200, 100)

#define POPUP_CONTENT_VIEW_MARGIN 5

#define POPUP_ARROW_EDGE_MARGIN 12
#define POPUP_ARROW_SIZE CGSizeMake(13, 8)

@interface ADPopupView ()

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, unsafe_unretained) EnumPopupType type;
@property (nonatomic, unsafe_unretained) CGPoint presentationPoint;

@property (nonatomic, weak) id<ADPopupViewDelegate> delegate;

@end

@implementation ADPopupView

@synthesize messageLabelTextColor;
@synthesize messageLabelFont;
@synthesize message;
@synthesize popupColor=_popupColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.frame = frame;
    }
    return self;
}

- (id)initAtPoint:(CGPoint)point delegate:(id<ADPopupViewDelegate>)theDelegate withContentView:(UIView *)contentView {

    if (self = [super initWithFrame:CGRectZero]) {

        self.delegate = theDelegate;
        self.type = ptDownRight;

        self.backgroundColor = [UIColor clearColor];
        self.presentationPoint = point;

        self.frame = [self popupFrameForContentView:contentView];

        [self addContentView:contentView];

        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    }

    return self;
}

- (id)initAtPoint:(CGPoint)point delegate:(id<ADPopupViewDelegate>)theDelegate withMessage:(NSString *)theMessage {

    if (self = [super initWithFrame:CGRectZero]) {

        self.message = theMessage;
        self.presentationPoint = point;
        self.delegate = theDelegate;
        self.type = ptDownRight;

        self.backgroundColor = [UIColor clearColor];

        self.messageLabelFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.f];
        self.messageLabelTextColor = [UIColor whiteColor];

        [self redrawPopupWithMessage];

        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    }

    return self;
}

#pragma mark ContentView

- (void)addContentView:(UIView *)view {

    CGPoint contentViewCenter = CGPointMake(self.frame.size.width / 2, 0);

    switch (self.type) {
        case ptDownLeft:
        case ptDownRight:
            contentViewCenter.y = (self.frame.size.height - POPUP_ARROW_SIZE.height) / 2;
            break;
        case ptUpLeft:
        case ptUpRight:
            contentViewCenter.y = (self.frame.size.height - POPUP_ARROW_SIZE.height) / 2 + POPUP_ARROW_SIZE.height;
            break;
        default:
            break;
    }

    view.center = contentViewCenter;

    [self addSubview:view];
}

#pragma mark Redraw

- (void)redrawPopupWithMessage {

    [self.messageLabel removeFromSuperview];

    self.messageLabel = [self contentViewForMessage:self.message];

    self.frame = [self popupFrameForContentView:self.messageLabel];

    [self addContentView:self.messageLabel];
}

#pragma mark MessageLabelFont

- (void)setMessageLabelFont:(UIFont *)_messageLabelFont {

    self->messageLabelFont = _messageLabelFont;

    [self redrawPopupWithMessage];
}

#pragma mark Message

- (void)setMessage:(NSString *)_message {

    self->message = _message;

    [self redrawPopupWithMessage];
}

#pragma mark MessageLabelTextColor

- (void)setMessageLabelTextColor:(UIColor *)_messageLabelTextColor {

    self->messageLabelTextColor = _messageLabelTextColor;

    self.messageLabel.textColor = _messageLabelTextColor;
}

#pragma mark - PopupColor

- (UIColor *)popupColor {
    if (!_popupColor) return [UIColor blackColor];
    return _popupColor;
}

#pragma mark PopupFrame

- (CGSize)popupSizeForContentView:(UIView *)contentView {

    float height = POPUP_MINIMUM_SIZE.height;
    float newHeight = contentView.frame.size.height + POPUP_ARROW_SIZE.height + POPUP_CONTENT_VIEW_MARGIN * 2;

    float width = POPUP_MINIMUM_SIZE.width;
    float newWidth = contentView.frame.size.width + POPUP_CONTENT_VIEW_MARGIN * 2;

    return CGSizeMake(MAX(width, newWidth), MAX(height, newHeight));
}

- (CGRect)popupFrameForContentView:(UIView *)contentView {

    CGRect newFrame = CGRectZero;
    newFrame.size = [self popupSizeForContentView:contentView];

    float originX = self.presentationPoint.x + POPUP_ARROW_EDGE_MARGIN + POPUP_ARROW_SIZE.width - newFrame.size.width;
    if (originX < 0) {

        originX = self.presentationPoint.x - POPUP_ARROW_EDGE_MARGIN * 2 + POPUP_ARROW_SIZE.width / 2;

        self.type = ptDownLeft;
    }

    float originY = self.presentationPoint.y - newFrame.size.height;
    if (originY < 0) {

        originY = self.presentationPoint.y;

        self.type = (self.type == ptDownLeft) ? ptUpLeft : ptUpRight;
    }

    newFrame.origin = CGPointMake(originX, originY);

    return newFrame;
}

#pragma mark CheckinInformationLabel

- (CGSize)sizeForMessage:(NSString *)_message {

    return [_message sizeWithFont:self.messageLabelFont constrainedToSize:POPUP_MAXIMUM_SIZE lineBreakMode:NSLineBreakByWordWrapping];
}

- (UILabel *)contentViewForMessage:(NSString *)_message {

    CGSize labelSize = [self sizeForMessage:_message];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelSize.width, labelSize.height)];

    label.backgroundColor = [UIColor clearColor];
    label.text = _message;
    label.numberOfLines = 0;
    label.font = self.messageLabelFont;
    label.textColor = self.messageLabelTextColor;

    return label;
}

#pragma mark Animation

- (void)hide:(BOOL)animated {

    [UIView animateWithDuration:(animated) ? ALPHA_ANIMATION_DURATION : 0.f animations:^{

        self.alpha = 0.f;
    }                completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {

    self.alpha = 0.f;

    [view addSubview:self];

    [UIView animateWithDuration:(animated) ? ALPHA_ANIMATION_DURATION : 0.f animations:^{

        self.alpha = 1.f;
    }];
}

#pragma mark Gesture

- (void)tap:(UITapGestureRecognizer *)recogniser {

    if ([self.delegate respondsToSelector:@selector(ADPopupViewDidTap:)]) {

        [self.delegate ADPopupViewDidTap:self];
    }
}

#pragma mark Draw

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self.popupColor set];

    switch (self.type) {
        case ptDownLeft: {

            UIBezierPath *rect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - POPUP_ARROW_SIZE.height) cornerRadius:POPUP_CORNER_RADIUS];
            [rect fill];

            UIBezierPath *arrow = [[UIBezierPath alloc] init];
            [arrow moveToPoint:CGPointMake(POPUP_ARROW_EDGE_MARGIN, self.frame.size.height - POPUP_ARROW_SIZE.height)];
            [arrow addLineToPoint:CGPointMake(POPUP_ARROW_EDGE_MARGIN + POPUP_ARROW_SIZE.width / 2, self.frame.size.height)];
            [arrow addLineToPoint:CGPointMake(POPUP_ARROW_EDGE_MARGIN + POPUP_ARROW_SIZE.width, self.frame.size.height - POPUP_ARROW_SIZE.height)];
            [arrow closePath];
            [arrow fill];

            break;
        }
        case ptDownRight: {

            UIBezierPath *rect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - POPUP_ARROW_SIZE.height) cornerRadius:POPUP_CORNER_RADIUS];
            [rect fill];

            UIBezierPath *arrow = [[UIBezierPath alloc] init];
            [arrow moveToPoint:CGPointMake(self.frame.size.width - POPUP_CORNER_RADIUS - POPUP_ARROW_EDGE_MARGIN - POPUP_ARROW_SIZE.width, self.frame.size.height - POPUP_ARROW_SIZE.height)];
            [arrow addLineToPoint:CGPointMake(self.frame.size.width - POPUP_CORNER_RADIUS - POPUP_ARROW_EDGE_MARGIN - POPUP_ARROW_SIZE.width / 2, self.frame.size.height)];
            [arrow addLineToPoint:CGPointMake(self.frame.size.width - POPUP_CORNER_RADIUS - POPUP_ARROW_EDGE_MARGIN, self.frame.size.height - POPUP_ARROW_SIZE.height)];
            [arrow closePath];
            [arrow fill];

            break;
        }
        case ptUpLeft: {

            UIBezierPath *rect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, POPUP_ARROW_SIZE.height, self.frame.size.width, self.frame.size.height - POPUP_ARROW_SIZE.height) cornerRadius:POPUP_CORNER_RADIUS];
            [rect fill];

            UIBezierPath *arrow = [[UIBezierPath alloc] init];
            [arrow moveToPoint:CGPointMake(POPUP_ARROW_EDGE_MARGIN, POPUP_ARROW_SIZE.height)];
            [arrow addLineToPoint:CGPointMake(POPUP_ARROW_EDGE_MARGIN + POPUP_ARROW_SIZE.width / 2, 0)];
            [arrow addLineToPoint:CGPointMake(POPUP_ARROW_EDGE_MARGIN + POPUP_ARROW_SIZE.width, POPUP_ARROW_SIZE.height)];
            [arrow closePath];
            [arrow fill];

            break;
        }
        case ptUpRight: {

            UIBezierPath *rect = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, POPUP_ARROW_SIZE.height, self.frame.size.width, self.frame.size.height - POPUP_ARROW_SIZE.height) cornerRadius:POPUP_CORNER_RADIUS];
            [rect fill];

            UIBezierPath *arrow = [[UIBezierPath alloc] init];
            [arrow moveToPoint:CGPointMake(self.frame.size.width - POPUP_CORNER_RADIUS - POPUP_ARROW_EDGE_MARGIN - POPUP_ARROW_SIZE.width, POPUP_ARROW_SIZE.height)];
            [arrow addLineToPoint:CGPointMake(self.frame.size.width - POPUP_CORNER_RADIUS - POPUP_ARROW_EDGE_MARGIN - POPUP_ARROW_SIZE.width / 2, 0)];
            [arrow addLineToPoint:CGPointMake(self.frame.size.width - POPUP_CORNER_RADIUS - POPUP_ARROW_EDGE_MARGIN, POPUP_ARROW_SIZE.height)];
            [arrow closePath];
            [arrow fill];

            break;
        }
        default:
            break;
    }
}


@end
