//
//  ListeParticipantsView.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 17/08/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "ListeParticipantsView.h"

#import "SpecificTableViewCell.h"
#import "SpecificTableViewCellWithWebView.h"

#import "User.h"

@interface ListeParticipantsView ()

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSArray *participantsArray;

@property(nonatomic, strong) ParticipantModel *_participantModel;

@property(nonatomic, strong) NSMutableArray *imagesArray;

@end

@implementation ListeParticipantsView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationItem setTitle:@"Liste des participants"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    [self.navigationController.navigationBar.backItem.backBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Liste des participants" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) downloadParticipantsByEvenementID:(int)evenement_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._participantModel)
    {
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        self._participantModel = [[ParticipantModel alloc] init];
        
        self._participantModel.API_url = self.API_url;
        
        self._participantModel.delegate = self;
    }
    [self._participantModel getAllParticipantsByEvenementID:evenement_id];
}

- (void)participantsDownloaded:(NSArray *)items
{
    if (items.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[@"Aucun participant enregistré pour l'évènement : " stringByAppendingString:self.evenementSelected.title] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
    else
    {
        self.participantsArray = items;
        
        self.imagesArray = [[NSMutableArray alloc] init];
        
        for (int i=0;i<items.count;i++)
        {
            User *participant = items[i];
            
            if (self.afficherImage && ![participant.avatar isKindOfClass:[NSNull class]] && participant.avatar.length > 0 && [participant.avatar rangeOfString:@"svg"].location == NSNotFound && [participant.avatar rangeOfString:@"bmp"].location == NSNotFound && [participant.avatar rangeOfString:@"gif"].location == NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/user/" stringByAppendingString:[participant.avatar stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                NSURL *url = [[NSURL alloc] initWithString:urlString];
                
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
                
                [self.imagesArray addObject:[UIImage imageWithData:imageData]];
            }
            else if (self.afficherImage && ![participant.avatar isKindOfClass:[NSNull class]] && participant.avatar.length > 0 && [participant.avatar rangeOfString:@"svg"].location != NSNotFound)
            {
                NSString *urlString = [@"http://api.minesdedouai.fr/uploads/user/" stringByAppendingString:[participant.avatar stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                
                [self.imagesArray addObject:urlString];
            }
            else
            {
                [self.imagesArray addObject:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_USER", @"ICON_NAME_USER")]];
            }
        }
        
        [self.tableView reloadData];
    }
    
    [self.activityIndicatorView stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[SpecificTableViewCellWithWebView class] forCellReuseIdentifier:@"cellWebView"];
    
    [self initialisationView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self downloadParticipantsByEvenementID:self.evenementSelected.evenement_id];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.participantsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *participant = self.participantsArray[indexPath.row];
    
    if ([self.imagesArray[indexPath.row] isKindOfClass:[NSString class]])
    {
        SpecificTableViewCellWithWebView *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWebView" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        cell.textLabel.numberOfLines = 0;
        
        [cell addWebViewAndImage:self.imagesArray[indexPath.row]];
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", participant.prenom, participant.nom]];
        
        return cell;
    }
    
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.numberOfLines = 0;
    
    [cell.imageView setImage:self.imagesArray[indexPath.row]];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", participant.prenom, participant.nom]];
    
    return cell;
}

@end
