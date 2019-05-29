//
//  Workspace.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//

#import <Foundation/Foundation.h>

@class WorkspaceConnectionInfo,Datasources,Maps,Scenes,Resources;

/**    工作空间。
 *
 * <p>工作空间是用户的工作环境，主要完成数据的组织和管理，包括打开、关闭、创建、保存工作空间文件（SXW,SMW,SXWU,SMWU,DEFAULT）。工作空间（Workspace）是 SuperMap 中的一个重要的概念，工作空间存储了一个工程项目（同一个事务过程）中所有的数据源，地图的组织关系，工作空间通过其中的数据源集合对象（{@link Datasources Datasources}），地图集合对象（{@link Maps Maps}）来管理其下的数据源，地图。</p>
 * <p>工作空间中的数据源集合 <Datasources> 只存储数据源的连接信息和位置等，实际的数据源都是存储在UDB 中。工作空间中的地图集合 <Maps>  中存储的是地图的一些配置信息，如地图包含图层的个数，图层引用的数据集，地图范围，背景风格等。</p>
 * <p>在当前版本中，一个应用程序中允许多个工作空间共存，每个工作空间可以管理自己的一套数据源和地图等，但是值得注意的是不同的工作空间是不可以相互操作的。</p>
 * <p>注意：当用户使用该工作空间对象进行编程时，如果将  <Workspace> 与 <MapControl>  建立了关联，那么在进行对象的关闭时，一定需要注意关闭的顺序，如下：
 *  1. 关闭 Map 对象；
 * 2. 关闭 MapControl 对象；
 * 3. 关闭 Workspace 对象。
 */
@interface Workspace : NSObject

 /**
     * @brief 构造一个新的 Workspace 对象。
     */
-(id)init;

/**
     * @brief 获取工作空间的连接信息。
     * <p> 默认值为 {Name="",Type=SM_DEFAULT,Version=UGC60,Server="",Database="",Driver="",User="",Password=""}。
     * @return 工作空间的连接信息。
     * <P> 请参见： <WorkspaceConnectionInfo> 
     */
@property (readonly,nonatomic,strong) WorkspaceConnectionInfo* connectionInfo;

 /**
     * @brief 返回数据源集合对象。
     * <p>数据源集合对象存储工作空间下的数据源的逻辑信息，如数据源数据的连接信息，位置等，并不存储实际的数据源数据。实际的数据源数据存储在关系型数据库或 UDB 文件中。工作空间的数据源集合对象主要用来管理该工作空间中的数据源，包括打开、创建、关闭等操作。
     * <p> 默认值为一个初始化的 <Datasources>  对象。
     * @return 数据源集合对象。
     */
@property (readonly,nonatomic,strong) Datasources* datasources;

  /**
     * @brief  获取或设置工作空间显示名称，便于用户做一些标识，可以修改。
     *
     * <p> 默认值为 "UntitledWorkspace"。
     * @return 工作空间显示名称。
     */
@property (nonatomic,strong) NSString* caption;

/**
     * @brief  返回工作空间中的地图集合对象。
     * <p>  地图集合对象存储当前工作空间里保存的所有地图，但通过该对象只能访问到地图的名称。如果想打开或者对工作空间下的某个地图进行操作，需要通过     <Map>  对象从此地图集合对象中返回名称，再进行访问。注意  <Map >    对象必须先连接工作空间，才能打开地图。
    * <p>  默认值为一个初始化的  <Maps> 对象。
     * @return 工作空间中的地图集合对象。
     */
@property (nonatomic,readonly,strong) Maps* maps;

/**
 * @brief  返回工作空间中的场景集合对象。
 * <p>  场景集合对象存储当前工作空间里保存的所有场景。
 * <p>  默认值为一个空的Scenes对象。
 * @return 工作空间中的场景集合对象。
 */
@property (nonatomic,readonly,strong) Scenes *scenes;

/**
 * @brief 返回符号库对象。
 * <p>符号库对象包含工作空间下所有符号信息，内涵三个子库，即点符号库（MarkerSymbolLiberary）、线符号库（LineSymbolLiberary）和面符号库（FillSymbolLiberary）。
 * <p> 默认值为一个初始化的 <Resources>  对象。
 * @return 符号库对象。
 */
@property (nonatomic,readonly,strong) Resources *resources;

/**
     * @brief  获取或设置用户加入的对当前工作空间的描述或说明性信息。
     *
   * <p> 默认值为一个空字符串。
     * @return 用户加入的对当前工作空间的描述或说明性信息。
     */
@property (nonatomic,strong) NSString* description;

/**
     * @brief 返回工作空间的内容是否有改动，如果对工作空间的内容进行了一些修改，则返回 true，否则返回 false。
      * <p>  工作空间负责管理数据源、地图，其中任何一项内容发生变动，此属性都会返回 true，在关闭整个应用程序时，先用此属性判断工作空间是否已有改动，可用于提示用户是否需要存盘。
     *
     * <p>  默认值为 false， 即工作空间中的内容没有改动。
     * @return 如果对工作空间的内容进行了一些修改，则返回 true，否则返回 false。
     */
@property (nonatomic,assign,readonly) BOOL isModified;

 /**
     * @brief 用于打开已有的工作空间文件。成功返回 true。
     * <p>打开工作空间时，数据源集合、地图集合都会被读入到内存中。如果其中的数据源被设置为自动连接，则在打开工作空间时就会连接到这些数据源数据，但如果要对数据进行访问，还需要打开数据源下某个具体的数据集；如果数据源没有被设置为自动连接，则只能返回数据源的别名，数据源中存储的数据集信息不可知，数据源中数据也不可用。
     * <p>当打开工作空间时，如果其中有某几个数据源没有被成功打开，而 open 方法仍然返回 true，可以通过查看日志来获悉哪些数据源未被成功打开。
     * @param info 用来打开工作空间的工作空间连接信息对象。
     * @return 一个值指示工作空间是否打开，如果打开成功返回 true，否则返回 false。
     */
-(BOOL) open:(WorkspaceConnectionInfo*) info;

/**
 * 保存工作空间
 * @return 返回boolean类型，保存成功返回true，否则返回false
 * @throws Exception
 * <p>以下情况会抛出异常：
 * 1.当前工作空间对象已经释放;
 * 2.工作空间是新建的，没有指定保存路径;
 * 3.指定保存文件所在目录不存在，将自动创建目录，但创建失败;
 * 4.指定了保存文件的路径，但文件后缀名不是有效的工作空间类型，且没有指定工作空间类型;
 * </p>
 */
-(BOOL) save;

 /**
     * @brief  关闭工作空间。
    * <p>  工作空间的关闭之前确保使用的该工作空间的地图等内容关闭或断开链接。
     */
-(void) close;

 /**
     * @brief  释放该对象所占用的资源。当调用该方法之后，此对象不再可用。
     * <p>对数据集进行操作后必须调用 dispose() 方法，否则数据修改内容不能被保存。
     */
-(void) dispose;

@end
