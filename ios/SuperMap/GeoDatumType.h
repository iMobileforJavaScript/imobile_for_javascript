//
//  GeoDatumType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//


/// 枚举定义了大地参照系类型常量。 
typedef enum {
	///用户自定义大地参照系
	DATUM_USER_DEFINED           = -1,         
	///Airy 1830
    //{{
    DATUM_AIRY_1830             = 6001 ,       
	/// Airy modified   
    DATUM_AIRY_MOD              = 6002 ,        
	/// Australian National 
    DATUM_AUSTRALIAN            = 6003 ,      
	///  Bessel 1841
    DATUM_BESSEL_1841           = 6004 ,     
	/// Bessel modified 
    DATUM_BESSEL_MOD            = 6005 ,       
	/// Bessel Namibia
    DATUM_BESSEL_NAMIBIA        = 6006 ,      
	/// Clarke 1858 
    DATUM_CLARKE_1858           = 6007 ,      
	/// Clarke 1866 
    DATUM_CLARKE_1866           = 6008 ,       
	/// Clarke 1866 Michigan  
    DATUM_CLARKE_1866_MICH      = 6009 ,      
	/// Clarke 1880   
    DATUM_CLARKE_1880           = 6034 ,      
	/// Clarke 1880 (Arc) 
    DATUM_CLARKE_1880_ARC       = 6013 ,       
	///  Clarke 1880 (Benoit) 
    DATUM_CLARKE_1880_BENOIT    = 6010 ,       
	/// Clarke 1880 (IGN)  
    DATUM_CLARKE_1880_IGN       = 6011 ,       
	/// Clarke 1880 (RGS)  
    DATUM_CLARKE_1880_RGS       = 6012 ,      
	/// Clarke 1880 (SGA) 
    DATUM_CLARKE_1880_SGA       = 6014 ,      
	/// Everest 1830 
    DATUM_EVEREST_1830          = 6015 ,       
	/// Everest (definition 1967) 
    DATUM_EVEREST_DEF_1967      = 6016 ,       
	/// Everest (definition 1975) 
    DATUM_EVEREST_DEF_1975      = 6017 ,      
	/// Everest modified 
    DATUM_EVEREST_MOD           = 6018 ,      
	/// GEM gravity potential model  
    DATUM_GEM_10C               = 6031 ,      
	///  GRS 1967 
    DATUM_GRS_1967              = 6036 ,      
	/// GRS 1980  
    DATUM_GRS_1980              = 6019 ,      
	/// Helmert 1906 
    DATUM_HELMERT_1906          = 6020 ,       
	/// Indonesian National 
    DATUM_INDONESIAN            = 6021 ,      
	/// International 1927 
    DATUM_INTERNATIONAL_1924    = 6022 ,       
	/// International 1967
    DATUM_INTERNATIONAL_1967    = 6023 ,      
	///  Krasovsky 1940
    DATUM_KRASOVSKY_1940        = 6024 ,      
	/// Transit precise ephemeris
    DATUM_NWL_9D                = 6025 ,      
	/// OSU 1986 geoidal model  
    DATUM_OSU_86F               = 6032 ,     
	///  OSU 1991 geoidal model 
    DATUM_OSU_91A               = 6033 ,      
	/// Plessis 1817  
    DATUM_PLESSIS_1817          = 6027 ,      
	/// Authalic sphere 
    DATUM_SPHERE                = 6035 ,       
	/// Struve 1860 
    DATUM_STRUVE_1860           = 6028 ,       
	///  War Office      
    DATUM_WAR_OFFICE            = 6029 ,      
	/// WGS 1966  
    DATUM_WGS_1966              =(  6001+33000) ,      
	/// Fischer 1960 
    DATUM_FISCHER_1960          =(  6002+33000) ,      
	/// Fischer 1968 
    DATUM_FISCHER_1968          =(  6003+33000) ,     
	/// Fischer modified  
    DATUM_FISCHER_MOD           =(  6004+33000) ,      
	/// Hough 1960   
    DATUM_HOUGH_1960            =(  6005+33000) ,       
	/// Everest modified 1969 
    DATUM_EVEREST_MOD_1969      =(  6006+33000) ,      
	/// Walbeck   
    DATUM_WALBECK               =(  6007+33000) ,      
	/// Authalic sphere (ARC/INFO)  
    DATUM_SPHERE_AI             =(  6008+33000) ,      
    //}}
     /*----------------------------------------------------------------------------*/
     /*                     H O R I Z O N T A L   D A T U M S                      */
    /*----------------------------------------------------------------------------*/
    //{{  
	/// Adindan
    DATUM_ADINDAN               = 6201 ,      
	/// Afgooye    
    DATUM_AFGOOYE               = 6205 ,       
	///  Agadez  
    DATUM_AGADEZ                = 6206 ,       
	/// Australian Geodetic Datum 1966
    DATUM_AGD_1966              = 6202 ,      
	/// Australian Geodetic Datum 1984
    DATUM_AGD_1984              = 6203 ,      
	/// Ain el Abd 1970  
    DATUM_AIN_EL_ABD_1970       = 6204 ,      
	/// Amersfoort    
    DATUM_AMERSFOORT            = 6289 ,       
	/// Aratu  
    DATUM_ARATU                 = 6208 ,       
	/// Arc 1950
    DATUM_ARC_1950              = 6209 ,       
	/// Arc 1960 
    DATUM_ARC_1960              = 6210 ,       
	///  Ancienne Triangulation Francaise  
    DATUM_ATF                   = 6901 ,      
	/// Average Terrestrial System 1977
    DATUM_ATS_1977              = 6122 ,      
	/// Barbados  
    DATUM_BARBADOS              = 6212 ,      
	/// Batavia   
    DATUM_BATAVIA               = 6211 ,       
	/// Beduaram 
    DATUM_BEDUARAM              = 6213 ,      
	/// Beijing 1954    
    DATUM_BEIJING_1954          = 6214 ,       
	/// Reseau National Belge 1950 
    DATUM_BELGE_1950            = 6215 ,       
	///  Reseau National Belge 1972   
    DATUM_BELGE_1972            = 6313 ,      
	/// Bermuda 1957   
    DATUM_BERMUDA_1957          = 6216 ,      
	///  Bern 1898
    DATUM_BERN_1898             = 6217 ,      
	/// Bern 1938 
    DATUM_BERN_1938             = 6306 ,       
	///  Bogota   
    DATUM_BOGOTA                = 6218 ,       
	/// Bukit Rimpah 
    DATUM_BUKIT_RIMPAH          = 6219 ,      
	/// Camacupa 
    DATUM_CAMACUPA              = 6220 ,     
	/// Campo Inchauspe  
    DATUM_CAMPO_INCHAUSPE       = 6221 ,      
	/// Cape 
    DATUM_CAPE                  = 6222 ,     
	/// Carthage
    DATUM_CARTHAGE              = 6223 ,      
	/// Chua  
    DATUM_CHUA                  = 6224 ,      
	///  Conakry 1905 
    DATUM_CONAKRY_1905          = 6315 ,
    /// Corrego Alegre
    DATUM_CORREGO_ALEGRE        = 6225 ,       
	/// Cote d'Ivoire 
    DATUM_COTE_D_IVOIRE         = 6226 ,      
	/// Datum 73        
    DATUM_DATUM_73              = 6274 ,       
	/// Deir ez Zor 
    DATUM_DEIR_EZ_ZOR           = 6227 ,      
	/// Dealul Piscului 1933	
    DATUM_DEALUL_PISCULUI_1933  = 6316 ,       
	/// Dealul Piscului 1970
    DATUM_DEALUL_PISCULUI_1970  = 6317 ,      
	/// Deutsche Hauptdreiecksnetz
    DATUM_DHDN                  = 6314 ,      
	///  Douala
    DATUM_DOUALA                = 6228 ,      
	///  European Datum 1950
    DATUM_ED_1950               = 6230 ,      
	/// European Datum 1987 
    DATUM_ED_1987               = 6231 ,       
	/// Egypt 1907
    DATUM_EGYPT_1907            = 6229 ,      
	/// European Terrestrial Ref. Sys. 1989  
    DATUM_ETRS_1989             = 6258 ,       
	/// Fahud  
    DATUM_FAHUD                 = 6232 ,       
	/// Gandajika 1970
    DATUM_GANDAJIKA_1970        = 6233 ,      
	/// Garoua    
    DATUM_GAROUA                = 6234 ,      
	/// Geocentric Datum of Australia 1994
    DATUM_GDA_1994              = 6283 ,       
	/// Greek Geodetic Reference System 1987
    DATUM_GGRS_1987             = 6121 ,      
	/// Greek  
    DATUM_GREEK                 = 6120 ,       
	/// Guyane Francaise  
    DATUM_GUYANE_FRANCAISE      = 6235 ,       
	///  Herat North     
    DATUM_HERAT_NORTH           = 6255 ,      
	/// Hito XVIII 1963
    DATUM_HITO_XVIII_1963       = 6254 ,      
	/// Hu Tzu Shan 
    DATUM_HU_TZU_SHAN           = 6236 ,      
	/// Hungarian Datum 1972 
    DATUM_HUNGARIAN_1972        = 6237 ,      
	/// Indian 1954 
    DATUM_INDIAN_1954           = 6239 ,     
	/// Indian 1975    
    DATUM_INDIAN_1975           = 6240 ,       
	/// Indonesian Datum 1974 
    DATUM_INDONESIAN_1974       = 6238 ,      
	/// Jamaica 1875  
    DATUM_JAMAICA_1875          = 6241 ,       
	/// Jamaica 1969
    DATUM_JAMAICA_1969          = 6242 ,       
	/// Kalianpur   
    DATUM_KALIANPUR             = 6243 ,       
	///  Kandawala   
    DATUM_KANDAWALA             = 6244 ,      
	/// Kertau   
    DATUM_KERTAU                = 6245 ,       
	///  Kartastokoordinaattijarjestelma  
    DATUM_KKJ                   = 6123 ,      
	/// Kuwait Oil Company
    DATUM_KOC                   = 6246 ,       
	/// Kuwait Utility    
    DATUM_KUDAMS                = 6319 ,       
	/// La Canoa 
    DATUM_LA_CANOA              = 6247 ,       
	///  Lake  
    DATUM_LAKE                  = 6249 ,       
	/// Leigon   
    DATUM_LEIGON                = 6250 ,      
	/// Liberia 1964
    DATUM_LIBERIA_1964          = 6251 ,       
	/// Lisbon 
    DATUM_LISBON                = 6207 ,      
	/// Loma Quintana 
    DATUM_LOMA_QUINTANA         = 6288 ,      
	/// Lome
    DATUM_LOME                  = 6252 ,      
	/// Luzon 1911
    DATUM_LUZON_1911            = 6253 ,     
	/// Mahe 1971 
    DATUM_MAHE_1971             = 6256 ,       
	/// Makassar
    DATUM_MAKASSAR              = 6257 ,       
	/// Malongo 1987
    DATUM_MALONGO_1987          = 6259 ,       
	/// Manoca
    DATUM_MANOCA                = 6260 ,      
	/// Massawa
    DATUM_MASSAWA               = 6262 ,      
	/// Merchich
    DATUM_MERCHICH              = 6261 ,     
	/// Militar-Geographische Institut 
    DATUM_MGI                   = 6312 ,     
	/// Mhast 
    DATUM_MHAST                 = 6264 ,     
	/// Minna 
    DATUM_MINNA                 = 6263 ,       
	/// Monte Mario 
    DATUM_MONTE_MARIO           = 6265 ,       
	/// M'poraloko
    DATUM_MPORALOKO             = 6266 ,      
	/// NAD Michigan
    DATUM_NAD_MICH              = 6268 ,       
	/// North American Datum 1927 
    DATUM_NAD_1927              = 6267 ,      
	/// North American Datum 1983
    DATUM_NAD_1983              = 6269 ,       
	///  Nahrwan 1967
    DATUM_NAHRWAN_1967          = 6270 ,      
	/// Naparima 1972 
    DATUM_NAPARIMA_1972         = 6271 ,      
	///  Nord de Guerre
    DATUM_NDG                   = 6902 ,       
	/// National Geodetic Network (Kuwait)
    DATUM_NGN                   = 6318 ,      
	/// NGO 1948
    DATUM_NGO_1948              = 6273 ,       
	/// Nord Sahara 1959 
    DATUM_NORD_SAHARA_1959      = 6307 ,     
	/// NSWC 9Z-2 
    DATUM_NSWC_9Z_2             = 6276 ,     
	/// Nouvelle Triangulation Francaise
    DATUM_NTF                   = 6275 ,     
	/// New Zealand Geodetic Datum 1949
    DATUM_NZGD_1949             = 6272 ,       
	/// OS (SN) 1980
    DATUM_OS_SN_1980            = 6279 ,      
	/// OSGB 1936   
    DATUM_OSGB_1936             = 6277 ,      
	/// OSGB 1970 (SN)   
    DATUM_OSGB_1970_SN          = 6278 ,       
	/// Padang 1884
    DATUM_PADANG_1884           = 6280 ,       
	/// Palestine 1923 
    DATUM_PALESTINE_1923        = 6281 ,       
	///  Pointe Noire  
    DATUM_POINTE_NOIRE          = 6282 ,      
	/// Provisional South Amer. Datum 1956
    DATUM_PSAD_1956             = 6248 ,      
	///  Pulkovo 1942 
    DATUM_PULKOVO_1942          = 6284 ,       
	/// Pulkovo 1995 
    DATUM_PULKOVO_1995          = 6200 ,       
	/// Qatar    
    DATUM_QATAR                 = 6285 ,       
	/// Qatar 1948
    DATUM_QATAR_1948            = 6286 ,       
	/// Qornoq
    DATUM_QORNOQ                = 6287 ,      
	///South American Datum 1969 
    DATUM_SAD_1969              = 6291 ,      
	/// Sapper Hill 1943
    DATUM_SAPPER_HILL_1943      = 6292 ,       
	/// Schwarzeck
    DATUM_SCHWARZECK            = 6293 ,      
	/// Segora
    DATUM_SEGORA                = 6294 ,      
	/// Serindung
    DATUM_SERINDUNG             = 6295 ,       
	/// Stockholm 1938 
    DATUM_STOCKHOLM_1938        = 6308 ,      
	/// Sudan 
    DATUM_SUDAN                 = 6296 ,     
	/// Tananarive 1925  
    DATUM_TANANARIVE_1925       = 6297 ,      
	/// Timbalai 1948 
    DATUM_TIMBALAI_1948         = 6298 ,      
	/// TM65                                 
    DATUM_TM65                  = 6299 ,       
	/// TM75 
    DATUM_TM75                  = 6300 ,       
	/// Tokyo
    DATUM_TOKYO                 = 6301 ,      
	/// Trinidad 1903
    DATUM_TRINIDAD_1903         = 6302 ,       
	/// Trucial Coast 1948
    DATUM_TRUCIAL_COAST_1948    = 6303 ,      
	/// Voirol 1875 
    DATUM_VOIROL_1875           = 6304 ,      
	/// Voirol Unifie 1960   
    DATUM_VOIROL_UNIFIE_1960    = 6305 ,      
	/// WGS 1972 
    DATUM_WGS_1972              = 6322 ,      
	/// WGS 1972 Transit Broadcast Ephemeris
    DATUM_WGS_1972_BE           = 6324 ,     
	/// WGS 1984  
    DATUM_WGS_1984              = 6326 ,      
	/// Yacare
    DATUM_YACARE                = 6309 ,     
	/// Yoff 
    DATUM_YOFF                  = 6310 ,      
	/// Zanderij 
    DATUM_ZANDERIJ              = 6311 ,      
	/// European 1979 
    DATUM_EUROPEAN_1979         =(  6201+33000) ,      
	/// Everest - Bangladesh
    DATUM_EVEREST_BANGLADESH    =(  6202+33000) ,      
	/// Everest - India and Nepal  
    DATUM_EVEREST_INDIA_NEPAL   =(  6203+33000) ,      
	/// Hjorsey 1955 
    DATUM_HJORSEY_1955          =(  6204+33000) ,      
	/// Hong Kong 1963
    DATUM_HONG_KONG_1963        =(  6205+33000) ,     
	///  Oman   
    DATUM_OMAN                  =(  6206+33000) ,       
	/// South Asia Singapore
    DATUM_S_ASIA_SINGAPORE      =(  6207+33000) ,       
	/// Ayabelle Lighthouse
    DATUM_AYABELLE              =(  6208+33000) ,       
	///  Bissau  
    DATUM_BISSAU                =(  6209+33000) ,       
	/// Dabola  
    DATUM_DABOLA                =(  6210+33000) ,      
	/// Point 58 
    DATUM_POINT58               =(  6211+33000) ,      
	/// Astro Beacon E 1945 
    DATUM_BEACON_E_1945         =(  6212+33000) ,      
	/// Tern Island Astro 1961  
    DATUM_TERN_ISLAND_1961      =(  6213+33000) ,      
	/// Astronomical Station 1952
    DATUM_ASTRO_1952            =(  6214+33000) ,       
	/// Bellevue IGN
    DATUM_BELLEVUE              =(  6215+33000) ,      
	/// Canton Astro 1966
    DATUM_CANTON_1966           =(  6216+33000) ,       
	/// Chatham Island Astro 1971
    DATUM_CHATHAM_ISLAND_1971   =(  6217+33000) ,       
	///  DOS 1968 
    DATUM_DOS_1968              =(  6218+33000) ,      
	/// Easter Island 1967 
    DATUM_EASTER_ISLAND_1967    =(  6219+33000) ,      
	/// Guam 1963
    DATUM_GUAM_1963             =(  6220+33000) ,      
	/// GUX 1 Astro
    DATUM_GUX_1                 =(  6221+33000) ,      
	/// Johnston Island 1961
    DATUM_JOHNSTON_ISLAND_1961  =(  6222+33000) ,      
	/// Kusaie Astro 1951
    DATUM_KUSAIE_1951           =(  6259+33000) ,      
	/// Midway Astro 1961 
    DATUM_MIDWAY_1961           =(  6224+33000) ,     
	/// Old Hawaiian
    DATUM_OLD_HAWAIIAN          =(  6225+33000) ,      
	/// Pitcairn Astro 1967
    DATUM_PITCAIRN_1967         =(  6226+33000) ,      
	/// Santo DOS 1965    
    DATUM_SANTO_DOS_1965        =(  6227+33000) ,       
	/// Viti Levu 1916
    DATUM_VITI_LEVU_1916        =(  6228+33000) ,      
	/// Wake-Eniwetok 1960 
    DATUM_WAKE_ENIWETOK_1960    =(  6229+33000) ,      
	/// Wake Island Astro 1952
    DATUM_WAKE_ISLAND_1952      =(  6230+33000) ,      
	/// Anna 1 Astro 1965     
    DATUM_ANNA_1_1965           =(  6231+33000) ,       
	/// Gan 1970
    DATUM_GAN_1970              =(  6232+33000) ,       
	///  ISTS 073 Astro 1969
    DATUM_ISTS_073_1969         =(  6233+33000) ,       
	/// Kerguelen Island 1949 
    DATUM_KERGUELEN_ISLAND_1949 =(  6234+33000) ,      
	/// Reunion  
    DATUM_REUNION               =(  6235+33000) ,     
	/// Antigua Island Astro 1943
    DATUM_ANTIGUA_ISLAND_1943   =(  6236+33000) ,      
	/// Ascension Island 1958
    DATUM_ASCENSION_ISLAND_1958 =(  6237+33000) ,      
	/// Astro DOS 71/4  
    DATUM_DOS_71_4              =(  6238+33000) ,      
	/// Cape Canaveral 
    DATUM_CACANAVERAL           =(  6239+33000) ,      
	///  Fort Thomas 1955  
    DATUM_FORT_THOMAS_1955		 =(  6240+33000) ,      
	/// Graciosa Base SW 1948 
    DATUM_GRACIOSA_1948		 =(  6241+33000) ,      
	/// ISTS 061 Astro 1968
    DATUM_ISTS_061_1968		 =(  6242+33000) ,      
	/// L.C. 5 Astro 1961  
    DATUM_LC5_1961				 =(  6243+33000) ,       
	/// Montserrat Isl Astro 1958  
    DATUM_MONTSERRAT_ISLAND_1958=(  6244+33000) ,      
	/// Observ. Meteorologico 1939 
    DATUM_OBSERV_METEOR_1939	 =(  6245+33000) ,       
	/// Pico de Las Nieves
    DATUM_PICO_DE_LAS_NIEVES	 =(  6246+33000) ,      
	/// Porto Santo 1936
    DATUM_PORTO_SANTO_1936      =(  6247+33000) ,      
	/// Puerto Rico
    DATUM_PUERTO_RICO           =(  6248+33000) ,      
	/// Sao Braz
    DATUM_SAO_BRAZ              =(  6249+33000) ,       
	/// Selvagem Grande 1938 
    DATUM_SELVAGEM_GRANDE_1938  =(  6250+33000) ,      
	/// Tristan Astro 1968
    DATUM_TRISTAN_1968          =(  6251+33000) ,       
	/// American Samoa 1962 
    DATUM_SAMOA_1962            =(  6252+33000) ,       
	///  Camp Area Astro
    DATUM_CAMP_AREA             =(  6253+33000) ,       
	/// Deception Island 
    DATUM_DECEPTION_ISLAND		=(  6254+33000) ,      
	/// Gunung Segara
    DATUM_GUNUNG_SEGARA         =(  6255+33000) ,      
	/// Indian 1960 
    DATUM_INDIAN_1960           =(  6256+33000) ,       
	/// S-42 Hungary  
    DATUM_S42_HUNGARY           =(  6257+33000) ,     
	/// S-JTSK
    DATUM_S_JTSK                =(  6258+33000) ,      
	/// Alaskan Islands 
    DATUM_ALASKAN_ISLANDS       =(  6260+33000) ,      
	/// Japan 2000 = ITRF 
    DATUM_JAPAN_2000            =(  6301+33000) ,			
	///  Xian 1980
    DATUM_XIAN_1980             =(  6312+33000) ,        
	
    //{{added by qianjn in 2008-12-30 10:33:39 ‘ˆº”‘≠“Ú£∫
    /// China 2000
    DATUM_CHINA_2000	         =(  6313+33000),		
	
    /// Azores Occidental Islands 1939
    DATUM_AZORES_OCCIDENTAL_ISLANDS_1939			= 6182,		
	/// Azores Central Islands 1948
    DATUM_AZORES_CENTRAL_ISLANDS_1948				= 6183,		 
	/// Azores Oriental Islands 1940
    DATUM_AZORES_ORIENTAL_ISLANDS_1940				= 6184,		 
	/// Madeira 1936
    DATUM_MADEIRA_1936								= 6185,		
	/// ITRF 1993
    DATUM_ITRF_1993								= 6652,		 
	/// Lisbon 1890 (Lisbon) 
    DATUM_LISBON_1890								= 6904		
    
  
}GeoDatumType;