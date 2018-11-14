package com.supermap.map3D.toolKit;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;


public class JsonPara {

	public static ArrayList<PoiGsonBean.PoiInfos> parsePOI(String strResult) {

		PoiGsonBean poiGsonBean = new PoiGsonBean();
		ArrayList<PoiGsonBean.PoiInfos> poiInfosList = new ArrayList<>();
		poiGsonBean.setPoiInfos(poiInfosList);
		try {
			JSONObject jsonObject = new JSONObject(strResult);
			poiGsonBean.setTotalHits(jsonObject.optInt("totalHits"));
			JSONArray poiInfoArray = jsonObject.optJSONArray("poiInfos");
			for (int i = 0; i < poiInfoArray.length(); i++) {
				PoiGsonBean.PoiInfos poiInfos = new PoiGsonBean.PoiInfos();
				JSONObject poiInfoObject = poiInfoArray.optJSONObject(i);
				poiInfos.setAddress(poiInfoObject.optString("address"));
				poiInfos.setName(poiInfoObject.optString("name"));
				poiInfos.setUid(poiInfoObject.optString("uid"));
				poiInfos.setTelephone(poiInfoObject.optString("telephone"));
				poiInfos.setScore(poiInfoObject.optInt("score"));

				JSONObject infoLocationObject = poiInfoObject.optJSONObject("location");
				PoiGsonBean.Location location = new PoiGsonBean.Location();
				location.setX(infoLocationObject.optDouble("x"));
				location.setY(infoLocationObject.optDouble("y"));
				poiInfos.setLocation(location);

				poiInfosList.add(poiInfos);
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return poiInfosList;

	}
	public static ArrayList<PoiGsonBean.Location> parseNavigation(String strResult) {

		ArrayList<PoiGsonBean.Location> locationList = new ArrayList<>();
		try {
			JSONObject jsonObject = new JSONObject(strResult);
			JSONArray locationArray = jsonObject.optJSONArray("pathPoints");
			for (int i = 0; i < locationArray.length(); i++) {
				PoiGsonBean.Location location = new PoiGsonBean.Location();
				JSONObject locationObject = locationArray.optJSONObject(i);
				location.setX(locationObject.optDouble("x"));
				location.setY(locationObject.optDouble("y"));
				locationList.add(location);

			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return locationList;
	}

}