//
//  ViewController.m
//  SampleForCYAlertView
//
//  Created by  Gocy on 15/9/7.
//  Copyright © 2015年 Gocy. All rights reserved.
//


#import "ViewController.h"
#import "CYAlertView.h"
#import "CYAlertAction.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *draggableSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *throwableSwitch;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - IBActions
- (IBAction)showSystemAlert:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title" message:@"Message" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)showCustomAlert:(id)sender {
    
    CYAlertAction *okAction = [CYAlertAction OKAction];
    CYAlertAction *cancelAction = [[CYAlertAction alloc]initWithTitle:@"Cancel" withActionType:ActionTypeDestructive handler:^(CYAlertAction *action){
        
        NSLog(@"Cancel");
        
    }];
    
    CYAlertView *alert = [[CYAlertView alloc]initWithTitle:@"Title" message:@"Message" withActions:@[okAction,cancelAction] tapToClose:NO];
    
    alert.draggable = self.draggableSwitch.on;
    alert.throwable = self.throwableSwitch.on;
    
    [alert show];
    
    
}


- (IBAction)draggableChanged:(UISwitch *)sender {
    if (!self.draggableSwitch.on) {
        [self.throwableSwitch setOn:NO animated:YES];
    }
}

- (IBAction)throwableChanged:(UISwitch *)sender {
    if (self.throwableSwitch.on) {
        [self.draggableSwitch setOn:YES animated:YES];
    }
}

@end
