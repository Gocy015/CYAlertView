# CYAlertView

An alert view that you can play with !

Inspired By [TeehanLax's TLAlertView](https://github.com/TeehanLax/TLAlertView),CYAlertView is an alert view with basic **UIKit Dynamic** animations,and has similar usage as the UIAlertView in UIKit. 

![cyalertview_preview](https://cloud.githubusercontent.com/assets/14084540/9724893/a857cdc6-5610-11e5-8a59-9b9bb195b258.gif)


###How To Use ?
To use CYAlertView,simply drag the "CYAlertView" folder into your project,import "CYAlertView.h",and you are ready to go ! 

**Creating instance**

<objective-c> CYAlertView *alert = [[CYAlertView alloc]initWithTitle:@"Title" message:@"Message" withActions:@[] tapToClose:NO];</objective-c> 


if you pass nil or an empty array to the initilizer,the alert view will generate a default OK button,you can also add your custom callbacks using CYAlertAction,then add it into the array that you are passing to the initializer.


>CYAlertAction *cancelAction = [[CYAlertAction alloc]initWithTitle:@"Cancel" withActionType:ActionTypeDestructive handler:^(CYAlertAction *action){
        NSLog(@"Cancel");
}];

> CYAlertView *alert = [[CYAlertView alloc]initWithTitle:@"Title" message:@"Message" withActions:@[cancelAction] tapToClose:NO];

For more details,please download the sample project.
