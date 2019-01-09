package com.supermap.map3D.toolKit;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.res.Configuration;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build.VERSION;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Toast;

import com.supermap.data.CursorType;
import com.supermap.data.Environment;
import com.supermap.data.FieldInfos;
import com.supermap.data.ImageFormatType;
import com.supermap.data.LicenseStatus;
import com.supermap.data.QueryParameter;
import com.supermap.data.Workspace;
import com.supermap.imb.jsonlib.SiJsonArray;
import com.supermap.imb.jsonlib.SiJsonObject;
import com.supermap.realspace.Feature3D;
import com.supermap.realspace.Feature3DSearchOption;
import com.supermap.realspace.Feature3Ds;
import com.supermap.realspace.Layer3D;
import com.supermap.realspace.Layer3DOSGBFile;
import com.supermap.realspace.Layer3DType;
import com.supermap.realspace.Scene;
import com.supermap.realspace.SceneControl;
import com.supermap.realspace.Selection3D;
import com.supermap.realspace.TerrainLayer;
import com.supermap.realspace.TerrainLayers;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Map;

//import com.supermap.supermapiearth.view.QueryInfoBubblePopupWindow;


/**
 *
 * @Titile:Utils.java
 * @Descript:常用的通用类
 * @Company: beijingchaotu
 * @Created on: 2017年3月10日 下午8:38:29
 * @Author: lzw
 * @version: V1.0
 */
public class Utils {

	private static DisplayMetrics dp;
	// 定义一个记录当前设备系统版本常量
	final static int VERSION_SDK_LEVEL = 21;
	private static boolean isTable=false;
	/**
	 *
	 * @Descript:简单判断一下是否是平板还是手机
	 * @parameter:Activity context
	 * @return:boolean
	 * @throw
	 */
	public static boolean isTablet(Activity context) {
		return (context.getResources().getConfiguration().screenLayout
				& Configuration.SCREENLAYOUT_SIZE_MASK) >= Configuration.SCREENLAYOUT_SIZE_LARGE;
	}

	/**
	 *
	 * @Descript:获取屏幕的宽度
	 * @parameter:Activity context
	 * @return: int
	 * @throw
	 */
	public static int getscreenWidth(Activity context) {
		int screenWidth = 0;
		if (dp == null) {
			dp = new DisplayMetrics();
		}
		context.getWindowManager().getDefaultDisplay().getMetrics(dp);
		screenWidth = dp.widthPixels;
		return screenWidth;
	}

	/**
	 *
	 * @Descript:获取屏幕的高度
	 * @parameter:Activity context
	 * @return:int
	 * @throw
	 */
	public static int getscreenHeigth(Activity context) {
		int screenHeigth = 0;
		if (dp == null) {
			dp = new DisplayMetrics();
		}
		context.getWindowManager().getDefaultDisplay().getMetrics(dp);
		screenHeigth = dp.heightPixels;
		return screenHeigth;
	}

