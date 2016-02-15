//
//  SpecificTableViewCellWithWebView.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 07/09/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "SpecificTableViewCellWithWebView.h"

@implementation SpecificTableViewCellWithWebView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float decalage = 10.0f;
    
    self.imageView.frame = CGRectMake(decalage, decalage, self.frame.size.height - 2 * decalage, self.frame.size.height - 2 * decalage);
    
    self.textLabel.frame = CGRectMake(self.imageView.frame.size.width + 2 * decalage, 0.0f, self.frame.size.width - self.imageView.frame.size.width - 3 * decalage, self.frame.size.height);
    
    [self.layer setBorderColor:[UIColor colorWithRed:213.0/255.0f green:210.0/255.0f blue:199.0/255.0f alpha:1.0f].CGColor];
    
    [self.layer setBorderWidth:2.5f];
    
    [self.layer setCornerRadius:7.5f];
    [self.layer setShadowOffset:CGSizeMake(0, 1)];
    
    [self.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.layer setShadowRadius:8.0];
    [self.layer setShadowOpacity:0.8];
    
    [self.layer setMasksToBounds:NO];
}

- (void) addWebViewAndImage:(NSString *)urlString
{
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    if (!self.webView)
    {
        float decalage = 10.0f;
        
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(decalage, decalage, self.frame.size.height - 2 * decalage, self.frame.size.height - 2 * decalage)];
    }
    
    [self.webView setScalesPageToFit:YES];
    
    self.webView.scrollView.scrollEnabled = NO;
    
    [self.webView setBackgroundColor:[UIColor clearColor]];
    
    [self.webView setOpaque:NO];
    
    float rw = 0.3375;
    
    self.webView.scrollView.minimumZoomScale = rw;
    
    self.webView.scrollView.maximumZoomScale = rw;
    
    self.webView.scrollView.zoomScale = rw;
    
    [self.webView loadRequest:request];
    
    [self addSubview:self.webView];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
