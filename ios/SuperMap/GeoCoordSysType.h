//
//  GeoCoordSysType.h
//  Visualization
//
//  版权所有 （c）2013 北京超图软件股份有限公司。保留所有权利。
//


/// 该类定义了地理坐标系类型常量。
typedef enum {

    /// 用户自定义的地理坐标系
	GCST_USER_DEFINE               = -1,
    
    /// Airy 1830
    GCST_AIRY_1830                = 4001 ,   
	
    /// Airy modified
    GCST_AIRY_MOD                 = 4002 ,

    /// Australian National
    GCST_AUSTRALIAN               = 4003 ,  
	
    /// Bessel 1841

    GCST_BESSEL_1841              = 4004 ,   
	
    /// Bessel modified

    GCST_BESSEL_MOD               = 4005 ,

     ///Bessel Namibia
    GCST_BESSEL_NAMIBIA           = 4006 ,

    ///Clarke 1858
    GCST_CLARKE_1858              = 4007 ,

    ///Clarke 1866
    GCST_CLARKE_1866              = 4008 ,

	///Clarke 1866 Michigan
    GCST_CLARKE_1866_MICH         = 4009 ,

	///Clarke 1880 (Benoit)
    GCST_CLARKE_1880_BENOIT       = 4010 ,

	///Clarke 1880 (IGN)
    GCST_CLARKE_1880_IGN          = 4011 ,

   ///Clarke 1880 (RGS)
    GCST_CLARKE_1880_RGS          = 4012 ,
    
	///Clarke 1880 (Arc)
    GCST_CLARKE_1880_ARC          = 4013 ,
	
	///Clarke 1880 (SGA)
    GCST_CLARKE_1880_SGA          = 4014 ,
	
	///Everest 1830
    GCST_EVEREST_1830             = 4015 ,
    
	///Everest (definition 1967)
    GCST_EVEREST_DEF_1967         = 4016 ,
    
	///Everest (definition 1975)
    GCST_EVEREST_DEF_1975         = 4017 ,
    
	///Everest modified
    GCST_EVEREST_MOD              = 4018 ,
    
    ///GRS 1980
    GCST_GRS_1980                 = 4019 ,
	
    ///Helmert 1906
    GCST_HELMERT_1906             = 4020 ,
	///Indonesian National
    GCST_INDONESIAN               = 4021 ,   
	///International 1927
    GCST_INTERNATIONAL_1924       = 4022 ,   
	///International 1967
    GCST_INTERNATIONAL_1967       = 4023 ,    
	///Krasovsky 1940
    GCST_KRASOVSKY_1940           = 4024 ,    
	///Transit precise ephemeris
    GCST_NWL_9D                   = 4025 ,    
	///Plessis 1817
    GCST_PLESSIS_1817             = 4027 ,    
	///Struve 1860
    GCST_STRUVE_1860              = 4028 ,   
	///War Office
    GCST_WAR_OFFICE               = 4029 ,   
	
    ///GEM gravity potential model
    GCST_GEM_10C                  = 4031 ,   
	///OSU 1986 geoidal model
    GCST_OSU_86F                  = 4032 ,    
	///OSU 1991 geoidal model
    GCST_OSU_91A                  = 4033 ,    
	///Clarke 1880
    GCST_CLARKE_1880              = 4034 ,   
	///Authalic sphere
    GCST_SPHERE                   = 4035 ,    
	///GRS 1967
    GCST_GRS_1967                 = 4036 ,   
    ///WGS 1966
    GCST_WGS_1966                 = (4001+33000) ,    
	///Fischer 1960
    GCST_FISCHER_1960             = (4002+33000) ,   
	///Fischer 1968
    GCST_FISCHER_1968             = (4003+33000) ,    
	///Fischer modified
    GCST_FISCHER_MOD              = (4004+33000) ,    
	///Hough 1960
    GCST_HOUGH_1960               = (4005+33000) ,    
	///Everest modified 1969
    GCST_EVEREST_MOD_1969         = (4006+33000) ,   
	///Walbeck
    GCST_WALBECK                  = (4007+33000) ,    
	///Authalic sphere (ARC/INFO)
    GCST_SPHERE_AI                = (4008+33000) ,    
    ///Greek
    GCST_GREEK                    = 4120 ,     
	///Greek Geodetic Ref. System 1987
    GCST_GGRS_1987                = 4121 ,     
	///Average Terrestrial System 1977
    GCST_ATS_1977                 = 4122 ,     
	///Kartastokoordinaattijarjestelma
    GCST_KKJ                      = 4123 ,   
        //}}
    /*----------------------------------------------------------------------------*/
    /*         G E O G R A P H I C   C O O R D I N A T E   S Y S T E M S          */
    /*----------------------------------------------------------------------------*/
        //{{
	///Pulkovo 1995
	GCST_PULKOVO_1995             = 4200 ,     
	///Adindan
    GCST_ADINDAN                  = 4201 ,    
	///Australian Geodetic Datum 1966
    GCST_AGD_1966                 = 4202 ,   
	///Australian Geodetic Datum 1984
    GCST_AGD_1984                 = 4203 ,   
	///Ain el Abd 1970
    GCST_AIN_EL_ABD_1970          = 4204 ,  
	///Afgooye
    GCST_AFGOOYE                  = 4205 ,    
	///Agadez
    GCST_AGADEZ                   = 4206 ,    
	///Lisbon
    GCST_LISBON                   = 4207 ,    
	///Aratu
    GCST_ARATU                    = 4208 ,   
	///Arc 1950
    GCST_ARC_1950                 = 4209 ,    
	///Arc 1960
    GCST_ARC_1960                 = 4210 ,    
	///Batavia
    GCST_BATAVIA                  = 4211 ,   
	///Barbados
    GCST_BARBADOS                 = 4212 ,   
	///Beduaram
    GCST_BEDUARAM                 = 4213 ,   
	///Beijing 1954
    GCST_BEIJING_1954             = 4214 ,    
	///Reseau National Belge 1950
    GCST_BELGE_1950               = 4215 ,    
	///Bermuda 1957
    GCST_BERMUDA_1957             = 4216 ,    
	///Bern 1898
    GCST_BERN_1898                = 4217 ,    
	///Bogota
    GCST_BOGOTA                   = 4218 ,    
	///Bukit Rimpah
    GCST_BUKIT_RIMPAH             = 4219 ,   
	///Camacupa
    GCST_CAMACUPA                 = 4220 ,   
	///Campo Inchauspe
    GCST_CAMPO_INCHAUSPE          = 4221 ,   
	///Cape
    GCST_CAPE                     = 4222 ,    
	///Carthage
    GCST_CARTHAGE                 = 4223 ,    
	///Chua
    GCST_CHUA                     = 4224 ,   
	///Corrego Alegre
    GCST_CORREGO_ALEGRE           = 4225 ,    
	///Cote d'Ivoire
    GCST_COTE_D_IVOIRE            = 4226 ,   
	///Deir ez Zor
    GCST_DEIR_EZ_ZOR              = 4227 ,    
	///Douala
    GCST_DOUALA                   = 4228 ,    
	///Egypt 1907
    GCST_EGYPT_1907               = 4229 ,    
	///European Datum 1950
    GCST_ED_1950                  = 4230 ,   
	///European Datum 1987
    GCST_ED_1987                  = 4231 ,   
	///Fahud
    GCST_FAHUD                    = 4232 ,    
	///Gandajika 1970
    GCST_GANDAJIKA_1970           = 4233 ,   
	///Garoua
    GCST_GAROUA                   = 4234 ,    
	///Guyane Francaise
    GCST_GUYANE_FRANCAISE         = 4235 ,    
	/// Hu Tzu Shan
    GCST_HU_TZU_SHAN              = 4236 ,   
	///  Hungarian Datum 1972  
    GCST_HUNGARIAN_1972           = 4237 ,   
	/// Indonesian Datum 1974 
    GCST_INDONESIAN_1974          = 4238 ,    
	///  Indian 1954
    GCST_INDIAN_1954              = 4239 ,    
	/// Indian 1975 
    GCST_INDIAN_1975              = 4240 ,    
	/// Jamaica 1875   
    GCST_JAMAICA_1875             = 4241 ,   
	/// Jamaica 1969 
    GCST_JAMAICA_1969             = 4242 ,    
	/// Kalianpur 
    GCST_KALIANPUR                = 4243 ,    
	/// Kandawala
    GCST_KANDAWALA                = 4244 ,    
	/// Kertau 
    GCST_KERTAU                   = 4245 ,   
	/// Kuwait Oil Company
    GCST_KOC_                     = 4246 ,  
	/// La Canoa 
    GCST_LA_CANOA                 = 4247 ,   
	/// Provisional South Amer. Datum 1956
    GCST_PSAD_1956                = 4248 ,   
	/// Lake  
    GCST_LAKE                     = 4249 ,    
	/// Leigon
    GCST_LEIGON                   = 4250 ,    
	/// Liberia 1964 
    GCST_LIBERIA_1964             = 4251 ,   
	/// Lome 
    GCST_LOME                     = 4252 ,   
	///Luzon 1911
    GCST_LUZON_1911               = 4253 ,    
	/// Hito XVIII 1963
    GCST_HITO_XVIII_1963          = 4254 ,    
	/// Mahe 1971
    GCST_MAHE_1971                = 4256 ,   
	/// Makassar
    GCST_MAKASSAR                 = 4257 ,   
	/// European Terrestrial Ref. Sys. 1989
    GCST_ETRS_1989                = 4258 ,   
	/// Malongo 1987
    GCST_MALONGO_1987             = 4259 ,    
	/// Manoca 
    GCST_MANOCA                   = 4260 ,    
	/// Merchich
    GCST_MERCHICH                 = 4261 ,   
	/// Massawa
    GCST_MASSAWA                  = 4262 ,   
	/// Minna   
    GCST_MINNA                    = 4263 ,   
	/// Mhast  
    GCST_MHAST                    = 4264 ,   
	/// Monte Mario
    GCST_MONTE_MARIO              = 4265 ,    
	/// M'poraloko
    GCST_MPORALOKO                = 4266 ,   
	///  North American Datum 1927
    GCST_NAD_1927                 = 4267 ,    
	///  NAD Michigan 
    GCST_NAD_MICH                 = 4268 ,    
	///  North American Datum 1983
    GCST_NAD_1983                 = 4269 ,    
	/// Nahrwan 1967
    GCST_NAHRWAN_1967             = 4270 ,   
	/// Naparima 1972  
    GCST_NAPARIMA_1972            = 4271 ,    
	/// New Zealand Geodetic Datum 1949
    GCST_NZGD_1949                = 4272 ,    
	///  NGO 1948
    GCST_NGO_1948_                = 4273 ,   
	/// Datum 73  
    GCST_DATUM_73                 = 4274 ,   
	///Nouvelle Triangulation Francaise 
    GCST_NTF_                     = 4275 ,    
	/// NSWC 9Z-2
    GCST_NSWC_9Z_2_               = 4276 ,   
	/// OSGB 1936  
    GCST_OSGB_1936                = 4277 ,   
	/// OSGB 1970 (SN)  
    GCST_OSGB_1970_SN             = 4278 ,    
	/// OS (SN) 1980
    GCST_OS_SN_1980               = 4279 ,    
	/// Padang 1884  
    GCST_PADANG_1884              = 4280 ,    
	/// Palestine 1923 
    GCST_PALESTINE_1923           = 4281 ,    
	/// Pointe Noire 
    GCST_POINTE_NOIRE             = 4282 ,    
	/// Geocentric Datum of Australia 1994
    GCST_GDA_1994                 = 4283 ,   
	/// Pulkovo 1942
    GCST_PULKOVO_1942             = 4284 ,    
	/// Qatar 
    GCST_QATAR                    = 4285 ,    
	/// Qatar 1948
    GCST_QATAR_1948               = 4286 ,   
	/// Qornoq  
    GCST_QORNOQ                   = 4287 ,    
	///  Loma Quintana  
    GCST_LOMA_QUINTANA            = 4288 ,    
	/// Amersfoort
    GCST_AMERSFOORT               = 4289 ,   
    /// South American Datum 1969 
    GCST_SAD_1969                 = 4291 ,    
	/// Sapper Hill 1943
    GCST_SAPPER_HILL_1943         = 4292 ,    
	/// Schwarzeck 
    GCST_SCHWARZECK               = 4293 ,    
	/// Segora 
    GCST_SEGORA                   = 4294 ,   
	/// Serindung
    GCST_SERINDUNG                = 4295 ,    
	/// Sudan  
    GCST_SUDAN					  = 4296 ,   
	/// Tananarive 1925
    GCST_TANANARIVE_1925          = 4297 ,   
	/// Timbalai 1948 
    GCST_TIMBALAI_1948			  = 4298 ,    
	///  TM65
    GCST_TM65                     = 4299 ,   
    ///  TM75 
    GCST_TM75 					  = 4300 ,    
	/// Tokyo
    GCST_TOKYO                    = 4301 ,    
	/// Trinidad 1903
    GCST_TRINIDAD_1903            = 4302 ,   
	/// Trucial Coast 1948
    GCST_TRUCIAL_COAST_1948       = 4303 ,    
	/// Voirol 1875 
    GCST_VOIROL_1875              = 4304 ,    
	/// Voirol Unifie 1960 
    GCST_VOIROL_UNIFIE_1960       = 4305 ,    
	/// Bern 1938
    GCST_BERN_1938                = 4306 ,   
	/// Nord Sahara 1959
    GCST_NORD_SAHARA_1959         = 4307 ,   
	///  RT38 
    GCST_RT38_                    = 4308 ,    
	/// Yacare  
    GCST_YACARE                   = 4309 ,  
	/// Yoff  
    GCST_YOFF                     = 4310 ,    
	/// Zanderij 
    GCST_ZANDERIJ                 = 4311 ,   
	/// Militar-Geographische Institut   
    GCST_MGI_                     = 4312 ,    
	///  Reseau National Belge 1972
    GCST_BELGE_1972               = 4313 ,   
	/// Deutsche Hauptdreiecksnetz
    GCST_DHDNB                    = 4314 ,    
	/// Conakry 1905
    GCST_CONAKRY_1905             = 4315 ,  
	/// Dealul Piscului 1933 (Romania) 
    GCST_DEALUL_PISCULUI_1933     = 4316 ,   
	/// Dealul Piscului 1970 (Romania) 
    GCST_DEALUL_PISCULUI_1970     = 4317 ,   
	/// National Geodetic Network (Kuwait) 
    GCST_NGN                      = 4318 ,    
	/// Kuwait Utility   
    GCST_KUDAMS                   = 4319 ,    
    /// WGS 1972
    GCST_WGS_1972                 = 4322 ,   
    ///  WGS 1972 Transit Broadcast Ephemer
    GCST_WGS_1972_BE              = 4324 ,   
    /// WGS 1984 
    GCST_WGS_1984                 = 4326 ,   
    /// Bern 1898 (Bern) 
    GCST_BERN_1898_BERN           = 4801 ,  
	/// Bogota (Bogota) 
    GCST_BOGOTA_BOGOTA            = 4802 ,   
	/// Lisbon (Lisbon) 
    GCST_LISBON_LISBON            = 4803 ,    
	/// Makassar (Jakarta)
    GCST_MAKASSAR_JAKARTA         = 4804 ,    
	/// MGI (Ferro)  
    GCST_MGI_FERRO                = 4805 ,    
	/// Monte Mario (Rome)  
    GCST_MONTE_MARIO_ROME         = 4806 ,    
	/// NTF (Paris)  
    GCST_NTF_PARIS                = 4807 ,    
	/// Padang 1884 (Jakarta)  
    GCST_PADANG_1884_JAKARTA      = 4808 ,   
	/// Belge 1950 (Brussels) 
    GCST_BELGE_1950_BRUSSELS      = 4809 ,  
	/// Tananarive 1925 (Paris)
    GCST_TANANARIVE_1925_PARIS    = 4810 ,   
	/// Voirol 1875 (Paris) 
    GCST_VOIROL_1875_PARIS        = 4811 ,    
	/// Voirol Unifie 1960 (Paris)
    GCST_VOIROL_UNIFIE_1960_PARIS = 4812 ,    
	/// Batavia (Jakarta)  
    GCST_BATAVIA_JAKARTA          = 4813 ,   
	/// RT38 (Stockholm) 
    GCST_RT38_STOCKHOLM           = 4814 ,   
	/// Greek (Athens) 
    GCST_GREEK_ATHENS             = 4815 ,   
    /// ATF (Paris) 
    GCST_ATF_PARIS                = 4901 ,  
	///  Nord de Guerre (Paris)  
    GCST_NDG_PARIS                = 4902 ,    
    ///  European 1979
    GCST_EUROPEAN_1979            = (4201+33000) ,    
	/// Everest - Bangladesh
    GCST_EVEREST_BANGLADESH       = (4202+33000) ,    
	/// Everest - India and Nepal
    GCST_EVEREST_INDIA_NEPAL      = (4203+33000) ,    
	/// Hjorsey 1955 
    GCST_HJORSEY_1955             = (4204+33000) ,    
	/// Hong Kong 1963 
    GCST_HONG_KONG_1963           = (4205+33000) ,    
	/// Oman    
    GCST_OMAN                     = (4206+33000) ,   
	/// South Asia Singapore
    GCST_S_ASIA_SINGAPORE         = (4207+33000) ,   
	/// Ayabelle Lighthouse 
    GCST_AYABELLE                 = (4208+33000) ,    
	/// Bissau
    GCST_BISSAU                   = (4209+33000) ,  
	/// Dabola
    GCST_DABOLA                   = (4210+33000) ,   
	/// Point 58
    GCST_POINT58                  = (4211+33000) ,    
	/// Astro Beacon E 1945
    GCST_BEACON_E_1945            = (4212+33000) ,    
	/// Tern Island Astro 1961
    GCST_TERN_ISLAND_1961         = (4213+33000) ,    
	/// Astronomical Station 1952
    GCST_ASTRO_1952               = (4214+33000) ,   
	/// Bellevue IGN 
    GCST_BELLEVUE                 = (4215+33000) ,   
	/// Canton Astro 1966 
    GCST_CANTON_1966              = (4216+33000) ,   
	/// Chatham Island Astro 1971 
    GCST_CHATHAM_ISLAND_1971      = (4217+33000) ,    
	/// DOS 1968 
    GCST_DOS_1968                 = (4218+33000) ,    
	/// Easter Island 1967
    GCST_EASTER_ISLAND_1967       = (4219+33000) ,   
	///  Guam 1963 
    GCST_GUAM_1963                = (4220+33000) ,    
	///  GUX 1 Astro
    GCST_GUX_1                    = (4221+33000) ,    
	/// Johnston Island 1961 
    GCST_JOHNSTON_ISLAND_1961     = (4222+33000) ,    
	/// Carthage (degrees)  
    GCST_CARTHAGE_DEGREE          = (4223+33000) ,   
    /// Midway Astro 1961
    GCST_MIDWAY_1961              = (4224+33000) ,    
	/// Old Hawaiian  
    GCST_OLD_HAWAIIAN             = (4225+33000) ,    
	///  Pitcairn Astro 1967
    GCST_PITCAIRN_1967            = (4226+33000) ,   
	/// Santo DOS 1965
    GCST_SANTO_DOS_1965           = (4227+33000) ,    
	/// Viti Levu 1916
    GCST_VITI_LEVU_1916           = (4228+33000) ,    
	/// Wake-Eniwetok 1960 
    GCST_WAKE_ENIWETOK_1960       = (4229+33000) ,    
	/// Wake Island Astro 1952
    GCST_WAKE_ISLAND_1952         = (4230+33000) ,   
	/// Anna 1 Astro 1965
    GCST_ANNA_1_1965              = (4231+33000) ,    
	/// Gan 1970
    GCST_GAN_1970                 = (4232+33000) ,    
	/// ISTS 073 Astro 1969
    GCST_ISTS_073_1969            = (4233+33000) ,    
	/// Kerguelen Island 1949
    GCST_KERGUELEN_ISLAND_1949    = (4234+33000) ,    
	///  Reunion
    GCST_REUNION			      = (4235+33000) ,    
	/// Antigua Island Astro 1943
    GCST_ANTIGUA_ISLAND_1943      = (4236+33000) ,   
	/// Ascension Island 1958
    GCST_ASCENSION_ISLAND_1958    = (4237+33000) ,   
	/// Astro DOS 71/4 
    GCST_DOS_71_4                 = (4238+33000) ,    
	/// Cape Canaveral    
    GCST_CACANAVERAL              = (4239+33000),    
	/// Fort Thomas 1955
    GCST_FORT_THOMAS_1955         = (4240+33000) ,    
	///  Graciosa Base SW 1948
    GCST_GRACIOSA_1948            = (4241+33000) ,    
	/// ISTS 061 Astro 1968
    GCST_ISTS_061_1968            = (4242+33000) ,    
	///  L.C. 5 Astro 1961
    GCST_LC5_1961                 = (4243+33000) ,   
	/// Montserrat Astro 1958
    GCST_MONTSERRAT_ISLAND_1958   = (4244+33000) ,    
	/// Observ. Meteorologico 1939
    GCST_OBSERV_METEOR_1939		  = (4245+33000) ,    
	/// Pico de Las Nieves 
    GCST_PICO_DE_LAS_NIEVES		  = (4246+33000) ,    
	///  Porto Santo 1936
    GCST_PORTO_SANTO_1936         = (4247+33000) ,    
	/// Puerto Rico 
    GCST_PUERTO_RICO              = (4248+33000) ,    
	/// Sao Braz 
    GCST_SAO_BRAZ                 = (4249+33000) ,    
	/// Selvagem Grande 1938
    GCST_SELVAGEM_GRANDE_1938     = (4250+33000) ,    
	/// Tristan Astro 1968
    GCST_TRISTAN_1968             = (4251+33000) ,    
	/// American Samoa 1962
    GCST_SAMOA_1962               = (4252+33000) ,   
	///  Camp Area Astro 
    GCST_CAMP_AREA                = (4253+33000) ,    
	/// Deception Island 
    GCST_DECEPTION_ISLAND         = (4254+33000) ,    
	/// Gunung Segara
    GCST_GUNUNG_SEGARA            = (4255+33000) ,    
	/// Indian 1960 
    GCST_INDIAN_1960              = (4256+33000) ,    
	/// S-42 Hungary 
    GCST_S42_HUNGARY              = (4257+33000) ,    
	/// S-JTSK 
    GCST_S_JTSK                   = (4258+33000) ,    
	///  Kusaie Astro 1951
    GCST_KUSAIE_1951              = (4259+33000) ,   
	/// Alaskan Islands
    GCST_ALASKAN_ISLANDS          = (4260+33000) ,    
    
	 /// 日本JGD2000坐标系            
    GCST_JAPAN_2000               = (4301+33000) ,
	///  西安80坐标系            
    GCST_XIAN_1980                = (4312+33000) ,     
        //{{added by qianjn in 2008-12-30 10:35:00 墿????＿
    
	///2000国家大地坐标系（地心坐标系），简称 CGCS2000 （China Geodetic Coordinate System 2000）           
    GCST_CHINA_2000				  = (4313+33000),
    
	/// Azores Occidental 1939
    GCST_AZORES_OCCIDENTAL_1939			= 4182,		 
	/// Azores Central 1948 
    GCST_AZORES_CENTRAL_1948			= 4183,		 
	/// Azores Oriental 1940
    GCST_AZORES_ORIENTAL_1940			= 4184,		 
	/// Madeira 1936
    GCST_MADEIRA_1936					= 4185,		 
	/// ITRF 1993
    GCST_ITRF_1993						= 4915,		
	/// Lisbon 1890 (Lisbon) 
    GCST_LISBON_1890					= 4904,		 	
    
        //}}added by qianjn in 2008-12-30 10:35:00 墿????＿
        //}}
} GeoCoordSysType;


