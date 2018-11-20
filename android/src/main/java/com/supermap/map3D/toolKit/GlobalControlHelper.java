package com.supermap.map3D.toolKit;

import com.supermap.realspace.Feature3D;


/**
 * 
 * @Titile:GlobalControlHelper.java
 * @Descript:ȫ�ֱ������ư�����
 * @Company: beijingchaotu
 * @Created on: 2017��3��13�� ����2:05:13
 * @Author: lzw
 * @version: V1.0
 */
public class GlobalControlHelper {
	


	// ���ڼ�¼��ǰ����ʱ��ǰ��Feature3D
	static Feature3D mCurrentFeature3D;

	
	public static Feature3D getCurrentFeature(){
		
		return  mCurrentFeature3D;
	}
	public static void setCurrentFeature(Feature3D feature3d){
		 mCurrentFeature3D=feature3d;
	}


}
