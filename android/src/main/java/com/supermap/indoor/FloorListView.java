package com.supermap.indoor;

import java.util.ArrayList;
import java.util.List;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.AdapterView.OnItemClickListener;

import com.supermap.data.CoordSysTransMethod;
import com.supermap.data.CoordSysTransParameter;
import com.supermap.data.CoordSysTranslator;
import com.supermap.data.Point2Ds;
import com.supermap.data.PrjCoordSys;
import com.supermap.data.PrjCoordSysType;
import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetVector;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.data.Point2D;
import com.supermap.data.Recordset;
import com.supermap.data.Rectangle2D;
import com.supermap.data.Workspace;
import com.supermap.mapping.Layer;
import com.supermap.mapping.LayerGroup;
import com.supermap.mapping.Layers;
import com.supermap.mapping.Map;
import com.supermap.mapping.MapControl;
import com.supermap.mapping.MapOperateListener;
import com.supermap.mapping.MapParameterChangedListener;
import com.supermap.mapping.R;
import com.supermap.navi.FloorChangeListener;
import com.supermap.navi.Navigation3;

public class FloorListView extends LinearLayout {
	private Context mContext = null;
	private MapControl mMapControl = null;
	private Map mMap = null;
	
	private View mMainView = null;
	private ListView m_listViewLayer = null;
	private IndoorMapControl indoorMapControl = null;
	
	private FloorListViewAdapter mAdapter = null;
	
	private FloorChangeListener mFloorChangeListener = null;
	private IndoorMapChangedListener mIndoorMapChangeListener = null;
	
	// 当前打开的室内地图楼层ID
	String mFloorId = null;
	
	// 当前打开的室内地图数据源
	private String mDatasourceName = null;
	private Datasource mDatasource = null;
	
	public FloorListView(Context context) {
		super(context);
		// TODO Auto-generated constructor stub
		mContext = context;
		initView();
	}
	
	public FloorListView(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
		mContext = context;
		initView();
	}

	private void initView() {
		ResourcesLoader.mIsJar = true;
		String UGCConfigDirectory = mContext.getFilesDir().getAbsolutePath() + "/config/mapRes/map.jar";
		ResourcesLoader.setResourcesPath(UGCConfigDirectory);
		
		mMainView = ResourcesLoader.findbyid(mContext, R.layout.ui_supermap_floorlist, null);
		m_listViewLayer = (ListView)mMainView.findViewById(R.id.lst_supermap_floor_list);
		
		m_listViewLayer.setCacheColorHint(0);
		m_listViewLayer.setDivider(null);
		m_listViewLayer.setPadding(3, 3, 3, 3);
		m_listViewLayer.setOverScrollMode(View.OVER_SCROLL_NEVER);
		
		LayoutParams params = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
		addView(mMainView, params);
		
		initialAdapter();
	}
	
	/**
	 * 链接MapControl
	 * @param mapControl
	 */
	public void linkMapControl(MapControl mapControl) {
		mMapControl = mapControl;
		mMap = mapControl.getMap();
		
		// 设置适配器
		indoorMapControl = new IndoorMapControl();
		indoorMapControl.setFloorListView(this);

		// 关联室内导航类
		final Navigation3 navigation3 = mMapControl.getNavigation3();
		
		if (navigation3 != null) {
			this.setFloorChangeListener(new FloorChangeListener() {
				
				@Override
				public void floorChange(String name, String strFloorId) {
					// TODO Auto-generated method stub
					navigation3.setCurrentFloorId(strFloorId);
				}
			});
			
			navigation3.setFloorChangeListener(new FloorChangeListener() {
				
				@Override
				public void floorChange(String name, String strFloorId) {
					// TODO Auto-generated method stub
					FloorListView.this.setCurrentFloorId(strFloorId);
				}
			});
		}
		
		indoorMapControl.linkMapControl();
	}
	
	/**
	 * 加载楼层列表
	 * @param map
	 */
	void loadMap(LayerGroup layerGroup) {		
		// 设置适配器
		mAdapter.setLayerGroup(layerGroup);
	}
	
	/**
	 * 设置当前楼层
	 * @param value
	 */
	public void setCurrentFloorId(String id) {
		mFloorId = id; 
		
		int position = getFloorIndex(id);
		mAdapter.showFloor(position);
		
		m_listViewLayer.smoothScrollToPosition(position);
	}
	
	// 获取当前楼层ID
	public String getCurrentFloorId() {
		return mFloorId;
	}
	
	// 获取当前室内数据源
	public Datasource getIndoorDatasource() {
		return mDatasource;
	}
	
    public void setFloorChangeListener(FloorChangeListener listener) {
    	mFloorChangeListener = listener;
	}
    
