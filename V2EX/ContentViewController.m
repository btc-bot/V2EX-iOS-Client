//
//  ContentViewController.m
//  V2ex
//
//  Created by 晓萌 王 on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContentViewController.h"

@implementation ContentViewController
@synthesize contentTextView;
@synthesize titleStr;
@synthesize contentStr;
@synthesize replies;

- (void)viewDidUnload {
    [self setContentTextView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.contentTextView.text = [NSString stringWithFormat:@"%@\n\n%@",titleStr,contentStr];
    NSString *replieMessage = [NSString stringWithFormat:@"回复(%d)",replies];
    UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc]initWithTitle:replieMessage style:UIBarButtonItemStyleBordered target:self action:@selector(repliesButtonPressed:)];
    self.navigationItem.rightBarButtonItem =rightbutton;
    
}

- (void)repliesButtonPressed:(id)sender{
    //目前V2EX的API还有Bug,不能获取replies,待修正后在继续开发
}
@end
