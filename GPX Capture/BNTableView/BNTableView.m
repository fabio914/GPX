//
//  BNTableView.m
//  GPX Capture
//
//  Created by Fabio on 8/24/15.
//  Copyright (c) 2015 Bluenose. All rights reserved.
//

#import "BNTableView.h"
#import "NSArray+Safe.h"

@interface BNTableView ()

@property (nonatomic, retain) NSMutableArray * mcells; // of BNTableCellController

@end

@implementation BNTableView

- (id)init {
    
    if(self = [super init]) {
        
        [self configure];
    }
    
    return self;
}

- (void)configure {
    
    self.delegate = self;
    self.dataSource = self;
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setAllowsMultipleSelectionDuringEditing:NO];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self configure];
}

- (void)setCells:(NSArray *)cells {
    
    [self setCells:cells animated:NO];
}

- (void)setCells:(NSArray *)cells animated:(BOOL)animated {
    
    if(_mcells != cells) {
        
        for(BNTableCellController * controller in _mcells) {
            
            [controller setTable:nil];
        }
        
        [_mcells release];
        _mcells = [[NSMutableArray alloc] initWithArray:cells];
        
        for(BNTableCellController * controller in cells) {
            
            [controller setTable:self];
        }
        
        if(animated) {
            
            CATransition *transition = [CATransition animation];
            transition.type = kCATransitionPush;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.fillMode = kCAFillModeForwards;
            transition.duration = 0.4;
            transition.subtype = kCATransitionFromTop;
            
            [[self layer] addAnimation:transition forKey:@"UITableViewReloadDataAnimationKey"];
        }
        
        [self reloadData];
    }
}

- (void)appendCellController:(BNTableCellController *)controller {
    
    [self appendCellController:controller withAnimation:UITableViewRowAnimationNone];
}

- (void)appendCellController:(BNTableCellController *)controller withAnimation:(UITableViewRowAnimation)animation {
    
    if(controller == nil)
        return;
    
    [_mcells addObject:controller];
    [controller setTable:self];
    
    NSUInteger index = [_mcells indexOfObject:controller];
    [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:animation];
}

- (void)appendCellControllers:(NSArray *)controllers {
    
    [self appendCellControllers:controllers withAnimation:UITableViewRowAnimationNone];
}

- (void)appendCellControllers:(NSArray *)controllers withAnimation:(UITableViewRowAnimation)animation {
    
    NSMutableArray * indexPaths = [[NSMutableArray alloc] init];
    
    for(BNTableCellController * controller in controllers) {
        
        if(![controller isKindOfClass:[BNTableCellController class]]) {
            
            continue;
        }
        
        [controller setTable:self];
        
        [_mcells addObject:controller];
        NSUInteger index = [_mcells indexOfObject:controller];
        [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }
    
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    [indexPaths release], indexPaths = nil;
}

- (void)removeCellForController:(BNTableCellController *)controller {
    
    [self removeCellForController:controller withAnimation:UITableViewRowAnimationNone];
}

- (void)removeCellForController:(BNTableCellController *)controller withAnimation:(UITableViewRowAnimation)animation {
    
    if(controller == nil)
        return;
    
    NSUInteger index = [_mcells indexOfObject:controller];
    
    if(index < [_mcells count]) {
        
        [controller willBeRemoved];
        [_mcells removeObjectAtIndex:index];
        [self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:animation];
    }
}

- (void)reloadCellForController:(BNTableCellController *)controller {
    
    [self reloadCellForController:controller withAnimation:UITableViewRowAnimationNone];
}

- (void)reloadCellForController:(BNTableCellController *)controller withAnimation:(UITableViewRowAnimation)animation {
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[_mcells indexOfObject:controller] inSection:0];
    
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:animation];
}

- (void)scrollToCellForController:(BNTableCellController *)controller atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[_mcells indexOfObject:controller] inSection:0];
    
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void)setContentOffsetToCellForController:(BNTableCellController *)controller animated:(BOOL)animated {
    
    [self setContentOffsetToCellForController:controller animated:animated delta:0.f];
}

- (void)setContentOffsetToCellForController:(BNTableCellController *)controller animated:(BOOL)animated delta:(CGFloat)delta {
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[_mcells indexOfObject:controller] inSection:0];
    
    CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
    [self setContentOffset:CGPointMake(0, cellRect.origin.y + delta) animated:animated];
}

- (void)resetContentOffsetAnimated:(BOOL)animated {
    [self setContentOffset:CGPointMake(0, 0) animated:animated];
}

