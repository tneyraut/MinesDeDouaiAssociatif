//
//  ListeLinksView.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 18/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListeLinksView : UITableViewController

@property(nonatomic, weak) NSArray *linksArray;

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) NSString *API_url;

@end
