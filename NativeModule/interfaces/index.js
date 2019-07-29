import { SMap, SScene } from './mapping'
import { SAnalyst, SFacilityAnalyst, STransportationAnalyst } from './analyst'
import { SCollector, SMediaCollector } from './collector'
import SCartography from './SCartography'
import SThemeCartography from './SThemeCartography'
import {SOnlineService} from './iServer'
import SMessageService from './SMessageService'
import SAIDetectView from './SAIDetectView'

export {
  SMap,

  /*分析模块功能*/
  SAnalyst,
  SFacilityAnalyst,
  STransportationAnalyst,

  SCollector,
  SMediaCollector,
  SScene,
  SCartography,
  SThemeCartography,
  /*在线模块功能*/
  SOnlineService,
  SMessageService,
  /*AI识别*/
  SAIDetectView,
}