//
//  BNGPXCell.m
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNGPXCell.h"
#import "GPXViewController.h"

@interface BNGPXCellView ()
@property (retain, nonatomic) IBOutlet UILabel * fileLabel;
@end

@interface BNGPXCell ()
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * path;
@end

@implementation BNGPXCell

+ (instancetype)gpxCellWithFilename:(NSString *)filename path:(NSString *)path delegate:(id<BNGPXCellDelegate>)delegate {
    
    BNGPXCell * cell = [[self alloc] init];
    [cell setFileName:filename];
    [cell setPath:path];
    [cell setDelegate:delegate];
    return [cell autorelease];
}

- (void)tableView:(BNTableView *)tableView cell:(BNTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    BNGPXCellView * cellView = (BNGPXCellView *)cell;
    
    [cellView.fileLabel setText:_fileName];
}

- (CGFloat)cellHeight {
    
    return 48.f;
}

- (void)defaultAction {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(navigationControllerForGPXCell)]) {
        
        UINavigationController * nc = [self.delegate navigationControllerForGPXCell];
        [nc pushViewController:[GPXViewController gpxViewControllerWithPath:[_path stringByAppendingPathComponent:_fileName]] animated:YES];
    }
}

- (BOOL)canEdit {
    return YES;
}

- (void)deleteAction {
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(gpxCell:deleteFileAtPath:)]) {
        
        [self.delegate gpxCell:self deleteFileAtPath:[_path stringByAppendingPathComponent:_fileName]];
    }
}

- (void)dealloc {
    
    [_path release], _path = nil;
    [_fileName release], _fileName = nil;
    _delegate = nil;
    [super dealloc];
}

@end

@implementation BNGPXCellView

- (IBAction)clickAction:(id)sender {

    [self.controller defaultAction];
}

- (void)dealloc {
    
    [_fileLabel release], _fileLabel = nil;
    [super dealloc];
}

@end
