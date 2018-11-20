//
//  OverlayAnalyst.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>
@class DatasetVector;
@class OverlayAnalystParameter;
@class Recordset;

/**  叠加分析类。
 <p>该类用于对输入的两个数据集或记录集之间进行各种叠加分析运算，如如裁剪（clip）、擦除（erase）、合并（union）、同一（identity）、对称差（xOR）和更新（update）。</p>
 <p>叠加分析是 GIS 中的一项非常重要的空间分析功能。是指在统一空间参考系统下，通过对两个数据集进行的一系列集合运算，产生新数据集的过程。叠加分析广泛应用于资源管理、城市建设评估、国土管理、农林牧业、统计等领域。因此，通过此叠加分析类可实现对空间数据的加工和分析，提取用户需要的新的空间几何信息，并且对数据的属性信息进行处理。</p>
 <p> 注意： </p>
  <p> 1. 进行叠加分析的两个数据集中，被称作输入数据集（在 SuperMap GIS 中称作第一数据集）的那个数据集，其类型可以是点、线、面等；另一个被称作叠加数据集（在 SuperMap GIS 中称作第二数据集），其类型一般是面类型。 </p>
  <p> 2. 应注意面数据集或记录集中本身应避免包含重叠区域，否则叠加分析结果可能出错。 </p>
  <p> 3. 叠加分析的数据必须为具有相同地理参考的数据，包括输入数据和结果数据。 </p>
  <p> 4. 在叠加分析的数据量很大的情况下，需对结果数据集创建空间索引，以提高数据的显示速度。 </p>
*/
@interface OverlayAnalyst : NSObject

/**@brief 对矢量数据集进行裁剪,将被裁剪数据集（第一个数据集）中不在裁剪数据集（第二个数据集）内的对象裁剪并删除。
 <p>注意：</p>
 1. 裁剪数据集（第二数据集）的类型必须是面，被裁减的数据集（第一数据集）可以是点、线、面。
 2. 在被裁减的数据集中，只有落在裁剪数据集多边形内的对象才会被输出到结果数据集中。
 3. 裁剪数据集、被裁减数据集以及结果数据集的地理坐标系必须一致。
 4. clip 与 intersect 在空间处理上是一致的，不同在于对结果记录集属性的处理，clip 分析只是用来做裁剪，结果记录集与第一个记录集的属性表结构相同，此处叠加分析参数对象设置无效。而 intersect求交分析的结果则可以根据字段设置情况来保留两个记录集的字段。
 5. 所有叠加分析的结果都不考虑数据集的系统字段。
 @param  dataset 被裁减的数据集，也称第一数据集。该数据集的类型可以是点、线和面。
 @param  clipDataset 用于裁剪的数据集，也称第二数据集。该数据集类型必须是面。
 @param  resultDataset 存放裁剪结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。此处该对象设置无效。
 @return  分析成功返回值为true，失败返回值为false。
 */
+(BOOL)clip:(DatasetVector *)dataset clipDataset:(DatasetVector *)clipDataset resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 对记录集进行裁剪，将第一个记录集中不在第二个记录集内的对象裁剪并删除。
 <p>注意：</p>
 1.  裁剪记录集（第二记录集）的类型必须是面，被裁减的记录集（第一记录集）可以是点、线、面。
 2. 在被裁减记录集中，只有落在裁剪记录集多边形内的对象才会被输出到结果数据集中。
 3. 裁剪记录集、被裁减记录集以及结果数据集的地理坐标系必须一致。
 4. clip 与 intersect 在空间处理上是一致的,不同在于对结果数据集属性的处理，clip 分析只是用来做裁剪，结果数据集与第一个数据集的属性表结构相同，此处叠加分析的参数对象设置无效。而Intersect求交分析的结果则可以根据字段设置情况来保留两个数据集的字段。
 5. 所有叠加分析的结果都不考虑记录集的系统字段。
 @param  recordset 被裁减的记录集，也称为第一记录集。该记录集类型可以是点、线和面。
 @param  clipRecordSet 用于裁剪的记录集，也成为第二记录集。该记录集类型必须是面类型。
 @param  resultDataset 存放裁剪结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。此处该对象设置无效。
 @return  分析成功返回值为true,失败返回值为false。
 */
