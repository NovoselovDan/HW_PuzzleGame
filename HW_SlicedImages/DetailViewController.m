//
//  DetailViewController.m
//  HW_SlicedImages
//
//  Created by Daniil Novoselov on 12.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface DetailViewController() <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *imagesView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation DetailViewController
@synthesize scrollView;
-(void)viewDidLoad {
    [super viewDidLoad];
    [scrollView setContentSize:[self.infoObject getSize]];
    [self.view addSubview:scrollView];
    [self loadImages];
    
    self.scrollView.minimumZoomScale=MIN(0.99,([scrollView superview].frame.size.width / self.imagesView.frame.size.width));
    self.scrollView.maximumZoomScale=1.0;
    self.scrollView.delegate = self;
}
-(void)loadImages {
    self.imagesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self.infoObject getSize].width, [self.infoObject getSize].height)];
    [scrollView addSubview:self.imagesView];
    
    for (int j=0; j<self.infoObject.rowCount.intValue; j++) {
        for (int i=0; i < self.infoObject.columnCount.intValue; i++) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/55523423/NetExample/%@/%d_%d.png",self.infoObject.name,j,i]];
            CGRect frame = CGRectMake(self.infoObject.width.intValue * i, self.infoObject.height.intValue * j, self.infoObject.width.intValue, self.infoObject.height.intValue);
            UIImageView *imgView = [UIImageView new];
            [imgView sd_setImageWithURL:url];
            [imgView setFrame:frame];
            [self.imagesView addSubview:imgView];
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    for (UIImageView *imgView in self.imagesView.subviews) {
        [imgView sd_cancelCurrentImageLoad];
    }
}

#pragma mark - UIScrollViewDelegate protocol and some methods
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imagesView;
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.scrollView.minimumZoomScale=MIN(0.99,([scrollView superview].frame.size.width / self.imagesView.frame.size.width));
    [self centerScrollViewContents];
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollViewContents];
}
- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imagesView.frame;
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.imagesView setFrame:contentsFrame];
    }];
}
@end
