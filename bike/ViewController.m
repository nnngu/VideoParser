//
//  ViewController.m
//  bike
//
//  Created by 李嘉威 on 5/18/16.
//  Copyright © 2016 lijiawei. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface ViewController ()<MAMapViewDelegate, AMapSearchDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    UIButton *_currentLocationButton; /**< 回到当前位置按钮*/
    CGFloat screenW;
    CGFloat screenH;
}

@property (assign, nonatomic) CLLocationDegrees currentLatitude;
@property (assign, nonatomic) CLLocationDegrees currentLongitude;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    screenW = self.view.bounds.size.width;
    screenH = self.view.bounds.size.height;
    
    // 添加mapView
    [self addMapView];
    
    // 添加回到当前位置按钮
    [self addCurrentLocationButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _mapView.showsUserLocation = YES;
    
    [_mapView setZoomLevel:16.1 animated:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(searchInit) userInfo:nil repeats:NO];
}

#pragma mark - 添加mapView
/// 添加mapView
- (void) addMapView{
    //配置用户Key
    [MAMapServices sharedServices].apiKey = @"bb4468ef67ddc9927664ff8020b62f30";
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    //显示普通地图
    _mapView.mapType = MAMapTypeStandard;
    [self.view addSubview:_mapView];
    
    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    _mapView.showsCompass= NO; // 设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 22); //设置指南针位置
    _mapView.showsScale= NO;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 22);  //设置比例尺位置
}

#pragma mark - 添加回到当前位置按钮
// 添加回到当前位置按钮
- (void) addCurrentLocationButton{
    // _currentLocationButton
    _currentLocationButton = [[UIButton alloc] init];
    _currentLocationButton.frame = CGRectMake(10, screenH-60, 75, 30);
    [self.view addSubview:_currentLocationButton];
    [_currentLocationButton setTitle:@"你的位置" forState:UIControlStateNormal];
    [_currentLocationButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_currentLocationButton addTarget:self action:@selector(currentLocationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 搜索初始化
- (void)searchInit {
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = @"bb4468ef67ddc9927664ff8020b62f30";
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self.currentLatitude longitude:self.currentLongitude];
    request.keywords = @"公共自行车";
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.sortrule = 0;
    request.requireExtension = YES;
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
}

#pragma mark - 回到当前位置按钮被点击
/// 回到当前位置按钮被点击
- (void)currentLocationButtonClick:(id)sender {
    CLLocationCoordinate2D locationCoordinate2D;
    locationCoordinate2D.latitude = self.currentLatitude;
    locationCoordinate2D.longitude = self.currentLongitude;
    [_mapView setCenterCoordinate:locationCoordinate2D animated:YES];
}

#pragma mark - AMapSearchDelegate ，POI搜索对应的回调函数
/// 实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];

        // 添加大头针
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
        pointAnnotation.title = p.name;
        pointAnnotation.subtitle = p.address;
        [_mapView addAnnotation:pointAnnotation];
        
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place: %@", result);
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        annotationView.image = [UIImage imageNamed:@"fuyi.png"];
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0.1 green:0.2 blue:0.8 alpha:0.15];
        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:0];
        pre.image = [UIImage imageNamed:@"location.png"];
        pre.lineWidth = 3;
        pre.lineDashPattern = @[@6, @3];
        
        [_mapView updateUserLocationRepresentation:pre];
        
        view.calloutOffset = CGPointMake(0, 0);
    } 
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        self.currentLatitude = userLocation.coordinate.latitude;
        self.currentLongitude = userLocation.coordinate.longitude;
    }
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
