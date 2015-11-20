//
//  CYAlertView.m
//  UsingUIDynamic
//
//  Created by  Gocy on 15/9/4.
//  Copyright © 2015年 Gocy. All rights reserved.
//

#import "CYAlertView.h"
#import "CYAlertAction.h"
#import "AlertActionButton.h"


 

static const CGFloat alertViewWidth = 275.0f;
static const CGFloat uiElementsPadding = 18.0f;
static const CGFloat animationDuration = 0.6f;
static const CGFloat throwVelocityBorder = 2000.0f;
static const CGFloat pushRatio = 35.0f;

@interface CYAlertView (){
    BOOL tapToClose;
    CGRect originalRect;
    CGPoint originalCenter;
}

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *message;
@property (strong,nonatomic) NSArray <CYAlertAction *>*actions;


//Views

@property (strong,nonatomic) UIView *bgView;
@property (strong,nonatomic) UIView *alertView;
@property (strong,nonatomic) UIView *overlayView;

//UIDynamic
@property (strong,nonatomic) UIDynamicAnimator *animator;
@property (strong,nonatomic) UIAttachmentBehavior *attachmentBehavior;


@end

@implementation CYAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)msg withActions:(nullable NSArray<__kindof CYAlertAction *> *)actions tapToClose:(BOOL)close{
    if (self = [super init]) {
        self.title = (title == nil)? @"" : title;
        self.message = (msg == nil)? @"" : msg;
        self.actions = (actions != nil && actions.count > 0)? actions : @[[CYAlertAction OKAction]];
        tapToClose = close;
        [self setup];
        self.draggable = NO;
        self.throwable = NO;
        
    }
    return self;
}

-(void)dealloc{
    self.actions = nil;
    self.alertView = nil;
    self.bgView = nil;
    self.title = nil;
    self.message = nil; 
  //  NSLog(@"dealloc");
    [self.animator removeAllBehaviors];
    self.animator = nil;
}

#pragma mark - Control Methods
-(void)show{
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    [keyWindow addSubview:self];
    
   // self.alpha = 0;
    
    [UIView animateWithDuration:animationDuration animations:^{
    
        self.bgView.alpha = 1;
    
    }];
    
    
    UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:self.alertView snapToPoint:self.center];
    snap.damping = 0.55;
    [self.animator addBehavior:snap];
}


-(void)dismiss{
    [self dismissWithAnimation:YES];
}


-(void)dismissWithAnimation:(BOOL)animate{
    
    [self.animator removeAllBehaviors];
    if (animate) {
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[self.alertView]];
        gravity.gravityDirection = CGVectorMake(0, 10);
        
        [self.animator addBehavior:gravity];
        
        UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.alertView]];
        itemBehavior.allowsRotation = YES;
        [itemBehavior addAngularVelocity:-2.2 forItem:self.alertView];
        
        [self.animator addBehavior:itemBehavior];
        
        
    }
    [UIView animateWithDuration:animationDuration animations:^{self.bgView.alpha = 0;} completion:^(BOOL finished){
        
        if (finished) {
            
            [self removeFromSuperview];
        }
        
    }];

    
}


-(void)setup{
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    
    
    //background
    self.frame = keyWindow.bounds;
    self.bgView = [[UIView alloc]initWithFrame:keyWindow.bounds];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.bgView.alpha = 0;
    
    
    if (tapToClose) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self.bgView addGestureRecognizer:tap];
    }
    
    [self addSubview:self.bgView];
    
    
    //alert
    self.alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, alertViewWidth, (CGFloat)MAXFLOAT)];
    
        //title Label
    UILabel *titleLabel = [self createTitleLabel];
    titleLabel.center = CGPointMake(self.alertView.center.x, uiElementsPadding + titleLabel.frame.size.height / 2);
    
    [self.alertView addSubview:titleLabel];
        //msg Label
    UILabel *msgLabel = [self createMessagelabel];
    msgLabel.center = CGPointMake(self.alertView.center.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + uiElementsPadding + msgLabel.frame.size.height / 2);
    [self.alertView addSubview:msgLabel];
    
        //actions
    [self addActionButtons];
    
    
    [self configAlertViewApperence];
    [self addSubview:self.alertView];
    
    
    
    //animator
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
}


