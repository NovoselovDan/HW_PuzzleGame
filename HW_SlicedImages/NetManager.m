//
//  NetManager.m
//  HW_SlicedImages
//
//  Created by Daniil Novoselov on 03.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "NetManager.h"

@implementation NetManager

+(instancetype)sharedInstance {
    static id _singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[self alloc] init];
    });
    return _singleton;
}
-(void)getImgList:(void(^)(NSArray *, NSError *))completion {
    NSURL *listURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/55523423/NetExample/ListImages.json"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:listURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSArray *objects = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(objects, nil);
                });
                return;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }];
    [task resume];
}

@end
