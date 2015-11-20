//
//  AlertActionButton.m
//  SampleForCYAlertView
//
//  Created by  Gocy on 15/9/8.
//  Copyright © 2015年 Gocy. All rights reserved.
//

#import "AlertActionButton.h"

@implementation AlertActionButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        UIColor *bg = [UIColor colorWithWhite:0.0 alpha:0.08];
        self.backgroundColor = bg;
    }
    else{
        self.backgroundColor  = [UIColor clearColor];
    }
    
}

@end