	/**
	 *
	 * @Descript:计算相应dp对应的px
	 * @parameter:Activity context,int dp
	 * @return:int
	 * @throw
	 */
	public static int dp2px(Context context, int dp) {
		return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dp,
				context.getResources().getDisplayMetrics());
	}

	/**
	 *
	 * @Descript:吐丝
	 * @parameter:Activity context,String info
	 * @return:
	 * @throw
	 */
	public static void showToastInfo(Activity context, String info) {
		Toast.makeText(context, info, Toast.LENGTH_SHORT).show();
	}

	// 判断是否有网络
	public static boolean isNetworkAvailable(Activity context) {
		ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		if (cm == null) {
		} else {
			NetworkInfo[] info = cm.getAllNetworkInfo();
			if (info != null) {
				for (int i = 0; i < info.length; i++) {
					if (info[i].getState() == NetworkInfo.State.CONNECTED) {
						return true;
					}
				}
			}
		}
		return false;
	}

	/**
	 * 根据当前设备的系统设置是否开启硬件加速。安卓4.0设备可能会导致UI刷新问题。
	 */
	public static void setHardwareAccelerated(Activity context) {

		if (VERSION.SDK_INT >= VERSION_SDK_LEVEL) {

			context.getWindow().setFlags(WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED,
					WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED);
		}
	}

	// 判断许可是否可用
	public static boolean isLicenseAvailable(Activity context) {

		LicenseStatus licenseStatus = Environment.getLicenseStatus();
		boolean a = licenseStatus.isLicenseValid();
		if (!licenseStatus.isLicenseExsit()) {
			Utils.showToastInfo(context, "许可不存在，场景打开失败，请加入许可");
			return false;
		} else if (!licenseStatus.isLicenseValid()) {
			Utils.showToastInfo(context, "许可过期，场景打开失败，请更换有效许可");

			return false;
		}
		return true;
	}


	public static void setFullScreen(Activity context) {
		context.requestWindowFeature(Window.FEATURE_NO_TITLE);
		context.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
	}

	// 检查是否第一次运行
	public static boolean isFirstRun(Activity context) {
		SharedPreferences sharedPreferences = context.getSharedPreferences("Myshare", context.MODE_PRIVATE);
		boolean isFirstRun = sharedPreferences.getBoolean("isFirstRun", true);
		Editor editor = sharedPreferences.edit();
		if (isFirstRun) {
			editor.putBoolean("isFirstRun", false);
			editor.commit();
			return true;
		} else {
			return false;
		}
	}


	// 关闭输入法
	public static void closeInputMethodManager(Activity context) {

		InputMethodManager inputMethodManager = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
		inputMethodManager.hideSoftInputFromWindow(context.getCurrentFocus().getWindowToken(),
				InputMethodManager.HIDE_NOT_ALWAYS);
	}

	// 打开输入法
	public static void openInputMethodManager(Activity context, View view) {
		InputMethodManager inputMethodManager = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
		inputMethodManager.showSoftInput(view, InputMethodManager.SHOW_FORCED);

	}
	// 判断是否有网络
	public static boolean isNetworkAvailable(Context context) {
		ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		if (cm == null) {
		} else {
			NetworkInfo[] info = cm.getAllNetworkInfo();
			if (info != null) {
				for (int i = 0; i < info.length; i++) {
					if (info[i].getState() == NetworkInfo.State.CONNECTED) {
						return true;
					}
				}
			}
		}
		return false;
	}

	// 属性查询是url 为空的情况
	public static void urlNUll(Scene tempScene, int _nID, Workspace mWorkspace, Map<String,String> attributeMap) {

		// 返回数据源集合对象个数
		int _nDSCount = mWorkspace.getDatasources().getCount();
		if (_nDSCount > 0) {
			String sceneName = tempScene.getName();
			com.supermap.data.Datasource datasetsource = mWorkspace.getDatasources().get(sceneName);
			if (datasetsource != null) {
				com.supermap.data.DatasetVector datasetVector = (com.supermap.data.DatasetVector) (datasetsource
						.getDatasets().get(sceneName));
				if (datasetVector != null) {
					String strFilter = "SmID = '" + _nID + "'";
					// QueryParameter
					QueryParameter parameter = new QueryParameter();
					parameter.setAttributeFilter(strFilter);
					// CursorType
					parameter.setCursorType(CursorType.STATIC);
					// recordset
					// 记录集可通过两种方式获得：在地图控件中选中若干个几何对象形成一个选择集，然后把选择集转换为记录集；或者从矢量数据集中获得一个记录集，
					// 有两种方法： 用户可以通过
					// DatasetVector.getRecordset()
					// 方法直接从矢量数据集中返回记录集，也可以通过查询语句返回记录集，所不同的是前者得到的记录集包含该类集合的全部空间几何信息和属性信息
					// ，
					// 而后者得到的是经过查询语句条件过滤的记录集。

					com.supermap.data.Recordset recordset = datasetVector.query(parameter);

					if (recordset.getRecordCount() >= 1) {
						// FieldInfos

						FieldInfos fieldInfos = datasetVector.getFieldInfos();

						recordset.moveFirst();

						ArrayList<String> nameList = new ArrayList<String>();

						for (int n = 0; n < fieldInfos.getCount(); n++) {
							String name = fieldInfos.get(n).getName();
							// 过滤sm的时候可以过滤
							if (name.toLowerCase().startsWith("sm")) {
								continue;
							}
							nameList.add(name);
							String strValue;
							Object value = recordset.getFieldValue(name);
							if (value == null) {
								strValue = "";
							} else {
								strValue = value.toString();

							}

							if (!nameList.contains(name)) {
								attributeMap.put(name , strValue);
							}

						}

						// fieldInfos.dispose();
						recordset.dispose();
						nameList.clear();
					}
				}
			}
		}

	}

	// 属性查询时的矢量数据
	public static void vect(Selection3D selection, Layer3D layer, FieldInfos fieldInfos, Map<String,String> attributeMap) {
		Feature3D feature = null;
		Layer3DOSGBFile layer3d=null;
		if (layer.getType() == Layer3DType.OSGBFILE) {

			layer3d = (Layer3DOSGBFile) layer;
			//Selection3D selection3d = layer3d.getSelection();
		} else if (layer.getType() == Layer3DType.VECTORFILE) {
			feature = selection.toFeature3D();
		}
		int count=0;
		Object[] str=null;
		if(feature==null){
			str=layer3d.getAllFieldValueOfLastSelectedObject();
			if(str!=null){
				count=str.length;
			}
		}else{
			count=fieldInfos.getCount();
		}

		for (int j = 0; j < count; j++) {
			String name = fieldInfos.get(j).getName();
//				if (name.toLowerCase().startsWith("sm")) {
//					continue;
//				}

			String strValue;
			Object value;
			if(feature==null){
				value=str[j];
			}else{
				value = feature.getFieldValue(name);
			}
			if (value==null||value.equals("NULL")) {
				strValue = "";
			} else {
				strValue = value.toString();
			}
			if(name!=null) {
				attributeMap.put(name, strValue);
			}
		}

	}


	// 属性查询时 查询KML的数据
	public static void KMLData(Layer3D layer, int id, Map<String,String> attributeMap) {

		Feature3Ds fer = layer.getFeatures();
		if (fer != null && fer.getCount() > 0) {
			Feature3D fer3d = fer.findFeature(id, Feature3DSearchOption.ALLFEATURES);
			if (fer3d != null) {
				String value = fer3d.getDescription();
				String value1 = fer3d.getName();
				attributeMap.put("name",value1);
				attributeMap.put("description",value);
			}

		}

	}

