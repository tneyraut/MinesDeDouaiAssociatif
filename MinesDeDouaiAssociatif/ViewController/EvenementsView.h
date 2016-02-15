//
//  EvenementsView.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 16/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvenementsView : UITableViewController

@property(nonatomic, strong) NSArray *evenementsArray;

@property(nonatomic, strong) NSMutableArray *imagesArray;

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) NSString *API_url;

@end
