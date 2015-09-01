//
//  ViewController.m
//  Calculator-objc
//
//  Created by sbx_fc on 15/8/26.
//  Copyright (c) 2015年 SF. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *diaplay;
@property (nonatomic) BOOL userIsInTheMiddleOfTypingANumber;
@end

@implementation ViewController

- (IBAction)appendDigit:(UIButton *)sender {
    NSString* digit = [sender currentTitle];
    
   
    
    if(_userIsInTheMiddleOfTypingANumber){
        _diaplay.text = [NSString stringWithFormat:@"%@%@",_diaplay.text,digit];
    }
    else{
        _diaplay.text = digit;
        _userIsInTheMiddleOfTypingANumber = YES;
    }
}
@end
