package com.supermap.data;


/**
 * <p>
 * Title:
 * </p>
 * 
 * <p>
 * Description:
 * </p>
 * 
 * <p>
 * Copyright: Copyright (c) 2007
 * </p>
 * 
 * <p>
 * Company: SuperMap GIS Technologies Inc.
 * </p>
 * 
 * @author 李云锦
 * @version 2.0
 */
public abstract class Dataset extends InternalHandle {
	protected Datasource m_datasource = null;

	protected long m_selfEventHandle;
	
	protected static String m_senderMethodName;

	private PrjCoordSys m_prjCoordSys;

	protected Dataset() {
		m_senderMethodName = "PJConvert";
	}

	/**
	 * 判断数据集名是否合法
	 * 
	 * @param name
	 *            String
	 * @return InternalInvalidState 如果合法则返回null，不合法返回不合法的具体信息
	 */
	static InternalInvalidState isValidDatasetName(String name) {
		int ugcValue = FieldInfoNative.jni_IsValidTableName(name);
		if (ugcValue == -1) {
			return null;
		} else {
			return (InternalInvalidState) Enum.parseUGCValue(
					InternalInvalidState.class, ugcValue);
		}
	}
	
	public void setPrjCoordSys(PrjCoordSys value) {
		if (this.getHandle() == 0) {
			String message = InternalResource.loadString(
					"SetPrjCoordSys(PrjCoordSys value)",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		//Modified by HELH 当value为null时，重置投影信息
		if (value == null) {
			DatasetNative.jni_UnSetPrjCoordSys(getHandle());
			if(m_prjCoordSys != null){
				m_prjCoordSys.clearHandle();
				m_prjCoordSys = null;
			}
		} else {
			long valueHandle = InternalHandle.getHandle(value);
			if (valueHandle == 0) {
				String message = InternalResource.loadString("value",
						InternalResource.GlobalInvalidConstructorArgument,
						InternalResource.BundleName);
				throw new IllegalArgumentException(message);
			}
			m_prjCoordSys = (PrjCoordSys) value.clone();
			DatasetNative.jni_setPrjCoordSys(this.getHandle(), valueHandle);
		}
	}

	public PrjCoordSys getPrjCoordSys() {
		if (this.getHandle() == 0) {
			String message = InternalResource.loadString("GetPrjCoordSys()",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		// Added by Helh 2010-5-10
		// Reason: 保证数据集已打开
		// {
		if(!isOpen()){
			open();
		}
		//}
		if (m_prjCoordSys == null) {
			long handle = DatasetNative.jni_getPrjCoordSys(this.getHandle());
			if (handle != 0) {
				m_prjCoordSys = PrjCoordSys.createInstance(handle, false);
			}
		}
		return m_prjCoordSys;
	}

	private boolean hasVersion() {
		if (this.getHandle() == 0) {
			String message = InternalResource.loadString("hasVersion()",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		return DatasetNative.jni_hasVersion(this.getHandle());
	}
	
	/**
	 * 返回数据集的附加信息。
	 * 
	 * @return String
	 */
	public String getExtInfo() {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		return DatasetNative.jni_GetExtInfo(getHandle());
	}

	/**
	 * 设置数据集的附加信息。
	 * 
	 * @param value
	 *            String
	 */
	public void setExtInfo(String value) {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}

		if (value == null) {
			value = "";
		}
		
		if(value.length() > 2047)
		{
			throw new IllegalStateException("The length is outof range");
		}

		// 只读数据集也可以设置描述信息
		DatasetNative.jni_SetExtInfo(getHandle(), value);
	}

	/**
	 * 返回数据集中包含所有对象的最小外接矩形
	 * 
	 * @return Rectangle2D
	 */
	public Rectangle2D getBounds() {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		double[] params = new double[4];

		DatasetNative.jni_GetBounds(getHandle(), params);
		Rectangle2D bounds = new Rectangle2D(params[0], params[1], params[2],
				params[3]);
		return bounds;
	}

	/**
	 * 返回数据是否只读
	 * 
	 * @return boolean
	 */
	public boolean isReadOnly() {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		
		// @modified by 孔令亮 at 2007年12月17日 上午11时12分35秒
		// @reason:当Dataset所属的Datasource为只读时，则应该返回的是只读的。
		boolean isDatasourceReadOnly = m_datasource.isReadOnly();
		boolean isDatasetReadOnly = DatasetNative
				.jni_GetIsReadOnly(getHandle());
		return isDatasourceReadOnly || isDatasetReadOnly;
	}

	/**
	 * 判断数据集是否已经打开
	 * 
	 * @return boolean
	 */
	public boolean isOpen() {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		return DatasetNative.jni_GetIsOpen(getHandle());
	}

	/**
	 * 返回该Dataset对象实例所属数据源。
	 * 
	 * @return Datasource
	 */
	public Datasource getDatasource() {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		return this.m_datasource;
	}

	/**
	 * 返回数据集的描述信息。
	 * 
	 * @return String
	 */
	public String getDescription() {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		return DatasetNative.jni_GetDescription(getHandle());
	}

	/**
	 * 设置数据集的描述信息。
	 * 
	 * @param value
	 *            String
	 */
	public void setDescription(String value) {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}

		if (value == null) {
			value = "";
		}

		// 只读数据集也可以设置描述信息
		DatasetNative.jni_SetDescription(getHandle(), value);
	}

	/**
	 * 返回此Dataset的名称。
	 * 
	 * @return String
	 */
	public String getName() {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		return DatasetNative.jni_GetName(getHandle());
	}

    /**
     * 设置此Dataset的名称。
     *
     * @param name
     */
    public void setName(String name) {
        if (getHandle() == 0) {
            String message = InternalResource.loadString("",
                                                         InternalResource.HandleObjectHasBeenDisposed,
                                                         InternalResource.BundleName);
            throw new IllegalStateException(message);
        }
        if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
            String message = InternalResource.loadString("",
                                                         InternalResource.DatasetDatasoureIsEmpty,
                                                         InternalResource.BundleName);
            throw new IllegalStateException(message);
        }
       
        if(this.m_datasource.getDatasets().isAvailableDatasetName(name)){
            DatasetNative.jni_SetName(getHandle(),name);
        }
    }
    
	/**
	 * 返回数据集的类型
	 * 
	 * @return int
	 */
	public DatasetType getType() {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		int ugcType = DatasetNative.jni_GetType(getHandle());
		DatasetType javaType = null;
		try {
			// @modified by 李云锦 at 2007年8月13日 下午12时46分38秒
			// @reason 如果为Grid，不会有异常，为DEM的时候抛出异常并进行处理
			javaType = (DatasetType) Enum.parseUGCValue(DatasetType.class,
					ugcType);
		} catch (RuntimeException ex) {
			throw ex;
		}
		return javaType;
	}

	/**
	 * 得到数据集数据存储时的编码方式
	 * 
	 * @return int
	 */
	public EncodeType getEncodeType() {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		
		int ugcType = DatasetNative.jni_GetEncodeType(getHandle());
		return (EncodeType) Enum.parseUGCValue(EncodeType.class, ugcType);
	}

	/**
	 * 用于关闭数据集。
	 */
	public void close() {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		
		DatasetNative.jni_Close(getHandle());
	}

	/**
	 * 用于打开数据集，准备对数据集进行操作。
	 */
	public boolean open() {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		return DatasetNative.jni_Open(getHandle());
	}

	/**
	 * 内部使用 当底层的指针先行释放后，需要调用该方法将相应的字段清空 可能还包含有recordSet等对象也需要释放，后续完善
	 */
	protected void clearHandle() {
		this.m_datasource = null;
		this.m_prjCoordSys = null;
		setHandle(0);
	}

	protected static boolean isVector(Dataset dataset) {
		boolean isVector = true;
		if (dataset == null || dataset.getHandle() == 0) {
			isVector = false;
		} else {
			isVector = dataset.isVector();
		}
		return isVector;
	}

	// @modified by 孔令亮 at 2007年8月9日 上午11时21分35秒
	// @reason: 修改为 protected，供Layer的getDataset使用。
	protected static Dataset createInstance(long dtHandle,
			DatasetType javaType, Datasource datasource) {
		if (dtHandle == 0) {
			String message = InternalResource.loadString("",
					InternalResource.GlobalInvalidConstructorArgument,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		Dataset dataset = null;
		if (javaType.equals(DatasetType.IMAGE) || javaType.equals(DatasetType.WMS) || javaType.equals(DatasetType.WCS) ) {//移动端增加WMS数据类型，支持访问在线实时地图  add by huangkj 2015-10-28
			dataset = new DatasetImage(dtHandle, datasource);
		} else if (
				javaType.equals(DatasetType.LINE)
						|| javaType.equals(DatasetType.POINT)
						|| javaType.equals(DatasetType.REGION)
						|| javaType.equals(DatasetType.TABULAR)
						|| javaType.equals(DatasetType.POINT3D)
						|| javaType.equals(DatasetType.LINE3D)
						|| javaType.equals(DatasetType.REGION3D)
						|| javaType.equals(DatasetType.CAD)
						|| javaType.equals(DatasetType.NETWORK)
						|| javaType.equals(DatasetType.NETWORK3D)
						|| javaType.equals(DatasetType.TEXT)
						|| javaType.equals(DatasetType.NdfVector)
						|| javaType.equals(DatasetType.VECTORCACHE)
						|| javaType.equals(DatasetType.WFS)
				) {
			dataset = new DatasetVector(dtHandle, datasource);
		}else if (javaType.equals(DatasetType.GRID)
					|| javaType.equals(DatasetType.DEM)) {
				dataset = new DatasetGrid(dtHandle, datasource);
		}else {
			// Layer如果其对应的数据集是不认识的类型,该Layer能访问到,但是其Dataset为NULL,并且该Layer不会显示
			dataset = null;

		}
		return dataset;
	}
	
	// @added by 孔令亮 at 2007年8月13日 上午10时07分18秒
	// @reason:内部使用
	private boolean isVector() {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		return DatasetNative.jni_GetIsVector(getHandle());
	}

//	protected void clearSelfEventHandle() {
//		if (m_selfEventHandle != 0) {
//			DatasetImageNative.jni_DeleteSelfEventHandle(m_selfEventHandle);
//			m_selfEventHandle = 0;
//		}
//	}
	
	// 设置数据集是否只读
	//! \param readOnly 为true，设置数据集为只读
	public void setReadOnly(boolean readOnly) {
		if (getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.HandleObjectHasBeenDisposed,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}
		if (this.m_datasource == null || this.m_datasource.getHandle() == 0) {
			String message = InternalResource.loadString("",
					InternalResource.DatasetDatasoureIsEmpty,
					InternalResource.BundleName);
			throw new IllegalStateException(message);
		}

		DatasetNative.jni_SetReadOnly(getHandle(), readOnly);

	}
}
