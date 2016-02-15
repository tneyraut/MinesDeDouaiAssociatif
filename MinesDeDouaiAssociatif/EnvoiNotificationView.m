//
//  EnvoiNotificationView.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 27/06/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "EnvoiNotificationView.h"

#import "SpecificTableViewCell.h"

#import <Parse/Parse.h>

@interface EnvoiNotificationView ()

@property(nonatomic, strong) NSArray *arrayChannels;

@property(nonatomic, strong) NSMutableArray *arrayButton;

@property(nonatomic, strong) UITextView *textView;

@property(nonatomic) UITapGestureRecognizer *singleFingerTap;

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation EnvoiNotificationView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationItem setTitle:@"Envoyer une notification"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    [self.navigationController.navigationBar.backItem.backBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Envoyer une notification" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) setCellImage:(UITableViewCell *)cell i:(int)indice
{
    NSString *imageName;
    if (indice == self.arrayChannels.count)
    {
        imageName = NSLocalizedString(@"ICON_NAME_TEXT", @"ICON_NAME_TEXT");
    }
    else
    {
        imageName = NSLocalizedString(@"ICON_NAME_PROMOTION", @"ICON_NAME_PROMOTION");
    }
    
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void) buttonActionListener:(UIButton *)button
{
    if ([button isEqual:[self.arrayButton objectAtIndex:0]])
    {
        for (int i=1;i<self.arrayButton.count;i++)
        {
            if ([[button titleForState:UIControlStateNormal] isEqualToString:@""])
            {
                [[self.arrayButton objectAtIndex:i] setTitle:@"X" forState:UIControlStateNormal];
            }
            else
            {
                [[self.arrayButton objectAtIndex:i] setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
    
    if ([[button titleForState:UIControlStateNormal] isEqualToString:@""])
    {
        [button setTitle:@"X" forState:UIControlStateNormal];
    }
    else
    {
        [[self.arrayButton objectAtIndex:0] setTitle:@"" forState:UIControlStateNormal];
        
        [button setTitle:@"" forState:UIControlStateNormal];
    }
}

- (void) buttonValiderActionListener
{
    [self.activityIndicatorView startAnimating];
    
    if ([self.textView.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Veuillez rentrer un message" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    PFPush *push = [[PFPush alloc] init];
    
    [push setMessage:self.textView.text];
    
    if ([[[[self arrayButton] objectAtIndex:0] titleForState:UIControlStateNormal] isEqualToString:@"X"])
    {
        [push setChannel:NSLocalizedString(@"CHANNEL_NAME_FI1A", @"CHANNEL_NAME_FI1A")];
        [push sendPushInBackground];
        
        [push setChannel:NSLocalizedString(@"CHANNEL_NAME_FI2A", @"CHANNEL_NAME_FI2A")];
        [push sendPushInBackground];
        
        [push setChannel:NSLocalizedString(@"CHANNEL_NAME_FI3A", @"CHANNEL_NAME_FI3A")];
        [push sendPushInBackground];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Votre notification a été prise en compte" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        [self.activityIndicatorView stopAnimating];
        
        [self.navigationController popToViewController:self.menuView animated:YES];
    }
    
    else
    {
        BOOL channelchoosen = NO;
        
        for (int i=1;i<self.arrayButton.count;i++)
        {
            if ([[[self.arrayButton objectAtIndex:i] titleForState:UIControlStateNormal] isEqualToString:@"X"])
            {
                channelchoosen = YES;
                
                [push setChannel:[self.arrayChannels objectAtIndex:i]];
                [push sendPushInBackground];
            }
        }
        
        if (channelchoosen)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Votre notification a été prise en compte" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
            [self.activityIndicatorView stopAnimating];
            
            [self.navigationController popToViewController:self.menuView animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Veuillez choisir au minimum une promotion" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self initialisationView];
    
    self.arrayChannels = [[NSArray alloc] initWithObjects:@"All promotions", @"FI1A", @"FI2A", @"FI3A", nil];
    
    self.arrayButton = [[NSMutableArray alloc] init];
    
    self.textView = [[UITextView alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [self.navigationController.toolbar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonValider = [[UIBarButtonItem alloc] initWithTitle:@"Valider" style:UIBarButtonItemStyleDone target:self action:@selector(buttonValiderActionListener)];
    
    [buttonValider setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    
    [self.navigationController.toolbar setItems:@[ flexibleSpace, buttonValider, flexibleSpace ]];
    
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arrayChannels.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrayChannels.count)
    {
        return 100.0f;
    }
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    [self setCellImage:cell i:(int)indexPath.row];
    
    if (indexPath.row == self.arrayChannels.count)
    {
        [self.textView setTextAlignment:NSTextAlignmentJustified];
        [self.textView setText:@"Text..."];
        [self.textView setFont:[UIFont systemFontOfSize:16]];
        [self.textView setFrame:CGRectMake(2 * cell.frame.size.width / 5, 10.0f, 3 * cell.frame.size.width / 5, cell.frame.size.height - 20.0f)];
        
        [cell addSubview:self.textView];
    }
    else
    {
        [cell.textLabel setText:[self.arrayChannels objectAtIndex:indexPath.row]];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake( 3 * cell.frame.size.width / 4, (cell.frame.size.height - 40.0f) / 2, 40.0f, 40.0f)];
        
        [button addTarget:self action:@selector(buttonActionListener:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitle:@"" forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont fontWithName:NSLocalizedString(@"CHECKBOX_FONT", @"CHECKBOX_FONT") size:35]];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:35]];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button setBackgroundImage:[UIImage imageNamed:NSLocalizedString(@"BACKGROUND_IMAGE_CHECKBOX", @"BACKGROUND_IMAGE_CHECKBOX")] forState:UIControlStateNormal];
        
        [self.arrayButton addObject:button];
        [cell addSubview:button];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.textView resignFirstResponder];
}

@end
