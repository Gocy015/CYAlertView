//
//  CYAlertAction.h
//  UsingUIDynamic
//
//  Created by  Gocy on 15/9/4.
//  Copyright © 2015年 Gocy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ActionTypeDefault,
    ActionTypeDestructive,
}ActionType;

@interface CYAlertAction : NSObject

typedef void (^executionBlock)(CYAlertAction *);

@property(strong,nonatomic)NSString *title;
@property(strong,nonatomic)executionBlock block;
@property(assign)ActionType type;

+(instancetype)OKAction;

-(instancetype)initWithTitle:(NSString *)title withActionType:(ActionType)type handler:(executionBlock)block ;

-(void)runBlock;

@end
