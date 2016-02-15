//
//  TicketMenuView.m
//  MinesDeDouaiAssociatif
//
//  Created by Thomas Mac on 07/09/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import "TicketMenuView.h"
#import "FormulaireDemandeProblemeView.h"
#import "ListeTicketsView.h"

#import "SpecificTableViewCell.h"

@interface TicketMenuView ()

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSArray *elementArray;

@property(nonatomic, strong) NSArray *imageNameArray;

@end

@implementation TicketMenuView

// Setting certains éléments graphiques de la view
- (void) initialisationView
{
    [self.navigationItem setTitle:@"Demande informatique"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:NSLocalizedString(@"NAVIGATION_BAR_FONT", @"NAVIGATION_BAR_FONT") size:21.0], NSFontAttributeName, nil]];
    
    [self.navigationController.navigationBar.backItem.backBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Demande informatique" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:NSLocalizedString(@"BUTTON_FONT", @"BUTTON_FONT") size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
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
    
    if (self.user.airMember)
    {
        self.elementArray = [[NSArray alloc] initWithObjects:@"Faire une demande", @"Liste des demandes en cours de traitement", @"Liste des demandes traitées", nil];
    }
    else
    {
        self.elementArray = [[NSArray alloc] initWithObjects:@"Faire une demande", @"Liste de vos demandes en cours de traitement", @"Liste de vos demandes traitées", nil];
    }
    
    self.imageNameArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"ICON_NAME_ADD_TICKET", @"ICON_NAME_ADD_TICKET"), NSLocalizedString(@"ICON_NAME_TO_DO", @"ICON_NAME_TO_DO"), NSLocalizedString(@"ICON_NAME_DONE", @"ICON_NAME_DONE"), nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.elementArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    cell.textLabel.numberOfLines = 0;
    
    [cell.textLabel setText:self.elementArray[indexPath.row]];
    
    [cell.imageView setImage:[UIImage imageNamed:self.imageNameArray[indexPath.row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    [self.activityIndicatorView startAnimating];
    
    if (indexPath.row == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://air.minesdedouai.fr/#/creerTicket"]];
        
        // Ancienne version
        /*FormulaireDemandeProblemeView *formulaireDemandeProblemeView = [[FormulaireDemandeProblemeView alloc] initWithStyle:UITableViewStylePlain];
        
        formulaireDemandeProblemeView.afficherImage = self.afficherImage;
        
        formulaireDemandeProblemeView.ticketMenuView = self;
        
        formulaireDemandeProblemeView.API_url = self.API_url;
        
        [self.navigationController pushViewController:formulaireDemandeProblemeView animated:YES];*/
    }
    
    else if (indexPath.row == 1)
    {
        ListeTicketsView *listeTicketsView = [[ListeTicketsView alloc] initWithStyle:UITableViewStylePlain];
        
        listeTicketsView.titleView = @"Demandes en cours de traitement";
        
        listeTicketsView.afficherImage = self.afficherImage;
        
        listeTicketsView.user = self.user;
        
        listeTicketsView.ticketDone = NO;
        
        listeTicketsView.membreAir = self.user.airMember;
        
        listeTicketsView.API_url = self.API_url;
        
        [self.navigationController pushViewController:listeTicketsView animated:YES];
    }
    
    else if (indexPath.row == 2)
    {
        ListeTicketsView *listeTicketsView = [[ListeTicketsView alloc] initWithStyle:UITableViewStylePlain];
        
        listeTicketsView.titleView = @"Demandes traitées";
        
        listeTicketsView.afficherImage = self.afficherImage;
        
        listeTicketsView.user = self.user;
        
        listeTicketsView.ticketDone = YES;
        
        listeTicketsView.membreAir = self.user.airMember;
        
        listeTicketsView.API_url = self.API_url;
        
        [self.navigationController pushViewController:listeTicketsView animated:YES];
    }
    
    [self.activityIndicatorView stopAnimating];
}

@end
