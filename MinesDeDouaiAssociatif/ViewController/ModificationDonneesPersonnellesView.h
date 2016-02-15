//
//  ModificationDonneesPersonnellesView.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 26/06/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuView.h"

#import "UserModel.h"
#import "User.h"

@interface ModificationDonneesPersonnellesView : UITableViewController <UITableViewDataSource, UITableViewDelegate, UserModelProtocol>

@property(nonatomic, weak) MenuView *menuView;

@property(nonatomic, strong) User *user;

@property(nonatomic, strong) UIImage *imageAvatar;

@property(nonatomic) NSString *imageAvatarSVG;

@property(nonatomic) BOOL afficherImage;

@property(nonatomic, weak) NSString *API_url;

@end
