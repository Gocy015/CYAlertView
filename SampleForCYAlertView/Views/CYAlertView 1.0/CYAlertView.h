//
//  CYAlertView.h
//  UsingUIDynamic
//
//  Created by  Gocy on 15/9/4.
//  Copyright © 2015年 Gocy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYAlertAction;

@interface CYAlertView : UIView

-(nonnull instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)msg withActions:(nullable NSArray<__kindof CYAlertAction *>*)actions tapToClose:(BOOL)close;

-(void)show;



//properties
@property (assign,nonatomic) BOOL draggable;
@property (assign,nonatomic) BOOL throwable;
 
@end


@interface UIButton (custom_pressed)

-(void)setHighlighted:(BOOL)highlighted;

@end