//
//  EnvoiNotificationView.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 27/06/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuView.h"

@interface EnvoiNotificationView : UITableViewController

@property(nonatomic, weak) MenuView *menuView;

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) NSString *API_url;

@end
