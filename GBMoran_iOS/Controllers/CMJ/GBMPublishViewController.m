//
//  CMJPublishViewController.m
//  蓦然
//
//  Created by 陈铭嘉 on 15/9/21.
//  Copyright © 2015年 com.GeekBand. All rights reserved.
//

#import "GBMPublishViewController.h"
#import "GBMPublishCell.h"
#define selfWidth self.view.frame.size.width
#define selfHeight self.view.frame.size.height

@interface GBMPublishViewController ()
{
    BOOL openOrNot;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation GBMPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makePublishButton];

    
    self.navigationController.navigationBar.backgroundColor = [[UIColor alloc]initWithRed:230/255.0 green:106/255.0 blue:58/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [[UIColor alloc]initWithRed:230/255.0 green:106/255.0 blue:58/255.0 alpha:1];
    self.textView.delegate = self;
    [self.navigationController.navigationBar setAlpha:1.0];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-30, 10, 100, 30)];
    label.text =@"发布照片";
    label.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:label];
   
    
    // Do any additional setup after loading the view.
}

//制作tableview
-(void)makeTableView{
    if (!self.tableView) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, selfHeight, selfWidth, 230) style:UITableViewStylePlain];
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
        [self.tableView setBackgroundColor:[UIColor whiteColor]];
        [self.tableView setSeparatorColor:[UIColor blackColor]];
        [self.tableView setShowsHorizontalScrollIndicator:NO];
        [self.tableView setShowsVerticalScrollIndicator:YES];
        [self.tableView registerNib:[UINib nibWithNibName:@"GBMPublishCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"publishCell"];
        [self.view addSubview:self.tableView];
        openOrNot = NO;
    }
    
    if (openOrNot == NO) {
        [UIView animateWithDuration:1 animations:^{
            [self.tableView setFrame:CGRectMake(0, selfHeight-230, selfWidth, 230)];
        }];
        openOrNot = YES;
    }else{
        [UIView animateWithDuration:1 animations:^{
            [self.tableView setFrame:CGRectMake(0, selfHeight, selfWidth, 230)];
        }];
        openOrNot = NO;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{

    return 60;
}

//制作拍照按钮
-(void)makePublishButton{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-65, 0, 50, 40)];
    button.backgroundColor = [UIColor whiteColor];
    button.alpha = 0.8;
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3.0;
    button.clipsToBounds = YES;
    [self.navigationController.navigationBar addSubview:button];
    
   
}

-(void)publishButtonClicked:(id)sender{

}
- (IBAction)publishLocation:(id)sender {
    [self makeTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchDown:(id)sender {
    [self.textView resignFirstResponder];
}


#pragma mark ------tableView的delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GBMPublishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"publishCell" ];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    cell.nameLabel.text = @"上海";
    cell.placeLabel.text = @"上海浦东国际金融中心";
    return cell;

}



#pragma mark ------textView的delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSCharacterSet *doneButton = [NSCharacterSet newlineCharacterSet];
    NSRange replacement = [text rangeOfCharacterFromSet:doneButton ];
    NSUInteger location = replacement.location;
    if (textView.text.length + text.length > 25) {
        if (!location != NSNotFound) {
            [self.textView resignFirstResponder];
        }
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/25",textView.text.length+text.length];
    return YES;
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@"你想说的话"]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length < 1) {
        textView.text = @"你想说的话";
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