    private void changeFloor(String layerName) {
		mFloorId = getFloorId(layerName);
		
    	if (mFloorChangeListener != null) {
			mFloorChangeListener.floorChange(layerName, mFloorId);
		}
    }
    
    public void setIndoorMapChangeListener(IndoorMapChangedListener listener) {
    	mIndoorMapChangeListener = listener;
	}
    
    private void fireOpenMap(String mapName, String datasourceName) {
    	mDatasourceName = datasourceName;
    	mDatasource = mMapControl.getMap().getWorkspace().getDatasources().get(mDatasourceName);
    	
    	if (mIndoorMapChangeListener != null) {
			mIndoorMapChangeListener.openMap(mapName, mDatasource);
		}
    }
    
    private void fireCloseMap() {
    	mDatasourceName = null;
    	mDatasource = null;
    	mFloorId = null;
    	
    	if (mIndoorMapChangeListener != null) {
			mIndoorMapChangeListener.closeMap();
		}
    }
    
	private void initialAdapter(){
		mAdapter = new FloorListViewAdapter(m_listViewLayer, mContext);  
		m_listViewLayer.setAdapter(mAdapter);  
	}

	private int getFloorIndex(String strFloorId) {
		if (mDatasource == null) {
			return -1;
		}
		
		Datasets datasets = mDatasource.getDatasets();
		Dataset dataset = datasets.get("FloorRelationTable");
		
		if(dataset == null) {
			return -1;
		}

		String layerName = null;
		DatasetVector datasetVector = (DatasetVector)dataset;
		
		String sql = mMapControl.getNavigation3().getFloorIDFieldName() + " = '" + strFloorId + "'";
		Recordset recordset = datasetVector.query(sql, CursorType.STATIC);
		
		if(!recordset.isEOF()) {
			layerName = recordset.getString("LayerName");
		}
		
		for (int i = 0; i < mAdapter.mLayerList.size(); i++) {
			Layer layer = mAdapter.mLayerList.get(i);
			
			if (layer.getName().equals(layerName)) {
				return i;
			}
		}

		return -1;
	}
	
	private String getFloorId(String layerName) {
		if (mDatasource == null) {
			return null;
		}
		
		Datasets datasets = mDatasource.getDatasets();
		Dataset dataset = datasets.get("FloorRelationTable");
		
		if(dataset == null) {
			return null;
		}
		
		String strFloorId = null;
		
		DatasetVector datasetVector = (DatasetVector)dataset;
		String sql = "LayerName = '" + layerName + "'";
		Recordset recordset = datasetVector.query(sql, CursorType.STATIC);
		
		if(!recordset.isEOF()) {
			strFloorId = recordset.getString(mMapControl.getNavigation3().getFloorIDFieldName());
		}
		
		return strFloorId;
	}
	
    class FloorListViewAdapter extends BaseAdapter
    {
    	protected Context mContext;
    	
    	// 选中的楼层
    	int mSelectIndex = 0;
    	
    	/**
    	 * 存储所有的楼层
    	 */
    	protected List<Layer> mLayerList;

    	public FloorListViewAdapter(ListView mTree, Context context)
    	{
    		mContext = context;  		
    		mLayerList = new ArrayList<Layer>();
    		
    		mTree.setOnItemClickListener(new OnItemClickListener()
    		{
    			@Override
    			public void onItemClick(AdapterView<?> parent, View view,
    					int position, long id)
    			{
    				showFloor(position);
    			}
    		});
    	}

    	/**
    	 * 显示某一楼层
    	 * @param position
    	 */
    	public void showFloor(int position)
    	{
    		if (position < 0) {
    			return;
			}
    		
    		mSelectIndex = position;
    		
    		int nCount = mLayerList.size();
    		for (int i = 0; i < nCount; i++) {
    			Layer layer = mLayerList.get(i);

    			if (mSelectIndex == i) {
    				layer.setVisible(true);
    				changeFloor(layer.getName());
				} else {
					layer.setVisible(false);
				}
			}
    		mMap.refresh();
    		notifyDataSetChanged();// 刷新视图
    	}
    	
    	public void setLayerGroup(LayerGroup layerGroup) {
    		mLayerList = initLayerList(layerGroup);
    		notifyDataSetChanged();// 刷新视图
    		
    		android.view.ViewGroup.LayoutParams layoutParams = m_listViewLayer.getLayoutParams();
    		if (mLayerList.size() < 5) {
    			layoutParams.height = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
			} else {
				layoutParams.height = dp2px(mContext, 210);
			}
    		m_listViewLayer.setLayoutParams(layoutParams);
		}
    	
