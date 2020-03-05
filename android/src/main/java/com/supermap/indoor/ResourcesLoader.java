package com.supermap.indoor;
/**
 * Android资源加载类
 */
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import android.app.Activity;
import android.content.Context;
import android.content.res.AssetManager;
import android.content.res.Resources;
import android.content.res.XmlResourceParser;
import android.os.Environment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

class ResourcesLoader {

	private static AssetManager mAssetManager = null;
	private static Resources mNewResources = null;
	private static Resources mOldResources = null;
	
	public static boolean mIsJar = false;
	
	private static String mfileName = "NaviLib.apk";	
	private static String sdcard = Environment.getExternalStorageDirectory() + "/";
	private static String mResPath = sdcard + mfileName;

	private static Resources.Theme mNewTheme = null;
	private static Resources.Theme mOldTheme = null;

	private static Field mFieldTheme = null;
	private static Field mFieldRes = null;
	
	public static void setResourcesPath(String path) {
		mResPath = path;
	}
	
	public static Resources getResources(Context paramContext) {

		if (!mIsJar) {
			Resources res = paramContext.getResources();
			return res;
		}
		
	    Resources superRes = paramContext.getResources();  
	    mNewResources = new Resources(mAssetManager, superRes.getDisplayMetrics(),  
	            superRes.getConfiguration());
	    
	    return mNewResources;
	}
	
	public static View findbyid(Context context, int paramInt, ViewGroup paramViewGroup) {
		View localView = null;
		
		if (!mIsJar) {
			localView = LayoutInflater.from(context).inflate(getResources(context).getXml(paramInt), paramViewGroup);
			return localView;
		}
		
		boolean bool = replaceRes((Activity) context);
		
		
		XmlResourceParser localXmlResourceParser = mNewResources.getXml(paramInt);
		localView = LayoutInflater.from(context).inflate(localXmlResourceParser, paramViewGroup);
		
		if (bool) {
			recoveryRes((Activity) context);
		}
	    
		localXmlResourceParser.close();
		
		return localView;
	}
	
	private static AssetManager newResources() {
		AssetManager assetManager = null;
	    try {  
	        assetManager = AssetManager.class.newInstance();  
	        Method addAssetPath = assetManager.getClass().getMethod("addAssetPath", String.class);  
	        addAssetPath.invoke(assetManager, mResPath);  
	        mAssetManager = assetManager;  
	    } catch (Exception e) {  
	        e.printStackTrace();  
	    } 
	    
	    return mAssetManager;
	}
	
	private static Resources getNewResources(Context paramContext, AssetManager paramAssetManager) {

	    Resources superRes = paramContext.getResources();  
	    mNewResources = new Resources(mAssetManager, superRes.getDisplayMetrics(),  
	            superRes.getConfiguration());
	    
	    return mNewResources;
	}
		 
	private static boolean replaceRes(Activity paramActivity)
	{
	    try
	    {
	    	if (mFieldTheme == null) {
	    		mFieldTheme = getFieldTheme();
		    }
		    if (mFieldRes == null) {
		    	mFieldRes = getFieldRes();
		    }
		    if (mNewTheme == null) {
		    	mNewTheme = getTheme(paramActivity);
		    }
		    Context localContext = paramActivity.getBaseContext();
		    mOldResources = (Resources)mFieldRes.get(localContext);
		    mOldTheme = (Resources.Theme)mFieldTheme.get(paramActivity);

		    mFieldRes.set(localContext, mNewResources);
		    mFieldTheme.set(paramActivity, mNewTheme);
	    } catch (Throwable localThrowable) {
	    	localThrowable.printStackTrace();
	    	return false;
	    }

	    return true;
	}
	
	private static Resources.Theme getTheme(Activity paramActivity)
	{
		if (mNewTheme == null) {
			if (mAssetManager == null) {
				mAssetManager = newResources();
			}

			if (mNewResources == null) {
				mNewResources = getNewResources(paramActivity, mAssetManager);
			}
			
			mNewTheme = mNewResources.newTheme();
			int resid = getResID("com.android.internal.R.style.Theme");
			mNewTheme.applyStyle(resid, true);
		}
	    return mNewTheme;
	}
	
	private static Field getFieldTheme() {
		try {
			Class localClass = Class.forName("android.view.ContextThemeWrapper");
			mFieldTheme = localClass.getDeclaredField("mTheme");
			mFieldTheme.setAccessible(true);
	    } catch (Throwable localThrowable) {
	    }
	    return mFieldTheme;
	}

	private static Field getFieldRes() {
		try {
			Class localClass = Class.forName("android.app.ContextImpl");
			mFieldRes = localClass.getDeclaredField("mResources");
			mFieldRes.setAccessible(true);
	    }
	    catch (Throwable localThrowable) {
	    }
	    return mFieldRes;
	}
	  
//	private static AssetManager b(String paramString) {
//		AssetManager localAssetManager = null;
//	    try {
//	    	Class localClass = Class.forName("android.content.res.AssetManager");
//	    	Constructor localConstructor = localClass.getConstructor((Class[])null);
//	    	localAssetManager = (AssetManager)localConstructor.newInstance((Object[])null);
//
//	    	Method localMethod = localClass.getDeclaredMethod("addAssetPath", new Class[] { String.class });
//
//	    	localMethod.invoke(localAssetManager, new Object[] { paramString });
//	    }
//	    catch (Throwable localThrowable) {
//	    }
//	    return localAssetManager;
//	}
	  
	public static int getResID(String paramString)
	{
	    int id = -1;
	    try {
	    	int i2 = paramString.indexOf(".R.");
	    	String str1 = paramString.substring(0, i2 + 2);
	    	int i3 = paramString.lastIndexOf(".");
	    	String str2 = paramString.substring(i3 + 1, paramString.length());
	    	paramString = paramString.substring(0, i3);
	    	String str3 = paramString.substring(paramString.lastIndexOf(".") + 1, paramString.length());
	    	String str4 = str1 + "$" + str3;

	    	Class localClass = Class.forName(str4);
	    	id = localClass.getDeclaredField(str2).getInt(null);
	    }
	    catch (Throwable localThrowable) {
	    }
	    return id;
	}
	 
	
	private static void recoveryRes(Activity paramActivity) {
	    if (mOldResources == null)
	      return;
	    try
	    {
	    	mFieldRes.set(paramActivity.getBaseContext(), mOldResources);
	    	mFieldTheme.set(paramActivity, mOldTheme);
	    } catch (Throwable localThrowable) {
	    	localThrowable.printStackTrace();
	    } finally {
	    	mOldResources = null;
	    }
	}
}
