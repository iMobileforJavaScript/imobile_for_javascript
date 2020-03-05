package com.supermap.indoor;

import com.supermap.data.Datasource;

public interface IndoorMapChangedListener {

	public void openMap(String mapName, Datasource datasource);
	
	public void closeMap();
	
}