-(void)setDraggable:(BOOL)draggable{
    if (_draggable != draggable) {
        _draggable = draggable;
        [self changeDragBehaviorForAlertView];
    }
}

#pragma mark - Help Funcs

-(UILabel *)createTitleLabel{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, alertViewWidth - 2*uiElementsPadding, 0)];
    
    titleLabel.text = self.title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    
    titleLabel.frame = [self adjustFrameAccordingToText:titleLabel];
    
    
    return titleLabel;
}

-(UILabel *)createMessagelabel{
    UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, alertViewWidth - 2*uiElementsPadding, 0)];
    
    msgLabel.text = self.message;
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.font = [UIFont systemFontOfSize:15.0f];
    msgLabel.lineBreakMode = NSLineBreakByWordWrapping;
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.numberOfLines = 0;
    
    msgLabel.frame = [self adjustFrameAccordingToText:msgLabel];
    
    return msgLabel;
}


-(CGRect)adjustFrameAccordingToText:(UILabel *)label{
    NSDictionary *attrDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             label.font,NSFontAttributeName,
                             label.textColor,NSForegroundColorAttributeName,
                             nil];
    
    CGRect expectedSize = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:attrDic
                                                   context:nil];
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, expectedSize.size.height);
}

-(void)configAlertViewApperence{
    [self adjustAlertViewHeight];
    CGRect frame = self.alertView.frame;
    frame.origin.y = -CGRectGetMaxY(self.alertView.frame);
    self.alertView.center = CGPointMake(self.center.x, self.alertView.center.y);
    self.alertView.layer.cornerRadius = 12;
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.masksToBounds = YES;
    originalRect = self.alertView.bounds;
    
    originalCenter = self.center;
  //  self.alertView.layer.borderWidth = 2;
}

-(void)adjustAlertViewHeight{
    
    if (self.alertView.subviews.count) {
        UIView *lastSubview = self.alertView.subviews[self.alertView.subviews.count - 1];
        CGFloat lastY = CGRectGetMaxY(lastSubview.frame);
        CGRect frame = self.alertView.frame;
        frame.size.height = lastY;
        self.alertView.frame = frame;
    }
    
}

-(void)addActionButtons{
    if (self.alertView.subviews.count) {
        UIView *lastSubview = self.alertView.subviews[self.alertView.subviews.count - 1];
        CGFloat lastY = CGRectGetMaxY(lastSubview.frame);
        lastY += uiElementsPadding;
        for (CYAlertAction *action in self.actions) {
           // UIButton *actionButton = [[UIButton alloc]initWithFrame:CGRectMake(0, lastY + uiElementsPadding, alertViewWidth, 50)];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, lastY, alertViewWidth , 1.0)];
            lineView.layer.borderColor = [UIColor grayColor].CGColor;
            lineView.alpha = 0.35;
            lineView.layer.borderWidth = 0.5;
            [self.alertView addSubview:lineView];
            lastY += 1;
            
            AlertActionButton *actionButton = [AlertActionButton buttonWithType:UIButtonTypeSystem];
            actionButton.tag = 99;
            actionButton.frame = CGRectMake(0, lastY, alertViewWidth, 48);
            [actionButton setTitle:action.title forState:UIControlStateNormal];
            [actionButton addTarget:action action:@selector(runBlock) forControlEvents:UIControlEventTouchUpInside];
            [actionButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
            actionButton.backgroundColor = [UIColor whiteColor];
            
            if (action.type == ActionTypeDestructive){
                [actionButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            actionButton.titleLabel.font = [UIFont systemFontOfSize:15];
            
            [self.alertView addSubview:actionButton];
            lastY = CGRectGetMaxY(actionButton.frame);
        }
    }

}

-(void)changeDragBehaviorForAlertView{
    if (self.draggable && self.overlayView == nil) {
        UIGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragDetected:)];
        CGFloat bottomY = 0;
        for (UIView *subview in self.alertView.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                bottomY = CGRectGetMinY(subview.frame);
                break;
            }
        }
        
        self.overlayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, alertViewWidth, bottomY)];
        [self.overlayView addGestureRecognizer:pan];
        [self.alertView addSubview:self.overlayView];
     //   [self.alertView addGestureRecognizer:self.pan];
    }
    else if (!self.draggable && self.overlayView !=nil){
        for (UIGestureRecognizer *ges in self.overlayView.gestureRecognizers) {
            [self.overlayView removeGestureRecognizer:ges];
        }
        [self.overlayView removeFromSuperview];
        self.overlayView = nil;
    }
    
}