+(BOOL)clip:(Recordset *)recordset clipRecordSet:(Recordset *)clipRecordSet resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 对矢量数据集进行裁剪，将被裁剪数据集中不在几何对象数组范围内的对象裁剪并删除。
 <p>注意：</p>
 1. 裁剪几何对象的类型必须是面，被裁减的数据集可以是点、线、面。
 2. 在被裁减数据集中，只有落在裁剪几何对象内的对象才会被输出到结果数据集中。
 3. 用于裁剪的几何对象数组、被裁减的数据集以及结果数据集的地理坐标系必须一致。
 4. clip 与 intersect 在空间处理上是一致的，不同在于对结果数据集属性的处理，clip 分析只是用来做裁剪，结果数据集与第一个数据集的属性表结构相同，此处叠加分析的参数设置无效。而intersect求交分析的结果则可以根据字段设置情况来保留两个数据集的字段。
 5. 所有叠加分析的结果都不考虑数据集的系统字段。
 @param  dataset 被裁减的数据集。该数据集类型可以是点、线和面。
 @param  clipGeometries 用于裁剪的几何对象数组，并且该数组中的几何对象必须是面几何对象。
 @param  resultDataset 存放裁剪结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。此处该对象设置无效。
 @return  分析成功返回值为true,失败返回值为false。
 */
+(BOOL)clip:(DatasetVector *)dataset clipGeometries:(NSMutableArray *)clipGeometries resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 用于对数据集进行擦除方式的叠加分析，将第一个数据集中包含在第二个数据集内的对象裁剪并删除。
 <p>注意：</p>
 1. 擦除数据集（第二数据集）的类型必须是面，被擦除的数据集（第一数据集）可以是点、线、面数据集。
 2. 擦除数据集中的多边形集合定义了擦除区域，被擦除数据集中凡是落在这些多边形区域内的特征都将被去除。而落在多边形区域外的特征要素都将被输出到结果数据集中，与clip运算相反。
 3.  擦除数据集、被擦除数据集以及结果数据集的地理坐标系必须一致。
 @param  dataset 被擦除的数据集，也称第一数据集。该数据集类型为点、线和面类型。
 @param  eraseDataset 用于擦除的数据集，也称第二数据集。该数据集类型必须是面数据集类型。
 @param  resultDataset 存放分析结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
 @return  分析成功返回值为true,失败返回值为false。
 */
+(BOOL)erase:(DatasetVector *)dataset eraseDataset:(DatasetVector *)eraseDataset resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 用于对记录集进行擦除方式的叠加分析，将第一个记录集中包含在第二个记录集内的对象裁剪并删除。
 <p>注意：用于擦除的记录集、被擦除的记录集以及结果数据集的地理坐标系必须一致。</p>
 @param  recordset 被擦除的记录集 ，也称第一记录集。该记录集为点、线和面类型。
 @param  eraseRecordset 用于擦除的记录集，也称第二记录集。该记录集类型必须是面类型。
 @param  resultDataset 存放分析结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
 @return  分析成功返回值为true,失败返回值为false。
 */
+(BOOL)erase:(Recordset *)recordset eraseRecordset:(Recordset *)eraseRecordset resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 用于对数据集进行擦除方式的叠加分析，将被擦除的数据集中包含在几何对象数组内的对象裁剪并删除.
 <p>注意：用于擦除的几何对象数组、被擦除的数据集以及结果数据集的地理坐标系必须一致。</p>
 @param  dataset 被擦除的数据集，该数据集类型为点、线和面类型。
 @param  eraseGeometries 用于擦除的几何对象数组，并且该数组中的几何对象 必须是面几何对象。
 @param  resultDataset 存放分析结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
 @return  分析成功返回true,失败返回false。
 */
