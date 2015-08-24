//
//  ListViewController.m
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "ListViewController.h"

#import "BNTableView.h"
#import "BNEmptySpaceCell.h"
#import "BNGPXCell.h"

#import "BNCapture.h"

@interface ListViewController () <BNGPXCellDelegate>
@property (retain, nonatomic) IBOutlet BNTableView * tableView;
@end

@implementation ListViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self reloadTable];
}

- (void)reloadTable {
    
    NSArray * gpxFiles = [BNCapture gpxFiles];
    NSString * path = [BNCapture documentsPath];
    NSMutableArray * cells = [NSMutableArray array];
    
    [cells addObject:[BNEmptySpaceCell emptySpaceCellWithHeight:2.f]];
    
    for(NSString * file in gpxFiles) {
        
        [cells addObject:[BNGPXCell gpxCellWithFilename:file path:path delegate:self]];
        [cells addObject:[BNEmptySpaceCell emptySpaceCellWithHeight:2.f]];
    }
    
    [self.tableView setCells:cells];
}

#pragma BNGPXCellDelegate

- (UINavigationController *)navigationControllerForGPXCell {
    return self.navigationController;
}

- (void)gpxCell:(BNGPXCell *)cell deleteFileAtPath:(NSString *)path {
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [self reloadTable];
}

- (void)dealloc {
    
    [_tableView release], _tableView = nil;
    [super dealloc];
}

@end
