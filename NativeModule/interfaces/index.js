import { SMap, SScene ,SMapSuspension} from './mapping'
import { SAnalyst, SFacilityAnalyst, STransportationAnalyst } from './analyst'
import { SCollector, SMediaCollector } from './collector'
import SCartography from './SCartography'
import SThemeCartography from './SThemeCartography'
import { SOnlineService, SIPortalService } from './iServer'
import SMessageService from './SMessageService'
import SAIDetectView from './SAIDetectView'
import SMeasureView from './SMeasureView'
import SAIClassifyView from './SAIClassifyView'
import SCollectSceneFormView from './SCollectSceneFormView'
import SIllegallyParkView from './SIllegallyParkView'
import SCastModelOperateView from './SCastModelOperateView'
import { SSpeechRecognizer } from './speech'

export {
  SMap,
  SMapSuspension,

  /*分析模块功能*/
  SAnalyst,
  SFacilityAnalyst,
  STransportationAnalyst,

  SCollector,
  SMediaCollector,
  SScene,
  SCartography,
  SThemeCartography,
  SSpeechRecognizer,
  /*在线模块功能*/
  SOnlineService,
  SIPortalService,
  SMessageService,
  /*AI识别*/
  SAIDetectView,
  /*AI户型图采集*/
  SMeasureView,
  /*AI分类*/
  SAIClassifyView,
  /*AI高精度采集*/
  SCollectSceneFormView,
  /*违章采集*/
  SIllegallyParkView,
  /*AR投放*/
  SCastModelOperateView,
}