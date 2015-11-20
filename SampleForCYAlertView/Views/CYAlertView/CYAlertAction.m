//
//  CYAlertAction.m
//  UsingUIDynamic
//
//  Created by  Gocy on 15/9/4.
//  Copyright © 2015年 Gocy. All rights reserved.
//

#import "CYAlertAction.h"

@implementation CYAlertAction

+(instancetype)OKAction{
    CYAlertAction *ok = [[CYAlertAction alloc]initWithTitle:@"OK" withActionType:ActionTypeDefault handler:^(CYAlertAction *action) {
        NSLog(@"OK");
    }];
    
    return ok;
    
}

-(instancetype)initWithTitle:(NSString *)title withActionType:(ActionType)type handler:(executionBlock)block{
    if (self = [super init]){
        self.title = title;
        self.block = block;
        self.type = type;
    }
    return self;
}

-(void)runBlock{
    if (self.block != nil) {
        self.block(self);
    }
}

@end
