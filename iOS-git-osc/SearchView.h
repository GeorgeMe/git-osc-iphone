//
//  SearchView.h
//  iOS-git-osc
//
//  Created by chenhaoxiang on 14-8-21.
//  Copyright (c) 2014年 chenhaoxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectsTableController;

@interface SearchView : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *projects;

@property UISearchBar *searchBar;
@property UITableView *resultsTable;

@property BOOL isLoading;
@property BOOL isLoadOver;

@end
