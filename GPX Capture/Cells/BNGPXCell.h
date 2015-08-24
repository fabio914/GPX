//
//  BNGPXCell.h
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNTableView.h"

@class BNGPXCell;

@protocol BNGPXCellDelegate <NSObject>

@required
- (UINavigationController *)navigationControllerForGPXCell;
- (void)gpxCell:(BNGPXCell *)cell deleteFileAtPath:(NSString *)path;

@end

@interface BNGPXCell : BNTableCellController

@property (nonatomic, assign) id<BNGPXCellDelegate> delegate;

+ (instancetype)gpxCellWithFilename:(NSString *)filename path:(NSString *)path delegate:(id<BNGPXCellDelegate>)delegate;

@end

@interface BNGPXCellView : BNTableViewCell

@end
