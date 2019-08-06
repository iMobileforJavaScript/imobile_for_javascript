package com.supermap.interfaces.ai;

import android.annotation.SuppressLint;
import android.content.Context;
import com.supermap.ar.Distance;
import com.supermap.ar.GeoObject;
import com.supermap.ar.World;

import java.text.DecimalFormat;
import java.util.ArrayList;

@SuppressLint("SdCardPath")
public class CustomWorldHelper {
	public static final int LIST_TYPE_EXAMPLE_1 = 1;

	public static World sharedWorld = null;

	public static int getWorldMode() {
		return mWorldMode;
	}

	public static void setWorldMode(int mWorldMode) {
		CustomWorldHelper.mWorldMode = mWorldMode;
	}

	public static int mWorldMode = -1;

	public static boolean isHDMapMode() {
		return isHDMapMode;
	}


	public static void setIsHDMapMode(boolean isHDMapMode) {
		CustomWorldHelper.isHDMapMode = isHDMapMode;
	}

	public static boolean isHDMapMode = false;

	public static World generateMyObjects(Context context)
	{
		if(sharedWorld != null)
		{
			return sharedWorld;
		}

		sharedWorld = new World(context);

		//you can use interest icon for more fun, whereas single button.
		//sharedWorld.setDefaultImage(R.drawable.ar_default_unknow_icon);



		//设置 初始化时AR场景中心位置                       /维度-经度
//		sharedWorld.setGeoPosition(39.984408,116.499238); //for supermap 7th.

		//[14:34:23] 第1点的坐标:经度:116.500305°,纬度:39.984106° 116.500316°,纬度:39.983976
		sharedWorld.setGeoPosition(39.983976,116.500316);


		//------------------------------以下是POI预加载------------------------------
		int size = 0;
		switch (mWorldMode)
		{
			case 0:
//				size = ((Flowing2Activity)context).arrName.size();
				break;
			case 1:
//				size = ((HDMapActivity)context).arrName.size();
				break;
			case 2:
//				size = ((ARMapGestureOperateActivity)context).arrName.size();
				break;
			case 3:
//				size = ((AllFeatureActivity)context).arrName.size();
			case 4:
//				size = ((ARProjectionActivity)context).arrName.size();
			default:
				break;
		}

		ArrayList<GeoObject> goArray = new ArrayList<GeoObject>();
		GeoObject original = new GeoObject();

//		original.setGeoPosition(39.9918067479341,116.512255196021); //fors supermap 7th.
		original.setGeoPosition(39.984282,116.499321);


		for(int i = 0;i<size;i++)
		{
			//创建POI
			GeoObject go1 = new GeoObject(i + 10);

			switch (mWorldMode)
			{
				case 0:
//					go1.setGeoPosition(((Flowing2Activity)context).arrY.get(i),
//							((Flowing2Activity)context).arrX.get(i));
//					go1.setName(((Flowing2Activity)context).arrName.get(i));

					break;
				case 1:
//					go1.setGeoPosition(((HDMapActivity)context).arrY.get(i),
//							((HDMapActivity)context).arrX.get(i));
//					go1.setName(((HDMapActivity)context).arrName.get(i));
					break;
				case 2:
//					go1.setGeoPosition(((ARRendererAllFeature)context).arrY.get(i),
//							((HDMapActivity)context).arrX.get(i));
//					go1.setName(((HDMapActivity)context).arrName.get(i));
					break;
                case 3:
//                    go1.setGeoPosition(((AllFeatureActivity)context).arrY.get(i),
//                            ((AllFeatureActivity)context).arrX.get(i));
//                    go1.setName(((AllFeatureActivity)context).arrName.get(i));
                    break;
				case 4:
//					go1.setGeoPosition(((ARProjectionActivity)context).arrY.get(i),
//							((ARProjectionActivity)context).arrX.get(i));
//					go1.setName(((ARProjectionActivity)context).arrName.get(i));
				default:
					break;
			}

			DecimalFormat df = new DecimalFormat("0.00");
			go1.setDistanceFromUser(Double.parseDouble(df.format(Distance.calculateDistanceMeters(original,go1))));//添加距离信息
			goArray.add(go1);
		}

		for(int i = 0; i<goArray.size();i++)
		{
			sharedWorld.addArObject(goArray.get(i));
		}

		//------------------------------以上是POI预加载------------------------------


		return sharedWorld;
	}



	//计算两个POI距离
	private static double calcDistance(GeoObject src1, GeoObject src2)
	{
		return Math.sqrt((src2.getLatitude()-src1.getLatitude())*(src2.getLatitude()-src1.getLatitude())
				+ (src2.getLongitude() - src1.getLongitude())*(src2.getLongitude() - src1.getLongitude()));
	}

	//计算经纬度距离
	public static double getDistance(double lat1, double lng1, double lat2,
									 double lng2) {
		double radLat1 = rad(lat1);
		double radLat2 = rad(lat2);
		double a = radLat1 - radLat2;
		double b = rad(lng1) - rad(lng2);
		double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2)
				+ Math.cos(radLat1) * Math.cos(radLat2)
				* Math.pow(Math.sin(b / 2), 2)));
		s = s * EARTH_RADIUS;
		s = Math.round(s * 10000d) / 10000d;
		s = s * 1000;
		return s;

	}

	private static double EARTH_RADIUS = 6378.137;

	private static double rad(double d) {
		return d * Math.PI / 180.0;
	}
}