+(BOOL)erase:(DatasetVector *)dataset eraseGeometries:(NSMutableArray *)eraseGeometries resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 用于对两个面数据集进行合并方式的叠加分析，结果数据集中保存被合并叠加分析的数据集和用于合并叠加分析的数据集中的全部对象，并且对相交部分进行求交和分割运算。
 <p>注意：</p>
 1. 合并是求两个数据集并的运算，合并后的图层保留两个数据集所有图层要素，只限于两个面数据集之间进行。
 2. 进行 union 运算后，两个面数据在相交处多边形被分割，且两个数据集的几何和属性信息都被输出到结果数据集中。
 3. 用于合并叠加分析的数据集、被合并叠加分析的数据集以及结果数据集的地理坐标系必须一致。
 @param  dataset 被合并叠加分析的数据集，必须是面数据集类型。
 @param  unionDataset 用于合并叠加分析的数据集，必须是面数据集类型。
 @param  resultDataset 存放分析结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
 @return  分析成功返回值为true,失败返回值为false。
 */
+(BOOL)union:(DatasetVector *)dataset unionDataset:(DatasetVector *)unionDataset resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 用于对两个面记录集进行合并方式的叠加分析,结果数据集中保存被合并叠加分析的记录集和用于合并叠加分析的记录集中的全部对象，并且对相交部分进行求交和分割运算。
<p>注意，用于合并叠加分析的记录集、被合并叠加分析的记录集以及结果数据集的地理坐标系必须一致。</p>
@param  recordset 被合并叠加分析的记录集，必须是面。
@param  unionRecordset 用于合并叠加分析的记录集，必须是面。
@param  resultDataset 存放分析结果的数据集。
@param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
@return  分析成功返回值为true,失败返回值为false。
 */
+(BOOL)union:(Recordset *)recordset unionRecordset:(Recordset *)unionRecordset resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 对面数据集用面对象数组进行合并方式的叠加分析，结果数据集中保存被合并叠加分析的数据集和用于合并叠加分析的面对象数组中的全部对象，并且对相交部分进行求交和分割运算。
<p>注意，用于合并叠加分析的面对象数组、被合并叠加分析的数据集以及结果数据集的地理坐标系必须一致。</p>
@param  dataset 被合并叠加分析的数据集，必须是面数据集。
@param  unionGeometries 用于合并叠加分析的面对象数组。
@param  resultDataset 存放分析结果的数据集。
@param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
@return  分析成功返回true,失败返回fale。
 */
+(BOOL)union:(DatasetVector *)dataset unionGeometries:(NSMutableArray *)unionGeometries resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 进行相交方式的叠加分析,将被相交叠加分析的数据集不包含在用来相交叠加分析的数据集中的对象切割并删除。即两个数据集中重叠的部分将被输出到结果数据集中，其余部分将被排除。
<p>注意：</p>
1. 被相交叠加分析的数据集可以是点类型、线类型和面类型，用来相交叠加分析的数据集必须为面类型。第一数据集的特征对象（点、线和面）在与第二数据集中的多边形相交处被分裂（点对象除外），分裂结果被输出到结果数据集中。
2. 相交运算与裁剪运算得到的结果数据集的空间几何信息是相同的，但是裁剪运算不对属性表做任何处理，而求交运算可以让用户选择需要保留的属性字段。
3. 用于相交叠加分析的数据集、被相交叠加分析的数据集以及结果数据集的地理坐标系必须一致。
@param  dataset 被相交叠加分析的数据集，该数据集的类型可以是点、线、面数据集。
@param  intersectDataset 用来相交叠加分析的数据集，该数据集必须是面数据集。
@param  resultDataset 存放分析结果的数据集。
@param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
@return  分析成功返回true,失败返回fale。
 */
+(BOOL)intersect:(DatasetVector *)dataset intersectDataset:(DatasetVector *)intersectDataset resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 进行相交方式的叠加分析，将被相交叠加分析的记录集中不包含在用来相交叠加分析的记录集中的对象切割并删除。
<p>注意，用来相交叠加分析的记录集，被相交分析的记录集以及结果数据集的地理坐标系必须一致。</p>
@param  recordset 被相交叠加分析的记录集，该类型可以是点、线、面类型。
@param  intersectRecordset 用来相交叠加分析的记录集，必须是面。
@param  resultDataset 存放分析结果的数据集。
@param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
@return  分析成功返回值为true,分析失败返回值为false。
 */
