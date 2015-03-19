//
//  SlicedImageInfoObject.m
//  HW_SlicedImages
//
//  Created by Daniil Novoselov on 12.03.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "SlicedImageInfoObject.h"

@implementation SlicedImageInfoObject
+(instancetype)getSlicedImageInfoObjectWithDictionaty:(NSDictionary *)infoDict {
    SlicedImageInfoObject *obj = [SlicedImageInfoObject new];
    obj.name = infoDict[@"folder_name"];
    obj.width = infoDict[@"elem_width"];
    obj.height = infoDict[@"elem_height"];
    obj.rowCount = infoDict[@"rows_count"];
    obj.columnCount = infoDict[@"columns_count"];
    return obj;
}
-(CGSize)getSize {
    return CGSizeMake(self.width.floatValue * self.columnCount.floatValue,
                      self.height.floatValue * self.rowCount.floatValue);
}
@end