- (BNTableViewCell *)cellForController:(BNTableCellController *)controller {
    
    BNTableViewCell * cell = [self dequeueReusableCellWithIdentifier:[controller cellIdentifier]];
    
    if (cell == nil) {
        
        [self registerNib:[UINib nibWithNibName:[controller cellNibName] bundle:nil] forCellReuseIdentifier:[controller cellIdentifier]];
        cell = [self dequeueReusableCellWithIdentifier:[controller cellIdentifier]];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BNTableCellController * controller = [_mcells safeObjectAtIndex:indexPath.row];
    
    if(!controller)
        return nil;
    
    BNTableViewCell * cell = [self cellForController:controller];
    
    if(cell.controller != controller || [controller canBeReloaded]) {
        
        cell.controller = controller;
        
        if([controller canSelect]) {
            
            cell.selectionStyle = [controller selectionStyle];
        }
        
        [controller tableView:self cell:cell forIndexPath:indexPath];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_mcells count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [(BNTableCellController *)[_mcells safeObjectAtIndex:indexPath.row] cellHeight];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [(BNTableCellController *)[_mcells safeObjectAtIndex:indexPath.row] canSelect];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([(BNTableCellController *)[_mcells safeObjectAtIndex:indexPath.row] canSelect]) {
        
        return indexPath;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.specialDelegate && [self.specialDelegate respondsToSelector:@selector(tableView:didSelectController:)]) {
        
        [self.specialDelegate tableView:self didSelectController:[_mcells safeObjectAtIndex:indexPath.row]];
    }
    
    else {
        
        [[_mcells safeObjectAtIndex:indexPath.row] selectAction];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [(BNTableCellController *)[_mcells safeObjectAtIndex:indexPath.row] canEdit];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [(BNTableCellController *)[_mcells safeObjectAtIndex:indexPath.row] deleteAction];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if(self.specialDelegate && [self.specialDelegate respondsToSelector:@selector(tableView:willDisplayCellController:)]) {
        
        [self.specialDelegate tableView:self willDisplayCellController:(BNTableCellController *)[_mcells safeObjectAtIndex:indexPath.row]];
    }
    
    if(indexPath.row == [_mcells count] - 1) {
        
        if(self.specialDelegate && [self.specialDelegate respondsToSelector:@selector(tableViewWillDisplayLastController:)]) {
            
            [self.specialDelegate tableViewWillDisplayLastController:self];
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[BNTableViewCell class]]) {
        
        BNTableCellController * controller = [_mcells safeObjectAtIndex:[indexPath row]];
        [controller didEndDisplayingCell:(BNTableViewCell *)cell];
    }
}

- (void)dealloc {
    
    self.delegate = nil, self.dataSource = nil;
    [_mcells release], _mcells = nil;
    [super dealloc];
}

@end

@implementation BNTableCellController

- (instancetype)withCustomWidth:(CGFloat)width {
    if(width >= 0)
        _expectedCellWidth = width;
    
    return self;
}

- (instancetype)withTarget:(id)target action:(SEL)action {
    _target = target;
    _action = action;
    return self;
}

- (instancetype)init {
    
    if(self = [super init]) {
        
        _expectedCellWidth = 320.f;
    }
    
    return self;
}

- (NSString *)cellIdentifier {
    
    return [self cellNibName];
}

- (NSString *)cellNibName {
    
    return NSStringFromClass([self class]);
}

- (CGFloat)cellHeight {
    
    return 30.f;
}

- (BOOL)canEdit {
    return NO;
}

- (void)deleteAction {
    
}

- (BOOL)canSelect {
    return NO;
}

- (void)selectAction {
    
}

- (UITableViewCellSelectionStyle)selectionStyle {
    return UITableViewCellSelectionStyleNone;
}

- (BOOL)canBeReloaded {
    return NO;
}

- (void)tableView:(BNTableView *)tableView cell:(BNTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (BOOL)hasAction {
    return (_target != nil && [_target respondsToSelector:_action]);
}

- (void)defaultAction {
    
    if(self.hasAction) {
        [self.target performSelector:self.action withObject:nil];
    }
}

- (void)didEndDisplayingCell:(BNTableViewCell *)cell {
    
}

- (void)willBeRemoved {
    
}

- (void)dealloc {
    
    _table = nil;
    _target = nil;
    _action = nil;
    [super dealloc];
}

@end

@implementation BNTableViewCell
@end
