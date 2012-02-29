//
//  ViewController.m
//  V2ex
//
//  Created by 晓萌 王 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "JSONKit.h"
#import "Topic.h"
#import "TitleViewCell.h"
#import "ContentViewController.h"
#import "UIImageView+WebCache.h"

@implementation ViewController

@synthesize topics = _topics;
@synthesize tableView = _tableView;
@synthesize HUD = _HUD;
@synthesize refreshHeaderView;
@synthesize reloading;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadTableView:nil];
    self.title = @"首页";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStyleBordered target:self action:@selector(reloadTableView:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    if (refreshHeaderView == nil) 
    {
        // 创建下拉视图
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		refreshHeaderView = view;
	}
	
	// 更新时间
	[refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    self.topics = nil;
    self.HUD = nil;
    self.refreshHeaderView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)reloadTableView:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.v2ex.com/api/topics/latest.json"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
    _HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.labelText = @"加载中...";
    [_HUD show:YES];    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //当以文本形式读取返回内容时用这个方法
    //对中文响应要 设置编码为UTF8
    request.ResponseEncoding = NSUTF8StringEncoding;
    NSString *responseString = [request responseString];
    id JSON = [responseString objectFromJSONString];
    id items = JSON;
    //数组初始化
    self.topics = [NSMutableArray arrayWithCapacity:20];
    for (id item in items) 
    {
        Topic *topic = [[Topic alloc]initWithDictionary:item];
        [self.topics addObject:topic];
    }
    //NSString *string = [JSON valueForKeyPath:@"content"];
    //NSLog(@"%@",self.topics);
    [self.tableView reloadData];
    [_HUD hide:YES afterDelay:0.1];
    // 当以二进制形式读取返回内容时用这个方法
    //NSData *responseData = [request responseData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //NSError *error = [request error];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //单元格设置
    NSString *cellIdentifier = @"cellIdentifier";
    TitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[TitleViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell = [[[NSBundle mainBundle]loadNibNamed:@"TitleViewCell" owner:self options:nil]lastObject];
    Topic *topic = [self.topics objectAtIndex:[indexPath row]];
    
    //加载用户avatar图片:因为v2ex早期用mobileMe做图片路径,现在换upyun了,所有很多用户头像还没转换
    //另一个解决方案采用memberId来查member中的avatar路径需要多次请求json
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://v2excdn.b0.upaiyun.com/avatars/normal/%@.png",topic.userNameId]];
    cell.avatarImgView.tag = [topic.userNameId intValue];
    /*
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:avatarURL]];
    if (imgData != NULL) {
        UIImage *image = [UIImage imageWithData:imgData];
        cell.avatarImgView.image = image;
    }
    else {
        cell.avatarImgView.image = [UIImage imageNamed:@"avatar_normal.png"];
    }*/
    
    //使用SDIMAGE异步加载图片,解决拉动UITableView卡的问题
    [cell.avatarImgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_normal.png"]];
    
    //给imgView添加Tap事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImgTapped:)];
    [cell.avatarImgView addGestureRecognizer:singleTap];
    //截取时间字符串
    cell.timeLabel.text = [topic.createdTime substringToIndex:19];
    //获取title字符串
    cell.titleLabel.text = topic.title;
    //获取回复按钮字符串
    cell.repliesLabel.text = [NSString stringWithFormat:@"回复: %d", topic.replies];
    return cell;
}

- (void)avatarImgTapped:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIImageView *imageViews = (UIImageView *)tap.view;
    NSLog(@"avatarImg Tapped %d",imageViews.tag);    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContentViewController *contentView = [[ContentViewController alloc]initWithNibName:@"ContentView" bundle:nil];
    Topic *topic = [self.topics objectAtIndex:[indexPath row]];
    contentView.titleStr = topic.title;
    contentView.contentStr = topic.content;
    contentView.replies = topic.replies;
    contentView.title = @"正文";
    [self.navigationController pushViewController:contentView animated:YES];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
// 刷新开始时调用
- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [self reloadTableView:nil];
	reloading = YES;
}
// 刷新结束时调用
- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

// 页面滚动时回调
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
    //NSLog(@"scrollViewDidScroll");
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
// 滚动结束时回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	
    //NSLog(@"scrollViewDidEndDragging");
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
// 开始刷新时回调
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{	
    NSLog(@"egoRefreshTableHeaderDidTriggerRefresh");
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
}
// 下拉时回调
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{	
    NSLog(@"egoRefreshTableHeaderDataSourceIsLoading");
	return reloading; // should return if data source model is reloading
}
// 请求上次更新时间时调用
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{	
    NSLog(@"egoRefreshTableHeaderDataSourceLastUpdated");
	return [NSDate date]; // should return date data source was last changed
}
@end
