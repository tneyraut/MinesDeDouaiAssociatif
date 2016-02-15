//
//  ListeTicketsView.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 07/09/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "ListeTicketsView.h"
#import "TicketDetailsView.h"

#import "SpecificTableViewCell.h"

#import "Ticket.h"

@interface ListeTicketsView ()

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) TicketModel *_ticketModel;

@property(nonatomic, strong) NSMutableArray *ticketArray;

@property(nonatomic, strong) NSMutableArray *sectionArray;

@end

@implementation ListeTicketsView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationItem setTitle:self.titleView];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    [self.navigationController.navigationBar.backItem.backBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:self.titleView style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) downloadTickets
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._ticketModel)
    {
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        self._ticketModel = [[TicketModel alloc] init];
        
        self._ticketModel.API_url = self.API_url;
        
        self._ticketModel.delegate = self;
        
        self.ticketArray = [[NSMutableArray alloc] init];
    }
    
    if (self.ticketDone)
    {
        if (self.membreAir)
        {
            [self._ticketModel getAllTicketsClosed];
        }
        else
        {
            [self._ticketModel getTicketsClosedByUserID:self.user.user_id];
        }
    }
    else
    {
        if (self.membreAir)
        {
            [self._ticketModel getAllTicketsOpened];
        }
        else
        {
            [self._ticketModel getTicketsOpenedByUserID:self.user.user_id];
        }
    }
    
}

- (void) ticketDone:(NSArray *)items
{
    if (items.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Aucune demande trouvée..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    
    self.ticketArray = [[NSMutableArray alloc] init];
    
    self.sectionArray = [[NSMutableArray alloc] init];
    
    NSArray *typeArray = [[NSArray alloc] initWithObjects:@"zimbra", @"hebergement", @"dépannage", @"autre", @"sans tag", nil];
    
    for (int i=0; i<typeArray.count; i++)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int j=0;j<items.count;j++)
        {
            Ticket *ticket = items[j];
            
            if ([ticket.labelType isEqualToString:typeArray[i]])
            {
                [array addObject:ticket];
                
                if (![self.sectionArray containsObject:typeArray[i]])
                {
                    [self.sectionArray addObject:typeArray[i]];
                }
            }
        }
        
        if (array.count > 0)
        {
            [self.ticketArray addObject:array];
        }
    }
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self initialisationView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self downloadTickets];
    
    [super viewDidAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSArray *array = self.ticketArray[section];
    
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.numberOfLines = 0;
    
    NSArray *array = self.ticketArray[indexPath.section];
    
    Ticket *ticket = array[indexPath.row];
    
    [cell.textLabel setText:ticket.title];
    
    [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"ICON_NAME_TICKET", @"ICON_NAME_TICKET")]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    NSArray *array = self.ticketArray[indexPath.section];
    
    Ticket *ticket = array[indexPath.row];
    
    TicketDetailsView *ticketDetailsView = [[TicketDetailsView alloc] initWithStyle:UITableViewStylePlain];
    
    ticketDetailsView.ticketSelected = ticket;
    
    ticketDetailsView.afficherImage = self.afficherImage;
    
    ticketDetailsView.user = self.user;
    
    ticketDetailsView.API_url = self.API_url;
    
    [self.navigationController pushViewController:ticketDetailsView animated:YES];
    
    [self.activityIndicatorView stopAnimating];
}

@end