-(void)resetAlertView{
 //   NSLog(@"Reset Alert,Rect:%@,center:%@",NSStringFromCGRect(originalRect),NSStringFromCGPoint(originalCenter));
    [self.animator removeAllBehaviors];
    [UIView animateWithDuration:0.5 animations:^{
        self.alertView.bounds = originalRect;
        self.alertView.center = originalCenter;
        self.alertView.transform = CGAffineTransformIdentity;
    }];
}

-(void)resetOrDismiss{
    if (CGRectIntersectsRect(self.bounds, self.alertView.frame)) {
   //     NSLog(@"Reset");
        [self resetAlertView];
    }
    else{
        [self dismissWithAnimation:NO];
    }
}

#pragma mark - Gesture Recognizer
-(void)dragDetected:(UIPanGestureRecognizer *)pan{
   // NSLog(@"Drag:%@",NSStringFromCGPoint([pan locationInView:self]));
    
    CGPoint loc = [pan locationInView:self];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            
            [self.animator removeAllBehaviors];
            CGPoint locInAlert = [pan locationInView:self.alertView];
            UIOffset offset = UIOffsetMake(locInAlert.x - CGRectGetMidX(self.alertView.bounds), locInAlert.y - CGRectGetMidY(self.alertView.bounds));
            
            self.attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.alertView offsetFromCenter:offset attachedToAnchor:loc];
            [self.animator addBehavior:self.attachmentBehavior];
            
            break;
 
            
            
        case UIGestureRecognizerStateEnded:
            
            [self.animator removeBehavior:self.attachmentBehavior];
            
            CGPoint velocity = [pan velocityInView:self];
            CGFloat magnitude = sqrt((velocity.x*velocity.x) + (velocity.y*velocity.y));
            if (magnitude > throwVelocityBorder) {
                
                UIPushBehavior *push = [[UIPushBehavior alloc]initWithItems:@[self.alertView] mode:UIPushBehaviorModeInstantaneous];
                push.pushDirection = CGVectorMake(velocity.x / 20, velocity.y / 20);
                push.magnitude = magnitude / pushRatio;
                __weak CYAlertView *wself = self;
                __weak UIPushBehavior *wpush = push;
                push.action = ^{
                    [wself.animator removeBehavior:wpush];
                };
                
                [self.animator addBehavior:push];
                
                UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.alertView]];
                itemBehavior.allowsRotation = YES;
                
                NSInteger angle = arc4random_uniform(20) - 10;
                itemBehavior.friction = 0.2;
                [itemBehavior addAngularVelocity:angle forItem:self.alertView];
                [self.animator addBehavior:itemBehavior];
                
                if (!self.throwable) {
                    [self performSelector:@selector(resetAlertView) withObject:nil afterDelay:0.3];
                }
                else{
                    [self performSelector:@selector(resetOrDismiss) withObject:nil afterDelay:0.3];
                }
            }
            else{
                [self resetAlertView];
            }
            
            
            
            
            
            break;
            
            
        default:
            self.attachmentBehavior.anchorPoint = loc;

            break;
    }
    
}


@end