//	// 属性查询是url 不为空的情况 在线数据
	public static void urlNoNULL(SceneControl mSceneControl, String sceneUrl, int id, Map<String,String> attributeMap) {

		String Sceneurl = mSceneControl.getScene().getUrl();

		String sceneName = mSceneControl.getScene().getName();

		String jsonURL = "http://www.supermapol.com/realspace/services/data-" + sceneName + "/rest/data/datasources/"
				+ sceneName + "/datasets/" + sceneName + "/features/" + id + ".rjson";

		StringBuilder json = new StringBuilder();
		try {
			URL urlObject = new URL(jsonURL);
			URLConnection uc = urlObject.openConnection();
			uc.setConnectTimeout(3000);
			uc.setReadTimeout(3000);
			BufferedReader in = new BufferedReader(new InputStreamReader(uc.getInputStream()));
			String inputLine = null;
			while ((inputLine = in.readLine()) != null) {
				json.append(inputLine);
			}
			in.close();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		String jsonContent = json.toString();
		if (!(jsonContent == null || jsonContent.isEmpty() || jsonContent.equals(""))) {
			SiJsonObject jsonObject = new SiJsonObject(jsonContent);

			SiJsonArray fieldNames = jsonObject.getJsonArray("fieldNames");
			SiJsonArray fieldValues = jsonObject.getJsonArray("fieldValues");

			for (int m = 0; m < fieldNames.getArraySize(); m++) {
				String name = fieldNames.getString(m);
				String fieldValuesJson = fieldValues.getString(m);

				if (name.toLowerCase().startsWith("sm")) {
					continue;
				}
				attributeMap.put(name , fieldValuesJson);
			}

			fieldNames.dispose();
			fieldValues.dispose();

			jsonObject.dispose();
			jsonObject = null;
		}

	}

	public static void setTable(boolean value){
		isTable=value;
	}

	public static boolean getTable(){
		return isTable;
	}



}
