package com.supermap.smNative;

import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.supermap.RNUtils.ColorParseUtil;
import com.supermap.data.*;
import com.supermap.interfaces.mapping.SMap;
import com.supermap.mapping.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SMThemeCartography {
    private static final String TAG = "SMThemeCartography";

    private static ArrayList<HashMap<String, Object>> listUniqueColors = new ArrayList<>();
    private static ArrayList<HashMap<String, Object>> listRangeColors = new ArrayList<>();

    private static HashMap<String, Object> createColorScheme(Color[] colors, String name) {
        HashMap<String, Object> colorsHashMap = new HashMap<>();
        colorsHashMap.put("Colors", colors);
        colorsHashMap.put("ColorScheme", name);
        return colorsHashMap;
    }

    static {
        {
            Color[] colors = new Color[]{
                    new Color(191, 217, 242),
                    new Color(128, 179, 230)};
            listUniqueColors.add(createColorScheme(colors, "BA_Blue"));
            colors = new Color[]{
                    new Color(204, 255, 204),
                    new Color(127, 229, 127)};
            listUniqueColors.add(createColorScheme(colors, "BB_Green"));
            colors = new Color[]{
                    new Color(255, 239, 204),
                    new Color(255, 222, 153)};
            listUniqueColors.add(createColorScheme(colors, "BC_Orange"));
            colors = new Color[]{
                    new Color(255, 224, 203),
                    new Color(242, 185, 145)};
            listUniqueColors.add(createColorScheme(colors, "BD_Pink"));
            colors = new Color[]{
                    new Color(255, 244, 91),
                    new Color(252, 216, 219),
                    new Color(129, 195, 231)};
            listUniqueColors.add(createColorScheme(colors, "CA_Red Rose"));
            colors = new Color[]{
                    new Color(245, 255, 166),
                    new Color(121, 232, 208),
                    new Color(255, 251, 0)};
            listUniqueColors.add(createColorScheme(colors, "CB_Blue and Yellow"));
            colors = new Color[]{
                    new Color(255, 204, 178),
                    new Color(255, 255, 204),
                    new Color(153, 204, 153)};
            listUniqueColors.add(createColorScheme(colors, "CC_Pink and Green"));
            colors = new Color[]{
                    new Color(204, 255, 204),
                    new Color(255, 255, 204),
                    new Color(204, 255, 255)};
            listUniqueColors.add(createColorScheme(colors, "CD_Fresh"));
            colors = new Color[]{
                    new Color(254, 224, 236),
                    new Color(255, 253, 228),
                    new Color(194, 229, 252),
                    new Color(166, 255, 166)};
            listUniqueColors.add(createColorScheme(colors, "DA_Ragular"));
            colors = new Color[]{
                    new Color(221, 168, 202),
                    new Color(253, 253, 176),
                    new Color(197, 228, 189),
                    new Color(245, 198, 144)};
            listUniqueColors.add(createColorScheme(colors, "DB_Common"));
            colors = new Color[]{
                    new Color(122, 203, 203),
                    new Color(245, 245, 110),
                    new Color(183, 229, 193),
                    new Color(254, 250, 177)};
            listUniqueColors.add(createColorScheme(colors, "DC_Bright"));
            colors = new Color[]{
                    new Color(237, 156, 156),
                    new Color(255, 251, 154),
                    new Color(244, 191, 122),
                    new Color(226, 201, 220)};
            listUniqueColors.add(createColorScheme(colors, "DD_Warm"));
            colors = new Color[]{
                    new Color(140, 211, 200),
                    new Color(255, 255, 180),
                    new Color(190, 186, 218),
                    new Color(252, 128, 114)};
            listUniqueColors.add(createColorScheme(colors, "DE_Set"));
            colors = new Color[]{
                    new Color(180, 226, 206),
                    new Color(253, 206, 172),
                    new Color(203, 213, 232),
                    new Color(245, 202, 228)};
            listUniqueColors.add(createColorScheme(colors, "DF_Pastel"));
            colors = new Color[]{
                    new Color(162, 205, 247),
                    new Color(160, 239, 158),
                    new Color(255, 252, 240),
                    new Color(255, 255, 195)};
            listUniqueColors.add(createColorScheme(colors, "DG_Grass"));
            colors = new Color[]{
                    new Color(179, 255, 255),
                    new Color(255, 204, 255),
                    new Color(255, 255, 204),
                    new Color(204, 204, 255),
                    new Color(204, 255, 179)};
            listUniqueColors.add(createColorScheme(colors, "EA_Sin_ColorScheme8"));
            colors = new Color[]{
                    new Color(241, 176, 160),
                    new Color(245, 245, 191),
                    new Color(185, 219, 65),
                    new Color(192, 232, 207),
                    new Color(251, 213, 181)};
            listUniqueColors.add(createColorScheme(colors, "EB_Sweet"));
            colors = new Color[]{
                    new Color(251, 203, 163),
                    new Color(229, 155, 18),
                    new Color(234, 226, 27),
                    new Color(177, 210, 34),
                    new Color(205, 238, 204)};
            listUniqueColors.add(createColorScheme(colors, "EC_Dusk"));
            colors = new Color[]{
                    new Color(180, 226, 206),
                    new Color(253, 206, 172),
                    new Color(203, 213, 232),
                    new Color(245, 202, 228),
                    new Color(230, 245, 202)};
            listUniqueColors.add(createColorScheme(colors, "ED_Pastel"));
            colors = new Color[]{
                    new Color(103, 205, 227),
                    new Color(165, 226, 228),
                    new Color(99, 192, 190),
                    new Color(183, 229, 193),
                    new Color(102, 201, 147)};
            listUniqueColors.add(createColorScheme(colors, "EE_Lake"));
            colors = new Color[]{
                    new Color(254, 242, 0),
                    new Color(104, 189, 178),
                    new Color(185, 219, 65),
                    new Color(206, 232, 142),
                    new Color(29, 151, 121)};
            listUniqueColors.add(createColorScheme(colors, "EF_Grass"));
            colors = new Color[]{
                    new Color(255, 251, 178),
                    new Color(230, 243, 180),
                    new Color(179, 208, 239),
                    new Color(142, 212, 226),
                    new Color(68, 200, 227)};
            listUniqueColors.add(createColorScheme(colors, "EG_Sin_ColorScheme1"));
            colors = new Color[]{
                    new Color(255, 204, 204),
                    new Color(255, 204, 153),
                    new Color(153, 204, 204),
                    new Color(204, 255, 255),
                    new Color(255, 255, 102)};
            listUniqueColors.add(createColorScheme(colors, "EH_Sin_ColorScheme4"));
            colors = new Color[]{
                    new Color(95, 217, 205),
                    new Color(234, 247, 134),
                    new Color(255, 181, 161),
                    new Color(184, 255, 184),
                    new Color(184, 244, 255)};
            listUniqueColors.add(createColorScheme(colors, "EI_Sin_ColorScheme6"));
            colors = new Color[]{
                    new Color(204, 255, 204),
                    new Color(204, 255, 153),
                    new Color(153, 204, 255),
                    new Color(198, 217, 240),
                    new Color(230, 226, 0)};
            listUniqueColors.add(createColorScheme(colors, "EJ_Sin_ColorScheme7"));
            colors = new Color[]{
                    new Color(165, 0, 36),
                    new Color(215, 48, 36),
                    new Color(245, 107, 69),
                    new Color(253, 174, 96),
                    new Color(254, 225, 143),

                    new Color(255, 255, 191),
                    new Color(225, 243, 248),
                    new Color(171, 217, 233),
                    new Color(116, 172, 209),
                    new Color(71, 117, 181),

                    new Color(48, 55, 149)};
            listUniqueColors.add(createColorScheme(colors, "FA_Red-Yellow-Blue"));
            colors = new Color[]{
                    new Color(48, 55, 149),
                    new Color(71, 117, 181),
                    new Color(116, 172, 209),
                    new Color(171, 217, 233),
                    new Color(225, 243, 248),

                    new Color(255, 255, 191),
                    new Color(254, 225, 143),
                    new Color(253, 174, 96),
                    new Color(245, 107, 69),
                    new Color(215, 48, 36),

                    new Color(165, 0, 36)};
            listUniqueColors.add(createColorScheme(colors, "FA_Blue-Yellow-Red"));
            colors = new Color[]{
                    new Color(165, 0, 36),
                    new Color(213, 64, 79),
                    new Color(245, 107, 69),
                    new Color(253, 174, 96),
                    new Color(254, 225, 138),

                    new Color(255, 255, 191),
                    new Color(217, 240, 138),
                    new Color(166, 217, 105),
                    new Color(102, 189, 99),
                    new Color(25, 153, 81),

                    new Color(0, 103, 55)};
            listUniqueColors.add(createColorScheme(colors, "FB_Red-Yellow-Green"));
        }

        {
            Color[] colors = new Color[]{
                    new Color(255, 242, 230),
                    new Color(255, 203, 153),
                    new Color(255, 140, 25)};
            listRangeColors.add(createColorScheme(colors, "CA_Oranges"));
            colors = new Color[]{
                    new Color(255, 230, 217),
                    new Color(252, 144, 112),
                    new Color(223, 39, 36)};
            listRangeColors.add(createColorScheme(colors, "CB_Reds"));
            colors = new Color[]{
                    new Color(255, 255, 230),
                    new Color(255, 255, 153),
                    new Color(230, 255, 51)};
            listRangeColors.add(createColorScheme(colors, "CC_Lemons"));
            colors = new Color[]{
                    new Color(229, 255, 237),
                    new Color(153, 255, 187),
                    new Color(0, 217, 152)};
            listRangeColors.add(createColorScheme(colors, "CD_Cyans"));
            colors = new Color[]{
                    new Color(229, 245, 225),
                    new Color(161, 217, 156),
                    new Color(48, 163, 85)};
            listRangeColors.add(createColorScheme(colors, "CE_Greens"));
            colors = new Color[]{
                    new Color(223, 236, 247),
                    new Color(159, 202, 225),
                    new Color(48, 130, 189)};
            listRangeColors.add(createColorScheme(colors, "CF_Blues"));
            colors = new Color[]{
                    new Color(240, 238, 245),
                    new Color(188, 189, 221),
                    new Color(117, 106, 177)};
            listRangeColors.add(createColorScheme(colors, "CG_Purples"));
            colors = new Color[]{
                    new Color(255, 242, 230),
                    new Color(255, 216, 178),
                    new Color(255, 178, 102),
                    new Color(227, 108, 9)};
            listRangeColors.add(createColorScheme(colors, "DA_Oranges"));
            colors = new Color[]{
                    new Color(254, 229, 217),
                    new Color(253, 174, 144),
                    new Color(252, 105, 75),
                    new Color(216, 43, 48)};
            listRangeColors.add(createColorScheme(colors, "DB_Reds"));
            colors = new Color[]{
                    new Color(255, 255, 230),
                    new Color(255, 255, 178),
                    new Color(255, 255, 127),
                    new Color(229, 255, 50)};
            listRangeColors.add(createColorScheme(colors, "DC_Lemons"));
            colors = new Color[]{
                    new Color(222, 247, 232),
                    new Color(149, 252, 189),
                    new Color(79, 247, 177),
                    new Color(0, 217, 152)};
            listRangeColors.add(createColorScheme(colors, "DD_Cyans"));
            colors = new Color[]{
                    new Color(238, 248, 233),
                    new Color(186, 228, 180),
                    new Color(116, 196, 118),
                    new Color(31, 138, 71)};
            listRangeColors.add(createColorScheme(colors, "DE_Greens"));
            colors = new Color[]{
                    new Color(223, 236, 247),
                    new Color(159, 202, 225),
                    new Color(95, 161, 204),
                    new Color(48, 130, 189)};
            listRangeColors.add(createColorScheme(colors, "DF_Blues"));
            colors = new Color[]{
                    new Color(242, 241, 247),
                    new Color(203, 202, 226),
                    new Color(159, 154, 201),
                    new Color(105, 81, 163)};
            listRangeColors.add(createColorScheme(colors, "DG_Purples"));
            colors = new Color[]{
                    new Color(254, 238, 223),
                    new Color(253, 190, 134),
                    new Color(253, 154, 86),
                    new Color(239, 107, 28),
                    new Color(230, 85, 7)};
            listRangeColors.add(createColorScheme(colors, "EA_Oranges"));
            colors = new Color[]{
                    new Color(254, 229, 217),
                    new Color(253, 174, 144),
                    new Color(252, 126, 100),
                    new Color(233, 71, 55),
                    new Color(216, 43, 48)};
            listRangeColors.add(createColorScheme(colors, "EB_Reds"));
            colors = new Color[]{
                    new Color(255, 255, 230),
                    new Color(255, 255, 196),
                    new Color(255, 255, 153),
                    new Color(249, 255, 111),
                    new Color(229, 255, 50)};
            listRangeColors.add(createColorScheme(colors, "EC_Lemons"));
            colors = new Color[]{
                    new Color(222, 247, 232),
                    new Color(163, 252, 198),
                    new Color(103, 247, 187),
                    new Color(31, 229, 162),
                    new Color(10, 216, 164)};
            listRangeColors.add(createColorScheme(colors, "ED_Cyans"));
            colors = new Color[]{
                    new Color(238, 248, 233),
                    new Color(186, 228, 180),
                    new Color(116, 196, 118),
                    new Color(53, 165, 89),
                    new Color(41, 140, 77)};
            listRangeColors.add(createColorScheme(colors, "EE_Greens"));
            colors = new Color[]{
                    new Color(240, 243, 255),
                    new Color(189, 215, 231),
                    new Color(106, 174, 214),
                    new Color(48, 130, 189),
                    new Color(15, 88, 163)};
            listRangeColors.add(createColorScheme(colors, "EF_Blues"));
            colors = new Color[]{
                    new Color(242, 241, 247),
                    new Color(203, 202, 226),
                    new Color(157, 152, 198),
                    new Color(131, 116, 181),
                    new Color(105, 81, 163)};
            listRangeColors.add(createColorScheme(colors, "EG_Purples"));
            colors = new Color[]{
                    new Color(254, 238, 223),
                    new Color(253, 190, 134),
                    new Color(253, 154, 86),
                    new Color(239, 107, 28),
                    new Color(230, 85, 7),
                    new Color(219, 72, 0)};
            listRangeColors.add(createColorScheme(colors, "FA_Oranges"));
            colors = new Color[]{
                    new Color(254, 229, 217),
                    new Color(253, 174, 144),
                    new Color(252, 126, 100),
                    new Color(233, 71, 55),
                    new Color(216, 43, 48),
                    new Color(204, 36, 40)};
            listRangeColors.add(createColorScheme(colors, "FB_Reds"));
            colors = new Color[]{
                    new Color(255, 255, 230),
                    new Color(255, 255, 196),
                    new Color(255, 255, 153),
                    new Color(249, 255, 111),
                    new Color(229, 255, 50),
                    new Color(216, 255, 0)};
            listRangeColors.add(createColorScheme(colors, "FC_Lemons"));
            colors = new Color[]{
                    new Color(222, 247, 232),
                    new Color(163, 252, 198),
                    new Color(103, 247, 187),
                    new Color(31, 229, 162),
                    new Color(10, 216, 164),
                    new Color(2, 198, 156)};
            listRangeColors.add(createColorScheme(colors, "FD_Cyans"));
            colors = new Color[]{
                    new Color(238, 248, 233),
                    new Color(186, 228, 180),
                    new Color(116, 196, 118),
                    new Color(48, 163, 85),
                    new Color(6, 127, 50),
                    new Color(3, 114, 58)};
            listRangeColors.add(createColorScheme(colors, "FE_Greens"));
            colors = new Color[]{
                    new Color(240, 243, 255),
                    new Color(189, 215, 231),
                    new Color(106, 174, 214),
                    new Color(48, 130, 189),
                    new Color(7, 89, 173),
                    new Color(5, 67, 158)};
            listRangeColors.add(createColorScheme(colors, "FF_Blues"));
            colors = new Color[]{
                    new Color(242, 241, 247),
                    new Color(203, 202, 226),
                    new Color(157, 152, 198),
                    new Color(131, 116, 181),
                    new Color(105, 81, 163),
                    new Color(89, 58, 153)};
            listRangeColors.add(createColorScheme(colors, "FG_Purples"));
            colors = new Color[]{
                    new Color(255, 254, 102),
                    new Color(255, 119, 51)};
            listRangeColors.add(createColorScheme(colors, "GA_Yellow to Orange"));
            colors = new Color[]{
                    new Color(250, 204, 137),
                    new Color(204, 40, 40)};
            listRangeColors.add(createColorScheme(colors, "GB_Orange to Red"));
            colors = new Color[]{
                    new Color(75, 172, 198),
                    new Color(255, 255, 255),
                    new Color(178, 162, 199)};
            listRangeColors.add(createColorScheme(colors, "GC_Olive to Purple"));
            colors = new Color[]{
                    new Color(127, 194, 105),
                    new Color(255, 255, 255),
                    new Color(247, 150, 70)};
            listRangeColors.add(createColorScheme(colors, "GD_Green to Orange"));
            colors = new Color[]{
                    new Color(146, 255, 220),
                    new Color(255, 255, 255),
                    new Color(255, 255, 0)};
            listRangeColors.add(createColorScheme(colors, "GE_Blue to Lemon"));
            colors = new Color[]{
                    new Color(255, 255, 255),
                    new Color(253, 225, 255),
                    new Color(242, 195, 255),
                    new Color(236, 175, 255),
                    new Color(229, 156, 255),

                    new Color(222, 136, 255),
                    new Color(216, 117, 255),
                    new Color(209, 97, 255),
                    new Color(188, 88, 255),
                    new Color(139, 100, 255),

                    new Color(114, 107, 255),
                    new Color(66, 157, 244),
                    new Color(51, 217, 226),
                    new Color(53, 236, 176),
                    new Color(134, 221, 25),

                    new Color(185, 234, 21),
                    new Color(244, 249, 22),
                    new Color(244, 203, 24),
                    new Color(243, 156, 25),
                    new Color(241, 108, 26),

                    new Color(240, 62, 27),
                    new Color(224, 33, 32),
                    new Color(193, 24, 41),
                    new Color(178, 20, 46),
                    new Color(131, 7, 60),

                    new Color(110, 0, 78)};
            listRangeColors.add(createColorScheme(colors, "ZA_Temperature 1"));
            colors = new Color[]{
                    new Color(28, 12, 204),
                    new Color(40, 25, 204),
                    new Color(34, 77, 244),
                    new Color(51, 119, 230),
                    new Color(107, 174, 217),

                    new Color(122, 222, 238),
                    new Color(204, 255, 240),
                    new Color(255, 246, 172),
                    new Color(252, 230, 121),
                    new Color(250, 222, 53),

                    new Color(251, 183, 46),
                    new Color(255, 161, 47),
                    new Color(230, 112, 2),
                    new Color(255, 85, 1)};
            listRangeColors.add(createColorScheme(colors, "ZB_Temperature 2"));
            colors = new Color[]{
                    new Color(255, 255, 216),
                    new Color(255, 204, 153),
                    new Color(255, 153, 51),
                    new Color(204, 51, 0),
                    new Color(153, 0, 0)};
            listRangeColors.add(createColorScheme(colors, "ZC_Temperature 3"));
            colors = new Color[]{
                    new Color(112, 229, 236),
                    new Color(217, 255, 255),
                    new Color(252, 255, 174),
                    new Color(255, 255, 1),
                    new Color(250, 113, 0),
                    new Color(184, 103, 48)};
            listRangeColors.add(createColorScheme(colors, "ZD_Temperature 4"));
            colors = new Color[]{
                    new Color(255, 62, 0),
                    new Color(255, 93, 0),
                    new Color(255, 124, 0),
                    new Color(255, 155, 0),
                    new Color(255, 185, 0),

                    new Color(255, 216, 0),
                    new Color(255, 247, 0),
                    new Color(232, 255, 23),
                    new Color(201, 255, 54),
                    new Color(170, 255, 85),

                    new Color(139, 255, 116),
                    new Color(108, 255, 147),
                    new Color(77, 255, 178),
                    new Color(46, 255, 209),
                    new Color(15, 255, 240),

                    new Color(0, 248, 255),
                    new Color(0, 233, 255),
                    new Color(0, 219, 255),
                    new Color(0, 204, 255),
                    new Color(0, 190, 255),

                    new Color(0, 175, 255),
                    new Color(0, 160, 255),
                    new Color(0, 146, 255),
                    new Color(0, 131, 255),
                    new Color(0, 115, 255),

                    new Color(0, 98, 255),
                    new Color(0, 82, 255),
                    new Color(0, 65, 255),
                    new Color(0, 49, 255),
                    new Color(0, 33, 255),

                    new Color(0, 16, 255),
                    new Color(0, 0, 255)};
            listRangeColors.add(createColorScheme(colors, "ZE_Precipitation 1"));
            colors = new Color[]{
                    new Color(246, 151, 107),
                    new Color(247, 192, 143),
                    new Color(252, 228, 179),
                    new Color(167, 219, 212),
                    new Color(92, 182, 229),
                    new Color(4, 155, 224)};
            listRangeColors.add(createColorScheme(colors, "ZF_Precipitation 2"));
            colors = new Color[]{
                    new Color(253, 253, 227),
                    new Color(204, 251, 219),
                    new Color(171, 247, 235),
                    new Color(116, 225, 232),
                    new Color(108, 198, 235),
                    new Color(78, 178, 219)};
            listRangeColors.add(createColorScheme(colors, "ZG_Precipitation 3"));
            colors = new Color[]{
                    new Color(252, 75, 45),
                    new Color(253, 118, 52),
                    new Color(252, 154, 38),
                    new Color(248, 205, 89),
                    new Color(250, 235, 110),

                    new Color(238, 251, 132),
                    new Color(197, 248, 136),
                    new Color(168, 247, 155),
                    new Color(139, 250, 189),
                    new Color(107, 249, 172),

                    new Color(75, 229, 146)};
            listRangeColors.add(createColorScheme(colors, "ZH_Precipitation 4"));
            colors = new Color[]{
                    new Color(106, 247, 0),
                    new Color(99, 254, 0),
                    new Color(132, 255, 0),
                    new Color(144, 255, 0),
                    new Color(172, 252, 3),

                    new Color(191, 255, 0),
                    new Color(210, 255, 0),
                    new Color(224, 254, 0),
                    new Color(247, 245, 2),
                    new Color(255, 246, 0),

                    new Color(255, 236, 31),
                    new Color(255, 222, 1),
                    new Color(248, 209, 0),
                    new Color(255, 202, 2),
                    new Color(255, 193, 0),

                    new Color(249, 176, 0),
                    new Color(255, 169, 0),
                    new Color(252, 159, 0),
                    new Color(249, 153, 0),
                    new Color(255, 140, 0),

                    new Color(248, 136, 26),
                    new Color(255, 112, 1),
                    new Color(255, 112, 9),
                    new Color(255, 92, 13),
                    new Color(250, 89, 0),

                    new Color(255, 75, 4),
                    new Color(250, 57, 0),
                    new Color(255, 48, 0),
                    new Color(255, 44, 0),
                    new Color(246, 33, 0),

                    new Color(247, 27, 3)};
            listRangeColors.add(createColorScheme(colors, "ZI_Altitude 1"));
            colors = new Color[]{
                    new Color(250, 248, 251),
                    new Color(203, 203, 203),
                    new Color(161, 147, 134),
                    new Color(123, 74, 42),
                    new Color(111, 37, 12),

                    new Color(123, 13, 0),
                    new Color(188, 70, 9),
                    new Color(227, 183, 22),
                    new Color(99, 147, 63),
                    new Color(23, 158, 55),

                    new Color(214, 235, 132),
                    new Color(192, 245, 177),
                    new Color(175, 243, 232)};
            listRangeColors.add(createColorScheme(colors, "ZJ_Altitude 2"));
            colors = new Color[]{
                    new Color(155, 228, 248),
                    new Color(252, 252, 268),
                    new Color(251, 194, 98),
                    new Color(174, 163, 128),
                    new Color(130, 107, 109)};
            listRangeColors.add(createColorScheme(colors, "ZK_Altitude 3"));
        }
    }

    /**
     * 根据数据源索引和数据集名称获取数据集对象
     *
     * @return
     */
    public static Dataset getDataset(int datasourceIndex, String datasetName) {
        try {
            Datasources datasources = SMap.getSMWorkspace().getWorkspace().getDatasources();
            Datasource datasource = datasources.get(datasourceIndex);
            Dataset dataset = datasource.getDatasets().get(datasetName);

            return dataset;
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 根据数据源别名和数据集名称获取数据集对象
     *
     * @return
     */
    public static Dataset getDataset(String datasourceAlias, String datasetName) {
        try {
            Datasources datasources = SMap.getSMWorkspace().getWorkspace().getDatasources();
            Datasource datasource = datasources.get(datasourceAlias);
            Dataset dataset = datasource.getDatasets().get(datasetName);

            return dataset;
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 打开数据源路径，数据集名称获取数据集对象
     *
     * @return
     */
    public static Dataset getDataset(Map data, String datasetName) {
        try {
            if (!data.containsKey("server") || !data.containsKey("alias") || !data.containsKey("engineType")) {
                return null;
            }

            Dataset dataset = null;
            Datasource datasource = SMap.getSMWorkspace().openDatasource(data);
            if (datasource != null) {
                dataset = datasource.getDatasets().get(datasetName);
            }
            return dataset;
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 根据图层索引获取图层对象
     *
     * @return
     */
    public static Layer getLayerByIndex(int layerIndex) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            Layers layers = mapControl.getMap().getLayers();
            return layers.get(layerIndex);
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 根据图层名称获取图层对象
     *
     * @return
     */
    public static Layer getLayerByName(String layerName) {
        try {
            MapControl mapControl = SMap.getSMWorkspace().getMapControl();
            Layers layers = mapControl.getMap().getLayers();
            return layers.get(layerName);
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 解析获取单值专题图(子项)的显示风格
     *
     * @param style
     * @param data
     * @return
     */
    public static GeoStyle getThemeUniqueGeoStyle(GeoStyle style, HashMap<String, Object> data) {
        final GeoStyle oldStyle = style.clone();
        try {
            if (data.containsKey("MarkerSymbolID")) {
                //点符号的ID
                String MarkerSymbolID = data.get("MarkerSymbolID").toString();
                style.setMarkerSymbolID(Integer.parseInt(MarkerSymbolID));
            }
            if (data.containsKey("MarkerSize")) {
                //点符号的大小
                String MarkerSize = data.get("MarkerSize").toString();
                int mm = Integer.parseInt(MarkerSize);
                style.setMarkerSize(new Size2D(mm, mm));
            }
            if (data.containsKey("MakerColor")) {
                //点符号的颜色
                String MakerColor = data.get("MakerColor").toString();
                style.setLineColor(ColorParseUtil.getColor(MakerColor));
            }
            if (data.containsKey("MarkerAngle")) {
                //点符号的旋转角度
                String MarkerAngle = data.get("MarkerAngle").toString();
                style.setMarkerAngle(Integer.parseInt(MarkerAngle));
            }
            if (data.containsKey("MarkerAlpha")) {
                //点符号的透明度
                String MarkerAlpha = data.get("MarkerAlpha").toString();
                style.setFillOpaqueRate(100 - Integer.parseInt(MarkerAlpha));
            }

            if (data.containsKey("LineSymbolID")) {
                //线符号的ID(//设置边框符号的ID)
                String LineSymbolID = data.get("LineSymbolID").toString();
                style.setLineSymbolID(Integer.parseInt(LineSymbolID));
            }
            if (data.containsKey("LineWidth")) {
                //线宽(边框符号宽度)
                String LineWidth = data.get("LineWidth").toString();
                int mm = Integer.parseInt(LineWidth);
                double width = (double) mm / 10;
                style.setLineWidth(width);
            }
            if (data.containsKey("LineColor")) {
                //线颜色(边框符号颜色)
                String LineColor = data.get("LineColor").toString();
                style.setLineColor(ColorParseUtil.getColor(LineColor));
            }

            if (data.containsKey("FillSymbolID")) {
                //面符号的ID
                String FillSymbolID = data.get("FillSymbolID").toString();
                style.setFillSymbolID(Integer.parseInt(FillSymbolID));
            }
            if (data.containsKey("FillForeColor")) {
                //前景色
                String FillForeColor = data.get("FillForeColor").toString();
                style.setFillForeColor(ColorParseUtil.getColor(FillForeColor));
            }
            if (data.containsKey("FillBackColor")) {
                //背景色
                String FillBackColor = data.get("FillBackColor").toString();
                style.setFillBackColor(ColorParseUtil.getColor(FillBackColor));
            }
            if (data.containsKey("FillOpaqueRate")) {
                //设置透明度（0-100）
                String FillOpaqueRate = data.get("FillOpaqueRate").toString();
                style.setFillOpaqueRate(100 - Integer.parseInt(FillOpaqueRate));
            }
            if (data.containsKey("FillGradientMode")) {
                //设置渐变
                String FillGradientMode = data.get("FillGradientMode").toString();
                switch (FillGradientMode) {
                    case "LINEAR":  //线性渐变
                        style.setFillGradientMode(com.supermap.data.FillGradientMode.LINEAR);
                        break;
                    case "RADIAL":  //辐射渐变
                        style.setFillGradientMode(com.supermap.data.FillGradientMode.RADIAL);
                        break;
                    case "SQUARE":  //方形渐变
                        style.setFillGradientMode(com.supermap.data.FillGradientMode.SQUARE);
                        break;
                    case "NONE":  //无渐变
                        style.setFillGradientMode(com.supermap.data.FillGradientMode.NONE);
                        break;
                }
            }

            return style;
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
            return oldStyle;
        }

    }

    /**
     * 获取单值专题图默认的显示风格
     *
     * @param style
     * @return
     */
    public static WritableMap getThemeUniqueDefaultStyle(GeoStyle style) {
        WritableMap writeMap = Arguments.createMap();
        try {
            //点符号的ID
            int markerSymbolID = style.getMarkerSymbolID();
            writeMap.putInt("MarkerSymbolID", markerSymbolID);

            //点符号的大小
            Size2D markerSize = style.getMarkerSize();
            writeMap.putDouble("MarkerSize", markerSize.getHeight());

            //点符号的颜色
            Color markerColor = style.getLineColor();
            writeMap.putString("MarkerColor", markerColor.toColorString());

            //点符号的旋转角度
            double markerAngle = style.getMarkerAngle();
            writeMap.putDouble("MarkerAngle", markerAngle);

            //点符号的不透明度
            int markerFillOpaqueRate = style.getFillOpaqueRate();
            writeMap.putInt("MarkerFillOpaqueRate", markerFillOpaqueRate);

            //线符号的ID(//设置边框符号的ID)
            int lineSymbolID = style.getLineSymbolID();
            writeMap.putInt("LineSymbolID", lineSymbolID);

            //线宽(边框符号宽度)
            double lineWidth = style.getLineWidth();
            writeMap.putDouble("LineWidth", lineWidth);

            //线颜色(边框符号颜色)
            Color lineColor = style.getLineColor();
            writeMap.putString("LineColor", lineColor.toColorString());

            //面符号的ID
            int fillSymbolID = style.getFillSymbolID();
            writeMap.putInt("FillSymbolID", fillSymbolID);

            //前景色
            Color fillForeColor = style.getFillForeColor();
            writeMap.putString("FillForeColor", fillForeColor.toColorString());

            //背景色
            Color fillBackColor = style.getFillBackColor();
            writeMap.putString("FillBackColor", fillBackColor.toColorString());

            //不透明度
            int fillOpaqueRate = style.getFillOpaqueRate();
            writeMap.putInt("FillOpaqueRate", fillOpaqueRate);

            //设置渐变
            FillGradientMode fillGradientMode = style.getFillGradientMode();
            String mode = "NONE";
            if (fillGradientMode == FillGradientMode.LINEAR) {
                //线性渐变
                mode = "LINEAR";
            } else if (fillGradientMode == FillGradientMode.RADIAL) {
                //辐射渐变
                mode = "RADIAL";
            } else if (fillGradientMode == FillGradientMode.SQUARE) {
                //方形渐变
                mode = "SQUARE";
            } else if (fillGradientMode == FillGradientMode.NONE) {
                //无渐变
                mode = "NONE";
            }
            writeMap.putString("FillGradientMode", mode);

            return writeMap;
        } catch (Exception e) {
            Log.e(TAG, e.getMessage());
            e.printStackTrace();
            return null;
        }

    }

    /**
     * 获取颜色渐变类型
     *
     * @param type
     * @return ColorGradientType
     */
    public static ColorGradientType getColorGradientType(String type) {
        switch (type) {
            case "BLACKWHITE":
                //黑白渐变色
                return ColorGradientType.BLACKWHITE;
            case "BLUEBLACK":
                //蓝黑渐变色
                return ColorGradientType.BLUEBLACK;
            case "BLUERED":
                //蓝红渐变色
                return ColorGradientType.BLUERED;
            case "BLUEWHITE":
                //蓝白渐变色
                return ColorGradientType.BLUEWHITE;
            case "CYANBLACK":
                //青黑渐变色
                return ColorGradientType.CYANBLACK;
            case "CYANBLUE":
                //青蓝渐变色
                return ColorGradientType.CYANBLUE;
            case "CYANGREEN":
                //青绿渐变色
                return ColorGradientType.CYANGREEN;
            case "CYANWHITE":
                //青白渐变色
                return ColorGradientType.CYANWHITE;
            case "GREENBLACK":
                //绿黑渐变色
                return ColorGradientType.GREENBLACK;
            case "GREENBLUE":
                //绿蓝渐变色
                return ColorGradientType.GREENBLUE;
            case "GREENORANGEVIOLET":
                //绿橙紫渐变色
                return ColorGradientType.GREENORANGEVIOLET;
            case "GREENRED":
                //绿红渐变色
                return ColorGradientType.GREENRED;
            case "GREENWHITE":
                //绿白渐变色
                return ColorGradientType.GREENWHITE;
            case "PINKBLACK":
                //粉红黑渐变色
                return ColorGradientType.PINKBLACK;
            case "PINKBLUE":
                //粉红蓝渐变色
                return ColorGradientType.PINKBLUE;
            case "PINKRED":
                //粉红红渐变色
                return ColorGradientType.PINKRED;
            case "PINKWHITE":
                //粉红白渐变色
                return ColorGradientType.PINKWHITE;
            case "RAINBOW":
                //彩虹色
                return ColorGradientType.RAINBOW;
            case "REDBLACK":
                //红黑渐变色
                return ColorGradientType.REDBLACK;
            case "REDWHITE":
                //红白渐变色
                return ColorGradientType.REDWHITE;
            case "SPECTRUM":
                //光谱渐变
                return ColorGradientType.SPECTRUM;
            case "TERRAIN":
                //地形渐变
                return ColorGradientType.TERRAIN;
            case "YELLOWBLACK":
                //黄黑渐变色
                return ColorGradientType.YELLOWBLACK;
            case "YELLOWBLUE":
                //黄蓝渐变色
                return ColorGradientType.YELLOWBLUE;
            case "YELLOWGREEN":
                //黄绿渐变色
                return ColorGradientType.YELLOWGREEN;
            case "YELLOWRED":
                //黄红渐变色
                return ColorGradientType.YELLOWRED;
            case "YELLOWWHITE":
                //黄白渐变色
                return ColorGradientType.YELLOWWHITE;
            default:
                //默认
                return ColorGradientType.TERRAIN;
        }

    }

    /**
     * 获取分段模式
     *
     * @param mode
     * @return RangeMode
     */
    public static RangeMode getRangeMode(String mode) {
        switch (mode) {
            case "CUSTOMINTERVAL":
                //自定义分段
                return RangeMode.CUSTOMINTERVAL;
            case "EQUALINTERVAL":
                //等距离分段
                return RangeMode.EQUALINTERVAL;
            case "LOGARITHM":
                //对数分段
                return RangeMode.LOGARITHM;
            case "NONE":
                //空分段模式
                return RangeMode.NONE;
            case "QUANTILE":
                //等计数分段
                return RangeMode.QUANTILE;
            case "SQUAREROOT":
                //平方根分段
                return RangeMode.SQUAREROOT;
            case "STDDEVIATION":
                //标准差分段。
                return RangeMode.STDDEVIATION;
            default:
                //默认：等距分段
                return RangeMode.EQUALINTERVAL;
        }
    }

    /**
     * 返回标签专题图中的标签背景的形状类型。
     *
     * @param shape
     * @return RangeMode
     */
    public static LabelBackShape getLabelBackShape(String shape) {
        switch (shape) {
            case "DIAMOND":
                // 菱形背景
                return LabelBackShape.DIAMOND;
            case "ELLIPSE":
                // 椭圆形背景
                return LabelBackShape.ELLIPSE;
            case "MARKER":
                // 符号背景
                return LabelBackShape.MARKER;
            case "NONE":
                // 空背景
                return LabelBackShape.NONE;
            case "RECT":
                // 矩形背景
                return LabelBackShape.RECT;
            case "ROUNDRECT":
                // 圆角矩形背景
                return LabelBackShape.ROUNDRECT;
            case "TRIANGLE":
                // 三角形背景
                return LabelBackShape.TRIANGLE;
            default:
                //默认
                return LabelBackShape.NONE;
        }
    }

    /**
     * 返回标签专题图中的标签背景的形状类型字符串
     *
     * @param shape
     * @return RangeMode
     */
    public static String getLabelBackShapeString(LabelBackShape shape) {
        if (shape == LabelBackShape.DIAMOND) {
            return "DIAMOND";
        } else if (shape == LabelBackShape.ELLIPSE) {
            return "ELLIPSE";
        } else if (shape == LabelBackShape.MARKER) {
            return "MARKER";
        } else if (shape == LabelBackShape.NONE) {
            return "NONE";
        } else if (shape == LabelBackShape.RECT) {
            return "RECT";
        } else if (shape == LabelBackShape.ROUNDRECT) {
            return "ROUNDRECT";
        } else if (shape == LabelBackShape.TRIANGLE) {
            return "TRIANGLE";
        } else {
            return null;
        }
    }

    public static List<String> getColorList() {
        List<String> colorList = new ArrayList<>();
        colorList.add("#000000");
        colorList.add("#424242");
        colorList.add("#757575");
        colorList.add("#BDBDBD");
        colorList.add("#EEEEEE");
        colorList.add("#FFFFFF");
        colorList.add("#3E2723");
        colorList.add("#5D4037");
        colorList.add("#A1887F");
        colorList.add("#D7CCC8");
        colorList.add("#263238");
        colorList.add("#546E7A");
        colorList.add("#90A4AE");
        colorList.add("#CFD8DC");
        colorList.add("#FFECB3");
        colorList.add("#FFF9C4");
        colorList.add("#F1F8E9");
        colorList.add("#E3F2FD");
        colorList.add("#EDE7F6");
        colorList.add("#FCE4EC");
        colorList.add("#FBE9E7");
        colorList.add("#004D40");
        colorList.add("#006064");
        colorList.add("#009688");
        colorList.add("#8BC34A");
        colorList.add("#A5D6A7");
        colorList.add("#80CBC4");
        colorList.add("#80DEEA");
        colorList.add("#A1C2FA");
        colorList.add("#9FA8DA");
        colorList.add("#01579B");
        colorList.add("#1A237E");
        colorList.add("#3F51B5");
        colorList.add("#03A9F4");
        colorList.add("#4A148C");
        colorList.add("#673AB7");
        colorList.add("#9C27B0");
        colorList.add("#880E4F");
        colorList.add("#E91E63");
        colorList.add("#F44336");
        colorList.add("#F48FB1");
        colorList.add("#EF9A9A");
        colorList.add("#F57F17");
        colorList.add("#F4B400");
        colorList.add("#FADA80");
        colorList.add("#FFF59D");
        colorList.add("#FFEB3B");

        return colorList;
    }

    //获取单值颜色方案
    public static Color[] getUniqueColors(String colorType) {
        try{
            for (int i = 0; i < listUniqueColors.size(); i++) {
                HashMap<String, Object> hashMap = listUniqueColors.get(i);
                String colorScheme = (String) hashMap.get("ColorScheme");
                if (colorScheme.equals(colorType)) {
                    return (Color[]) hashMap.get("Colors");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return null;
    }

    //获取分段颜色方案
    public static Color[] getRangeColors(String colorType) {
        try{
            for (int i = 0; i < listRangeColors.size(); i++) {
                HashMap<String, Object> hashMap = listRangeColors.get(i);
                String colorScheme = (String) hashMap.get("ColorScheme");
                if (colorScheme.equals(colorType)) {
                    return (Color[]) hashMap.get("Colors");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return null;
    }

    //获取专题图层上次设置的颜色方案
    public static Color[] getLastThemeColors(Layer layer) {
        try {
            if (layer == null) {
                return null;
            }
            Theme theme = layer.getTheme();
            if (theme == null) {
                return  null;
            }
            Color color_start = null;
            Color color_end = null;
            if (theme.getType() == ThemeType.UNIQUE) {
                ThemeUnique themeUnique = (ThemeUnique) theme;
                int count = themeUnique.getCount();

                switch (layer.getDataset().getType().toString()) {
                    case "POINT":
                        color_start = themeUnique.getItem(0).getStyle().getLineColor();
                        color_end = themeUnique.getItem(count - 1).getStyle().getLineColor();
                        break;
                    case "LINE":
                        color_start = themeUnique.getItem(0).getStyle().getLineColor();
                        color_end = themeUnique.getItem(count - 1).getStyle().getLineColor();
                        break;
                    case "REGION":
                        color_start = themeUnique.getItem(0).getStyle().getFillForeColor();
                        color_end = themeUnique.getItem(count - 1).getStyle().getFillForeColor();
                        break;
                }

                if (color_start == null || color_end == null){
                    return null;
                }

                int rgb_start = color_start.getRGB();
                int rgb_end = color_end.getRGB();

                for (int i = 0; i < listUniqueColors.size(); i++) {
                    HashMap<String, Object> hashMap = listUniqueColors.get(i);
                    Color[] colors = (Color[]) hashMap.get("Colors");
                    int rgb01 = colors[0].getRGB();
                    int rgb02 = colors[colors.length - 1].getRGB();
                    if (rgb_start == rgb01 && rgb_end == rgb02) {
                        return colors;
                    }
                }
            } else if (theme.getType() == ThemeType.RANGE) {
                ThemeRange themeRange = (ThemeRange) theme;
                int count = themeRange.getCount();

                switch (layer.getDataset().getType().toString()) {
                    case "POINT":
                        color_start = themeRange.getItem(0).getStyle().getLineColor();
                        color_end = themeRange.getItem(count - 1).getStyle().getLineColor();
                        break;
                    case "LINE":
                        color_start = themeRange.getItem(0).getStyle().getLineColor();
                        color_end = themeRange.getItem(count - 1).getStyle().getLineColor();
                        break;
                    case "REGION":
                        color_start = themeRange.getItem(0).getStyle().getFillForeColor();
                        color_end = themeRange.getItem(count - 1).getStyle().getFillForeColor();
                        break;
                }

                if (color_start == null || color_end == null){
                    return null;
                }

                int rgb_start = color_start.getRGB();
                int rgb_end = color_end.getRGB();

                for (int i = 0; i < listRangeColors.size(); i++) {
                    HashMap<String, Object> hashMap = listRangeColors.get(i);
                    Color[] colors = (Color[]) hashMap.get("Colors");
                    int rgb01 = colors[0].getRGB();
                    int rgb02 = colors[colors.length - 1].getRGB();
                    if (rgb_start == rgb01 && rgb_end == rgb02) {
                        return colors;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return null;
    }

    public static void setGeoStyleColor(DatasetType type, GeoStyle geoStyle, Color color) {
        try {
            switch (type.toString()) {
                case "POINT":
                    geoStyle.setLineColor(color);
                    break;
                case "LINE":
                    geoStyle.setLineColor(color);
                    break;
                case "REGION":
                    geoStyle.setFillForeColor(color);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
