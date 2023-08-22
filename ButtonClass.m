#import "ButtonClass.h"
#import <objc/runtime.h>



@implementation ButtonClass
    -(UIButton*)createButton {
        UIButton *myButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 250, 50, 50)];
        myButton.backgroundColor = [UIColor greenColor];
        return myButton;
    }
/*
    - (void)buttonAction {
        NSLog(@"button pressed");
    }
*/
@end



 