//
//  XTTableDataDelegate.h
//  TableDatasourceSeparation
//
//  Created by TuTu on 15/12/5.
//  Copyright © 2015年 teason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class XTRootCustomCell ;

typedef void    (^TableViewCellConfigureBlock)(NSIndexPath *indexPath, id item, XTRootCustomCell *cell) ;
typedef CGFloat (^CellHeightBlock)(NSIndexPath *indexPath, id item) ;
typedef void    (^DidSelectCellBlock)(NSIndexPath *indexPath, id item) ;
typedef BOOL    (^CanEditRowBlock)(NSIndexPath *indexPath);
typedef void    (^CommitEditBlock)(UITableViewCellEditingStyle editingStyle,NSIndexPath *indexPath);

typedef void    (^ScrollViewDidScrollBlock)();
typedef void    (^scrollViewDidEndDraggingWillDecelerateBlock)();


@interface XTTableDataDelegate : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) ScrollViewDidScrollBlock    scrollViewDidScrollBlock;
@property (nonatomic, copy) scrollViewDidEndDraggingWillDecelerateBlock    scrollViewDidEndDraggingWillDecelerateBlock;


- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
    cellHeightBlock:(CellHeightBlock)aHeightBlock
     didSelectBlock:(DidSelectCellBlock)didselectBlock
    canEditRowBlock:(CanEditRowBlock)canEditRowBlock
    commitEditBlock:(CommitEditBlock)commitEditBlock;

- (void)handleTableViewDatasourceAndDelegate:(UITableView *)table ;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath ;

@end