+(BOOL)intersect:(Recordset *)recordset intersectRecordset:(Recordset *)intersectRecordset resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 进行相交方式的叠加分析，将被相交叠加分析的数据集中不包含在用来相交叠加分析的面对象数组的对象切割并删除。
<p>注意：用来相交叠加分析的面对象数组、被相交分析的数据集以及结果数据集地理坐标系必须一致。</p>
 @param  dataset 被相交叠加分析的数据集，该数据集的类型可以是点、线、面数据集。
 @param  intersectGeometries 用来相交叠加分析的面对象数组。
 @param  resultDataset 存放分析结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
 @return  分析成功返回值为true,分析失败返回值为false。
 */
+(BOOL)intersect:(DatasetVector *)dataset intersectGeometries:(NSMutableArray *)intersectGeometries resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 用于对数据集进行同一方式的叠加分析，结果数据集中保留被同一运算的数据集的全部对象和被同一运算的数据集与用来进行同一运算的数据集相交的对象。
<p>注意：</p>
1. 同一运算就是第一数据集与第二数据集先求交，然后求交的结果再与第一数据集求并的一个运算。其中，第二数据集的类型必须是面，第一数据集的类型可以是点、线、面数据集。如果第一个数据集为点数据集，则新生成的数据集中保留第一个数据集的所有对象；如果第一个数据集为线数据集，则新生成的数据集中保留第一个数据集的所有对象，但是把第二个数据集相交的对象在相交的地方打断；如果第一个数据集为面数据集，则结果数据集保留以第一数据集为控制边界之内的所有多边形，并且把与第二个数据集相交的对象在相交的地方分割成多个对象。
2. identity 运算与 union 运算有相似之处，所不同之处在于 union 运算保留了两个数据集的所有部分，而 identity 运算是把第一个数据集中与第二个数据集不相交的部分进行保留。identity 运算的结果属性表来自于两个数据集的属性表。
3. 用于进行同一运算的数据集、被同一运算的数据集以及结果数据集的地理坐标系必须一致。
 @param  dataset 被同一运算的数据集，可以是点、线、面类型。
 @param  identityDataset 用来进行同一运算的数据集，必须为面类型。
 @param  resultDataset 存放分析结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
 @return  分析成功返回值为true,分析失败返回值为false。
 */
+(BOOL)identity:(DatasetVector *)dataset identityDataset:(DatasetVector *)identityDataset resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 用于对记录集进行同一方式的叠加分析，结果数据集中保留被统一运算的记录集的全部对象和被同一运算的记录集与用来进行同一运算的记录集相交的对象。
<p>注意，用于进行同一运算的记录集、被同一运算的记录集以及结果数据集的地理坐标系必须一致。</p>
@param  recordset 被同一运算的记录集，也成为第一记录集，可以是点、线、面类型。
@param  identityRecordset 用来进行同一运算的记录集，也成为第二记录集，必须为面类型。
@param  resultDataset 存放分析结果的数据集。
@param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
 */
+(BOOL)identity:(Recordset *)recordset identityRecordset:(Recordset *)identityRecordset resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 用于对数据集进行同一方式的叠加分析，结果数据集中保留被同一运算的数据集的全部对象和被同一运算的数据集与用来进行同一运算的几何对象数组相交的对象。
<p>注意，用于进行同一运算的几何对象数组、被同一运算的数据集以及结果数据集的地理坐标系必须一致。</p>
 @param  dataset 被同一运算的数据集，可以是点、线、面类型。
 @param  identityGeometries 用来相交叠加分析的面对象数组。
 @param  resultDataset 存放分析结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
 @return  分析成功返回true,否则返回false。
 */
+(BOOL)identity:(DatasetVector *)dataset identityGeometries:(NSMutableArray *)identityGeometries resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 对两个面数据集进行对称差运算。即交集取反运算。
<p>用于对称差分析的数据集、被对称差分析的数据集以及结果数据集的地理坐标系必须一致。</p>
<P>对称差运算是两个数据集的异或运算。操作结果是，对于每一个面对象，去掉其与另一个数据集中的几何对象相交的部分，而保留剩下的部分。对称差运算的输出结果的属性表包含两个输入数据集的非系统属性字段。</p>
 @param  dataset 被对称差分析的原数据集，必须是面数据集。
 @param  xORDataset 用于对称差分析的数据集，必须是面数据集。
 @param  resultDataset 存放分析结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
 @return  分析成功返回值为true,失败返回值为false。
 */
