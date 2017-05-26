//
//  TVHomeViewController.m
//  Cross-Platform-TODO-List
//
//  Created by Christina Lee on 5/9/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "TVHomeViewController.h"
#import "Todo.h"
#import "TVDetailViewController.h"
#import "FirebaseAPI.h"
#import "EmailViewController.h"

@interface TVHomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Todo *> *allTodos;
@property (strong, nonatomic) NSMutableArray<Todo *> *filteredTodos;


@end

@implementation TVHomeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self checkEmail];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    self.filteredTodos = [[NSMutableArray<Todo *> alloc]init];
//    [FirebaseAPI fetchAllTodos:^(NSArray<Todo *> *allTodos) {
//        NSLog(@"new todos: %@", allTodos);
//        NSLog(@"logged email: %@", self.email);
//        self.allTodos = allTodos;
//        for (Todo *todo in self.allTodos) {
//            if (todo.email == self.email) {
//                NSLog(@"todo email: %@", todo.email);
//                [self.filteredTodos addObject:todo];
//                [self.tableView reloadData];
//            }
//            
//        }
//    }];

}

-(void)checkEmail {
    if (!self.email) {
        EmailViewController *emailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailViewController"];
        [self presentViewController:emailVC animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.filteredTodos = [[NSMutableArray<Todo *> alloc]init];
    [FirebaseAPI fetchAllTodos:^(NSArray<Todo *> *allTodos) {
        NSLog(@"new todos: %@", allTodos);
        NSLog(@"logged email: %@", self.email);
        self.allTodos = allTodos;
        for (Todo *todo in self.allTodos) {
            if (todo.email == self.email) {
                NSLog(@"todo email: %@", todo.email);
                [self.filteredTodos addObject:todo];
                [self.tableView reloadData];
            }
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredTodos count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.filteredTodos[indexPath.row].title;
    cell.detailTextLabel.text = self.filteredTodos[indexPath.row].content;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Todo *currentTodo = [[Todo alloc]init];
    currentTodo.title = self.filteredTodos[indexPath.row].title;
    currentTodo.content = self.filteredTodos[indexPath.row].content;
    currentTodo.email = self.filteredTodos[indexPath.row].email;
    currentTodo.completed = self.filteredTodos[indexPath.row].completed;
    currentTodo.key = self.filteredTodos[indexPath.row].key;
    
    TVDetailViewController *newVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TVDetailViewController"];
    newVC.currentTodo = currentTodo;
    
    [self presentViewController:newVC animated:YES completion:nil];
}

@end

