//
//  Camera.h
//  Realspace
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
///相机要素类。
struct Camera  {
    ///相机高度，单位：米。
	double altitude;
	///相机的纬度，单位为度。
    double latitude;    
	///相机的经度，单位为度。
    double longitude;  
	///相机的仰（俯）角（绕 X 轴的角度）。
    double tilt;    
    ///相机的方位角（上方向，即和北方的夹角），方位角的范围是0-360度。  
    double heading;     
};
typedef struct Camera Camera;