+(BOOL)xOR:(DatasetVector *)dataset xORDataset:(DatasetVector *)xORDataset resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 对两个面记录集进行对称差分析运算。
<p>注意，用于对称差分析的记录集、被对称差分析的记录集以及结果数据集的地理坐标系必须一致。</p>
 @param  recordset 被对称差分析的源记录集，必须是面。
 @param  xORRecordset 用于对称差分析的记录集，必须是面。
 @param  resultDataset 存放分析结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
 @return  分析成功返回值为true,失败返回值为false。
 */
+(BOOL)xOR:(Recordset *)recordset xORRecordset:(Recordset *)xORRecordset resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 对面数据集用面对象数组进行对称差分析运算，即交集取反运算。操作的结果是，对于面数据集中的每一个面对象，去掉其与面对象数组中的对象相交的部分，而保留剩下的部分。
<p>注意：用于对称差分析的面对象数组，对称差分析的源数据集以及结果数据集的地理坐标系必须一致。</p>
 @param  dataset 对称差分析的源数据集，必须是面数据集。
 @param  xORGeometries 用于对称差分析的面对象数组。
 @param  resultDataset 存放分析结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
 @return  分析成功返回值为true,失败返回值为false。
 */
+(BOOL)xOR:(DatasetVector *)dataset xORGeometries:(NSMutableArray *)xORGeometries resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 用于对两个面数据集进行更新方式的叠加分析，更新运算时用用于更新的数据集替换与被更新数据集重合的部分，是一个先擦除后粘贴的过程。
 <p>用于更新叠加分析的数据集、被更新叠加分析的数据集以及结果数据集的地理坐标系必须一致。</p>
 <p>第一数据集与第二数据集的类型都必须是面数据集。结果数据集中保留了更新数据集的几何形状和属性信息。</p>
@param  dataset 被更新叠加分析的数据集，必须是面类型。
@param  updateDataset 用于更新叠加分析的数据集，必须是面数据集。
@param  resultDataset 存放分析结果的数据集。
@param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
@return  分析成功返回值为true,失败返回值为false。
 */
+(BOOL)update:(DatasetVector *)dataset updateDataset:(DatasetVector *)updateDataset resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 用于对两个面记录集进行更新方式的叠加分析，更新运算是用用于更新的记录集替换它与被更新记录集的重合部分，是一个先擦除后粘贴的过程。
 <p>注意，用于更新叠加分析的记录集，被更新叠加分析的记录集以及结果数据集的地理坐标系必须一致。</p>
 @param  recordset 被更新叠加分析的记录集，必须是面类型。
 @param  updateRecordset 用于更新叠加分析的记录集，必须是面类型。
 @param  resultDataset 存放分析结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
 @return  分析成功返回值为true,失败返回值为false。
 */
+(BOOL)update:(Recordset *)recordset updateRecordset:(Recordset *)updateRecordset resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

/**@brief 对面数据集用面对象数组进行更新方式的叠加分析，更新运算时用用于更新的面对象数组替换与被更新数据集的重合部分，是一个先擦除后粘贴的过程。
 <p>注意，用于更新叠加分析的面对象数组、被更新叠加分析的数据集以及结果数据集的地理坐标系必须一致。</p>
 @param  dataset 被更新叠加分析的数据集，必须是面数据集。
 @param  updateGeometries 用于更新叠加分析的面对象数组。
 @param  resultDataset 存放分析结果的数据集。
 @param  parameter 叠加分析的参数对象，该对象用于设置分析时的保留字段等分析参数。
 @return  分析成功返回值为true,失败返回值为false。
 */
+(BOOL)update:(DatasetVector *)dataset updateGeometries:(NSMutableArray *)updateGeometries resultDataset:(DatasetVector *)resultDataset parameter:(OverlayAnalystParameter *)parameter;

@end
