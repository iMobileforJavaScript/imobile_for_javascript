/**
 * 
 */
package com.supermap.smNative;

import com.supermap.data.CursorType;
import com.supermap.data.Dataset;
import com.supermap.data.DatasetType;
import com.supermap.data.DatasetVector;
import com.supermap.data.DatasetVectorInfo;
import com.supermap.data.Datasets;
import com.supermap.data.Datasource;
import com.supermap.data.FieldInfo;
import com.supermap.data.FieldInfos;
import com.supermap.data.FieldType;
import com.supermap.data.GeoLineM;
import com.supermap.data.Recordset;
import com.supermap.data.Recordset.BatchEditor;
//import com.supermap.imobile.test.jira_imb.isCheck;




/**
 * @author XingJun 2018-3-28
 *
 */
public class Network_tool {
	
	public static final boolean ischeck=false;
	/**
	 * @author 袁玉
	 * @param name
	 *            : 数据集名
	 * @param datasource
	 *            ：目标数据源
	 * @param linems
	 *            ：路由数组
	 * @return 新建的数据集对象
	 */

	public static DatasetVector saveLineM(String name, Datasource datasource,
			GeoLineM[] linems) {
		return saveLineM(name, datasource, linems, true, null, null);
	}
	/**
	 * @param name
	 *            : 数据集名
	 * @param datasource
	 *            ：目标数据源
	 * @param linems
	 *            ：路由数组
	 * @param remove
	 *            ：是否删除原来同名数据集
	 * @param fieldName
	 *            ：添加的字段名
	 * @param fieldValue
	 *            ：字段值数组
	 * @return 新建的数据集对象
	 */
	public static DatasetVector saveLineM(String name, Datasource datasource,
			GeoLineM[] linems, boolean remove, String fieldName,
			double[] fieldValue) {
		if (name != null && datasource != null) {

			DatasetVectorInfo datasetInfo = new DatasetVectorInfo();
			datasetInfo.setType(DatasetType.CAD);
			Datasets datasets = datasource.getDatasets();
			// 判断是否删除原来的同名数据集
			if (remove == false) {
				name = datasets.getAvailableDatasetName(name);
			} else if (datasets.contains(name)) {
				datasets.delete(name);
			}
			datasetInfo.setName(name);
			DatasetVector linemDataset = datasource.getDatasets().create(
					datasetInfo);
			Recordset recordset_M = linemDataset.getRecordset(false,
					CursorType.DYNAMIC);
			recordset_M.moveFirst();

			try {
				// 添加路由几何对象和一个字段
				if (fieldName != null && fieldName != "") {
					FieldInfo fieldInfo = new FieldInfo();
					fieldInfo.setCaption(fieldName);
					fieldInfo.setName(fieldName);
					fieldInfo.setType(FieldType.DOUBLE);
					FieldInfos fieldInfos = linemDataset.getFieldInfos();
					int n = -1;
					try {
						recordset_M.dispose();
						n = fieldInfos.add(fieldInfo);
						linemDataset.open();
						recordset_M = linemDataset.getRecordset(false,
								CursorType.DYNAMIC);
						recordset_M.update();
						recordset_M.moveFirst();
					} catch (IllegalArgumentException e) {
						System.out.println("添加字段失败");
						e.printStackTrace();
					}

					if (n != -1) {
						// 如果添加字段成功，就保存几何对象和字段信息
						for (int i = 0; i < linems.length; i++) {
							if (linems[i] == null) {
								continue;
							}
							recordset_M.addNew(linems[i]);
							recordset_M.update();
							recordset_M.edit();
							recordset_M.setFieldValue(fieldName, fieldValue[i]);
							recordset_M.update();
						}
					} else {
						// 如果添加字段失败，就只保存几何对象
						BatchEditor batchEditor = recordset_M.getBatch();
						batchEditor.setMaxRecordCount(1000);
						batchEditor.begin();

						int recordsetCount = linems.length;
						for (int i = 0; i < recordsetCount; i++) {
							if (linems[i] == null) {
								continue;
							}
							if (i > 3) {
								continue;
							}
							recordset_M.addNew(linems[i]);
						}
						batchEditor.update();
					}
					fieldInfo.dispose();
				} else {
					// 只添加路由几何对象
					BatchEditor batchEditor = recordset_M.getBatch();
					batchEditor.setMaxRecordCount(1000);
					batchEditor.begin();

					int recordsetCount = linems.length;
					for (int i = 0; i < recordsetCount; i++) {
						if (linems[i] == null) {
							continue;
						}
						recordset_M.addNew(linems[i]);
					}
					batchEditor.update();
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				recordset_M.dispose();
			}
			
			datasetInfo.dispose();
			return linemDataset;
		}
		return null;
	}
	
	/**
	 * @param ds
	 * @param dtName
	 * @param backup
	 * @return expectedDt
	 */
	public static Dataset getExpectedDt(Datasource ds, String dtName,
			Dataset backup) {
		Dataset expectedDt = null;
		if (ds.getDatasets().contains(dtName)) {
			expectedDt = ds.getDatasets().get(dtName);
		} else if (backup != null) {
			expectedDt = ds.copyDataset(backup, dtName, backup.getEncodeType());
		}
		return expectedDt;
	}

		}
		