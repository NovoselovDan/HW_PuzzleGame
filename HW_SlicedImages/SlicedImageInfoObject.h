//
//  SlicedImageInfoObject.h
//  HW_SlicedImages
//
//  Created by Daniil Novoselov on 12.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SlicedImageInfoObject : NSObject

@property NSString *name;
@property NSNumber *width;
@property NSNumber *height;
@property NSNumber *rowCount;
@property NSNumber *columnCount;

+(instancetype)getSlicedImageInfoObjectWithDictionaty:(NSDictionary *)infoDict;
-(CGSize)getSize;
@end