    	 /**
         * 根据手机的分辨率从  dp 的单位转成为  px(像素)
         */
    	public int dp2px(Context context, float dipValue) {    
    	     final float scale = context.getResources().getDisplayMetrics().density;    
    	     return (int) (dipValue * scale + 0.5f);    
    	}  

    	@Override
    	public int getCount()
    	{
    		return mLayerList.size();
    	}

    	@Override
    	public Object getItem(int position)
    	{
    		return mLayerList.get(position);
    	}

    	@Override
    	public long getItemId(int position)
    	{
    		return position;
    	}
 
    	@Override
    	public View getView(int position, View convertView, ViewGroup parent)
    	{
    		final ViewHolder viewHolder;
    		
    		if (convertView == null)
    		{
    			convertView = ResourcesLoader.findbyid(mContext, R.layout.ui_supermap_floorlist_item, null);
    			viewHolder = new ViewHolder(); 
    			viewHolder.txt_label = (TextView)convertView.findViewById(R.id.txt_supermap_floorlist_lable);
    			convertView.setTag(viewHolder);
    		} else
    		{
    			viewHolder = (ViewHolder) convertView.getTag();
    		}
    		
    		Layer layer = mLayerList.get(position);
			if(layer!=null)
			{
				String strCaption = layer.getCaption();	
				viewHolder.txt_label.setText(strCaption);
    		
				if (position == mSelectIndex) {
					viewHolder.txt_label.setTextColor(Color.WHITE);
					viewHolder.txt_label.setBackground(getDrawable(R.drawable.circle_shape));
				} else {
					viewHolder.txt_label.setTextColor(Color.BLACK);
					viewHolder.txt_label.setBackground(null);
				}
			}
    		
    		return convertView;
    	}

    	private Drawable getDrawable(int resId) {
    		Drawable drawable = ResourcesLoader.getResources(mContext).getDrawable(resId);
    		return drawable;
    	}
    	
    	private class ViewHolder
    	{ 			
    		TextView txt_label;
    	}
    	
    	private List<Layer> initLayerList(LayerGroup layerGroup) {
    		List<Layer> layerList = new ArrayList<Layer>();
    		
    		if (layerGroup == null) {
				return layerList;
			}
    		
    		int nCount = layerGroup.getCount();

    		for (int i = 0; i < nCount; i++) {
    			Layer layer = layerGroup.get(i);
    			layerList.add(layer);

//    			if (layer.getCaption().equals("F1")) {
//					mSelectIndex = i; //默认选中一层
//					layer.setVisible(true);
//				} else {
//					layer.setVisible(false);
//				}

    			if (layer.isVisible()) {
    				mSelectIndex = i;
    				changeFloor(layer.getName());
				}
			}
    		
			return layerList;
    	}
    }
    
    
    /***********************************
     * 室内地图控制类
     * @author kangweibo
     *
     ***********************************/
    class IndoorMapControl {
    	
    	Layers mLayers = null;
    	Workspace mWorkspace = null;
    	DatasetVector mDatasetVector = null;
    	
    	// 蒙版图层
//    	Layer mLayerMask = null;
    	
    	FloorListView mFloorListView = null;
    	
    	double minScale = 1/2500.0;
    	
    	// 是否需要显示室内地图（根据比例尺确定）
    	boolean isNeedShowIndoor = false;
    	
    	// 是否在室内地图范围内（作为开关）
    	boolean isIndoorBounds = false;
    	
    	/**
    	 * 加载地图
    	 * @param map
    	 */
    	public void linkMapControl() {	

    		mMapControl.setMapParamChangedListener(new MapParameterChangedListener() {
    			
    			@Override
    			public void sizeChanged(int arg0, int arg1) {
    				// TODO Auto-generated method stub
    				
    			}
    			
    			@Override
    			public void scaleChanged(double arg0) {
    				// TODO Auto-generated method stub
    				checkMapScale(arg0);
    			}
    			
    			@Override
    			public void boundsChanged(Point2D arg0) {
    				// TODO Auto-generated method stub
    				checkMapBounds(arg0);
    			}
    			
    			@Override
    			public void angleChanged(double arg0) {
    				// TODO Auto-generated method stub
    				
    			}
    		});
    		
    		mMap.setMapOperateListener(new MapOperateListener() {
				
				@Override
				public void mapOpened() {
					// TODO Auto-generated method stub
					initMapData();
				}
				
				@Override
				public void mapClosed() {
					// TODO Auto-generated method stub
					isIndoorBounds = false;
					isNeedShowIndoor = false;
	    			if (mFloorListView != null) {
	    				mFloorListView.setVisibility(View.INVISIBLE);
	    				fireCloseMap();
	    			}	
				}
			});
    		
    		initMapData();		
    		getMaskLayer();
    	}
    	
