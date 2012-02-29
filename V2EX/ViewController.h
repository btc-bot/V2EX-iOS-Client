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
#import "EGORefreshTableHeaderView.h"


@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>

@property (strong, nonatomic) NSMutableArray *topics;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;

//  Reloading var should really be your tableviews datasource
//  Putting it here for demo purposes 
@property (assign, nonatomic)BOOL reloading;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (IBAction)reloadTableView:(id)sender;
- (void)avatarImgTapped:(id)sender;


@end
