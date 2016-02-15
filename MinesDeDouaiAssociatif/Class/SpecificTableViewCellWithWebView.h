//
//  SpecificTableViewCellWithWebView.h
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 07/09/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecificTableViewCellWithWebView : UITableViewCell

@property(nonatomic, strong) UIWebView *webView;

- (void) addWebViewAndImage:(NSString *)urlString;

@end
