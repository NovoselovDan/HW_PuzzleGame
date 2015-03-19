//
//  ImageListViewController.m
//  HW_SlicedImages
//
//  Created by Daniil Novoselov on 12.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "ImageListViewController.h"
#import "DetailViewController.h"
#import "NetManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ImageListViewController() <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *imageArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refresh;
@end

@implementation ImageListViewController
-(void)viewDidLoad {
    [[SDImageCache sharedImageCache] clearDisk]; //очистка кэша
    [super viewDidLoad];
    
    self.refresh = [UIRefreshControl new];
    [self.tableView addSubview:self.refresh];
    [self.refresh addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self reloadData];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadIfNescessary];
}

-(void)reloadData {
    [[NetManager sharedInstance] getImgList:^(NSArray *arr, NSError *error) {
        if (!error) {
            imageArray = [NSMutableArray new];
            for (NSDictionary *dict in arr)
            {
                [imageArray addObject:[SlicedImageInfoObject getSlicedImageInfoObjectWithDictionaty:dict]];
            }
        } else {
            imageArray = nil;
            [[[UIAlertView alloc]initWithTitle:@"Downloading error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
        }
        [self.tableView reloadData];
        [self.refresh endRefreshing];
    }];
}
-(void)reloadIfNescessary {
    if (!imageArray) {
        [self.refresh beginRefreshing];
        [self reloadData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"DetailViewSegue"]) {
        DetailViewController *vc = [segue destinationViewController];
        vc.infoObject = imageArray[[self.tableView indexPathForSelectedRow].row];
    }
}


#pragma mark - Table View methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return imageArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [imageArray[indexPath.row] name];
    return cell;
}


@end