    	public void setFloorListView(FloorListView floorListView) {
    		mFloorListView = floorListView;
    		mFloorListView.setVisibility(View.INVISIBLE);
    	}

    	private void checkMapScale(double scale) {
    		if (scale < minScale) {
				isNeedShowIndoor = false;
				
				if (isIndoorBounds) {
					isIndoorBounds = false;
					
					if (mFloorListView != null) {
						mFloorListView.setVisibility(View.INVISIBLE);
//						mLayerMask.setVisible(false);
//						mMap.refresh();
					}
				}			
			} else {
				isNeedShowIndoor = true;
			}
    	}
    	
        private boolean safeGetType(PrjCoordSys coordSys1, PrjCoordSysType coordSys2) {
			try {
				if (coordSys1.getType() == coordSys2) {
					return true;
				}
				return false;
			} catch (Exception e) {
				return false;
			}
	}    	
        private void checkMapBounds(Point2D point) {
    		if (!isNeedShowIndoor) {
				return;
			}
    		
    		if (mDatasetVector == null || mLayers == null) {
        		return;
    		}
			
            if (!safeGetType(mMap.getPrjCoordSys(), PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE)) {
                Point2Ds point2Ds = new Point2Ds();
                point2Ds.add(point);
                PrjCoordSys prjCoordSys = new PrjCoordSys();
                prjCoordSys.setType(PrjCoordSysType.PCS_EARTH_LONGITUDE_LATITUDE);
                CoordSysTransParameter parameter = new CoordSysTransParameter();

                CoordSysTranslator.convert(point2Ds, mMap.getPrjCoordSys() ,prjCoordSys, parameter, CoordSysTransMethod.MTH_GEOCENTRIC_TRANSLATION);
                point = point2Ds.getItem(0);
            }


    		Rectangle2D bounds = new Rectangle2D(point, 0, 0);
    		Recordset recordset = mDatasetVector.query(bounds, CursorType.STATIC);

    		if (recordset == null || recordset.getRecordCount() < 1) {
    			isIndoorBounds = false;
    			
    			if (mFloorListView != null) {
    				mFloorListView.setVisibility(View.INVISIBLE);
    				
    				fireCloseMap();
//    				mLayerMask.setVisible(false);
//    				mMap.refresh();
    			}
    			
    			return;
    		}
    		
    		if (isIndoorBounds) {
    			return;
    		}

    		isIndoorBounds = true;

    		String strIndoorMapName = recordset.getString("LinkName");
    		String strLinkDatasource = recordset.getString("LinkDatasource");
    		recordset.close();
    		recordset.dispose();

    		fireOpenMap(strIndoorMapName, strLinkDatasource);
    		
    		Layer layerIndoor = null;
    		for (int i = 0; i < mLayers.getCount(); i++) {
    			Layer layer = mLayers.get(i);
    			if (layer.getCaption().equals("indoor")) {
    				layerIndoor = layer;
    			}
    		}

    		if (layerIndoor == null) {
    			return;
    		}
    		
    		if (layerIndoor instanceof LayerGroup) {	
    			LayerGroup indoorMaps = (LayerGroup)layerIndoor;
    			int nCount = indoorMaps.getCount();
        		
        		for (int i = 0; i < nCount; i++) {
        			Layer layer = indoorMaps.get(i);
        			if (layer.getName().equals(strIndoorMapName)) {
    					
        				LayerGroup indoorMap = (LayerGroup)layer;
        				if (mFloorListView != null) {
        					mFloorListView.loadMap(indoorMap);
        					mFloorListView.setVisibility(View.VISIBLE);
//        					mLayerMask.setVisible(true);
//        					mMap.refresh();
    					}
    				}
    			}
    		}
    	}
    	
    	// 初始化地图数据
    	private void initMapData() {
    		mLayers = mMap.getLayers();
    		
    		if (mLayers == null) {
				return; //
			}
			mDatasetVector = null;
    		mWorkspace = mMap.getWorkspace();
			Datasource datasource = mWorkspace.getDatasources().get("bounds");
    		
    		if (datasource != null) {
    			mDatasetVector = (DatasetVector)datasource.getDatasets().get("building");
    		}
    		
    		double scale = mMap.getScale();
    		Point2D point = mMap.getCenter();
    		checkMapScale(scale);
    		checkMapBounds(point);
    	}

    	// 获取蒙版图层
    	private void getMaskLayer() {
    		
//    		for (int i = 0; i < mLayers.getCount(); i++) {
//    			Layer layer = mLayers.get(i);
//    			if (layer.getCaption().equals("mask")) {
//    				mLayerMask = layer;
//    			}
//    		}
    	}
    }
}
