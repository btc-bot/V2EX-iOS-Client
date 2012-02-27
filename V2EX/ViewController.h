//
//  ViewController.h
//  V2ex
//
//  Created by 晓萌 王 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "Topic.h"
#import "MBProgressHUD.h"


@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *topics;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)reloadTableView:(id)sender;
- (void)avatarImgTapped:(id)sender;


@end
