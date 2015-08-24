//
//  BNTableView.h
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNTableView;
@class BNTableCellController;
@class BNTableViewCell;

@protocol BNTableViewProtocol <NSObject>

@optional
- (void)tableView:(BNTableView *)tableView didSelectController:(BNTableCellController *)controller;
- (void)tableView:(BNTableView *)tableView willDisplayCellController:(BNTableCellController *)controller;
- (void)tableViewWillDisplayLastController:(BNTableView *)tableView;

@end

@interface BNTableCellController : NSObject

@property (nonatomic, assign) BNTableView * table;

@property (nonatomic, assign, readonly) CGFloat expectedCellWidth;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

/* Builder methods */
- (instancetype)withCustomWidth:(CGFloat)width;
- (instancetype)withTarget:(id)target action:(SEL)action;

- (NSString *)cellIdentifier;
- (NSString *)cellNibName;
- (CGFloat)cellHeight;

- (BOOL)canEdit;
- (void)deleteAction;

- (BOOL)canSelect;
- (void)selectAction;
- (UITableViewCellSelectionStyle)selectionStyle;

- (BOOL)canBeReloaded;

- (void)tableView:(BNTableView *)tableView cell:(BNTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;

- (BOOL)hasAction;
- (void)defaultAction;

- (void)didEndDisplayingCell:(BNTableViewCell *)cell;
- (void)willBeRemoved;

@end

@interface BNTableViewCell : UITableViewCell

@property (nonatomic, assign) BNTableCellController * controller;

@end

@interface BNTableView : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) IBOutlet id<BNTableViewProtocol> specialDelegate;

- (void)setCells:(NSArray *)cells;
- (void)setCells:(NSArray *)cells animated:(BOOL)animated;

- (void)appendCellController:(BNTableCellController *)controller;
- (void)appendCellController:(BNTableCellController *)controller withAnimation:(UITableViewRowAnimation)animation;

- (void)appendCellControllers:(NSArray *)controllers;
- (void)appendCellControllers:(NSArray *)controllers withAnimation:(UITableViewRowAnimation)animation;

- (void)removeCellForController:(BNTableCellController *)controller;
- (void)removeCellForController:(BNTableCellController *)controller withAnimation:(UITableViewRowAnimation)animation;

- (void)reloadCellForController:(BNTableCellController *)controller;
- (void)reloadCellForController:(BNTableCellController *)controller withAnimation:(UITableViewRowAnimation)animation;

- (void)scrollToCellForController:(BNTableCellController *)controller atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)setContentOffsetToCellForController:(BNTableCellController *)controller animated:(BOOL)animated;
- (void)setContentOffsetToCellForController:(BNTableCellController *)controller animated:(BOOL)animated delta:(CGFloat)delta;
- (void)resetContentOffsetAnimated:(BOOL)animated;

@end