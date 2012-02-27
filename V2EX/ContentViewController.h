//
//  ContentViewController.h
//  V2ex
//
//  Created by 晓萌 王 on 12-2-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *contentStr;
@property (assign, nonatomic) NSInteger replies;

- (void)repliesButtonPressed:(id)sender;
@end
