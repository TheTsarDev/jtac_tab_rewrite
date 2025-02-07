//////////////////////////////
//	Advanced JTAC module	//
//		  Rewrite			//
//		 by Tsardev			//
//							//
//////////////////////////////

class TOG_jtac_cas_dlg {
	idd = 1000000;
	movingEnable = true;
	onLoad = "uiNamespace setVariable ['TOG_jtac_cas_dlg', (_this select 0)];";
	onUnload = "['TOG_jtac_CAS_mapClick', 'onMapSingleClick'] call BIS_fnc_removeStackedEventHandler";
	objects[] = {};

	class controlsBackground {

		class TOG_jtac_background: TOG_RscPicture {
				moving = 1;
				idc = IDC_TOG_BG;

				text= "\tog_jtac\img\tog_tab_bg.paa";
				x = 9.55 * GUI_GRID_W + GUI_GRID_X;
				y = 1.55 * GUI_GRID_H + GUI_GRID_Y;
				w = 23.8 * GUI_GRID_W;
				h = 25 * GUI_GRID_H;
			};

			class TOG_jtac_screen: TOG_RscPicture {

				idc = IDC_TOG_SCREEN;
				text = "#(argb,8,8,3)color(0.09,0.09,0.09,1)";
				x = 12.6 * GUI_GRID_W + GUI_GRID_X;
				y = 7 * GUI_GRID_H + GUI_GRID_Y;
				w = 16.4 * GUI_GRID_W;
				h = 13 * GUI_GRID_H;
			};

			class TOG_jtac_map: TOG_map {

				idc = IDC_TOG_MAP;
				text = "#(argb,8,8,3)color(0.2,0.431,0.647,1)";
				x = 12.6 * GUI_GRID_W + GUI_GRID_X;
				y = 7 * GUI_GRID_H + GUI_GRID_Y;
				w = 8 * GUI_GRID_W;
				h = 13 * GUI_GRID_H;
			};


	};


	class controls {


		//////////MENU CAS/////////////

		class TOG_jtac_card_title: TOG_RscStructuredText {
			idc = -1;
			text = $STR_TITLE_CAS;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 7 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
		};

		class TOG_jtac_numtype_title: TOG_RscStructuredText {
			idc = -1;
			text = $STR_NUMTYPE_CAS;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 8 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
		};

		class TOG_jtac_vehnum: TOG_RscCombo {
			idc = IDC_TOG_CAS_VEHNUM;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 8.52 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			onLBSelChanged = "call TOG_fnc_jtac_CAS_vehNum";
		};

		class TOG_jtac_vehtype: TOG_RscCombo {
			idc = IDC_TOG_CAS_VEHTYPE;
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 8.52 * GUI_GRID_H + GUI_GRID_Y;
			w = 7 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			onLBSelChanged = "[true] call TOG_fnc_jtac_CAS_callsign";
		};

		class TOG_jtac_mappos: TOG_RscToolbox {
  			idc = IDC_TOG_CAS_MAPPOS;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 9.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);

			strings[] = {$STR_TGTLOC_CAS,$STR_IPBP_CAS,$STR_FRIENDLOC_CAS};
  			values[] = {1,1,1};
  			toolTip = $STR_TOOLTIP_SELECTMAP;
  			onToolBoxSelChanged = "TOG_jtac_CAS_selectPos = (_this select 1);";
		};

		class TOG_jtac_headingtitle: TOG_RscStructuredText {
  			idc = -1;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 11 * GUI_GRID_H + GUI_GRID_Y;
			w = 2 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			text = $STR_HEADING_CAS;
		};

		class TOG_jtac_headingval: TOG_RscCombo {
			idc = IDC_TOG_CAS_HEADINGVAL;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 11.52 * GUI_GRID_H + GUI_GRID_Y;
			w = 2 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			onLBSelChanged = "[true] call TOG_fnc_jtac_CAS_changeMrkDir";
		};


		class TOG_jtac_offsettitle: TOG_RscStructuredText {
  			idc = -1;
			x = 23.5 * GUI_GRID_W + GUI_GRID_X;
			y = 11 * GUI_GRID_H + GUI_GRID_Y;
			w = 1.5 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			text = $STR_OFFSET_CAS;
		};

		class TOG_jtac_offsetval: TOG_RscCombo {
			idc = IDC_TOG_CAS_OFFSETVAL;
			x = 23.5 * GUI_GRID_W + GUI_GRID_X;
			y = 11.52 * GUI_GRID_H + GUI_GRID_Y;
			w = 1.5 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
		};

		class TOG_jtac_distancetitle: TOG_RscStructuredText {
  			idc = -1;
			x = 25.5 * GUI_GRID_W + GUI_GRID_X;
			y = 11 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			text = $STR_DISTANCE_CAS;
		};

		class TOG_jtac_distanceval: TOG_RscEdit {
  			idc = IDC_TOG_CAS_DISTVAL;
			x = 25.5 * GUI_GRID_W + GUI_GRID_X;
			y = 11.52 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
		};


		class TOG_jtac_desctitle: TOG_RscStructuredText {
  			idc = -1;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 12.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			text = $STR_TGTDESC_CAS;
		};

		class TOG_jtac_descval: TOG_RscCombo {
			idc = IDC_TOG_CAS_DESCVAL;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 13.02 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
		};

		class TOG_jtac_elevationtitle: TOG_RscStructuredText {
  			idc = -1;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 14 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			text = $STR_ELEVATION_CAS;
		};

		class TOG_jtac_elevationval: TOG_RscEdit {
  			idc = IDC_TOG_CAS_ELEVATIONVAL;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 14.52 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
		};

		class TOG_jtac_marktitle: TOG_RscStructuredText {
  			idc = -1;
			x = 25 * GUI_GRID_W + GUI_GRID_X;
			y = 14 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			text = $STR_MARK_CAS;
		};

		class TOG_jtac_marktype: TOG_RscCombo {
  			idc = IDC_TOG_CAS_MARKTYPE;
			x = 25 * GUI_GRID_W + GUI_GRID_X;
			y = 14.52 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			onLBSelChanged = "call TOG_fnc_jtac_CAS_markType";
		};

		class TOG_jtac_ammotype: TOG_RscToolbox {
  			idc = IDC_TOG_CAS_AMMOTYPE;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 15.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);

			strings[] = {$STR_GBU_CAS,$STR_CARPET_CAS,$STR_DIRECT_CAS};
  			values[] = {1,1,1};
  			toolTip = $STR_TOOLTIP_SELECTAMMO;
  			onToolBoxSelChanged = "TOG_jtac_CAS_ammoType = (_this select 1);";
  			onLoad = "(_this select 0) ctrlShow false;";
		};
		class TOG_jtac_ammotypeHeli: TOG_RscToolbox {
  			idc = IDC_TOG_CAS_AMMOTYPEHELI;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 15.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);

			strings[] = {$STR_MANUAL_CAS,$STR_DIRECT_CAS};
  			values[] = {1,1};
  			toolTip = $STR_TOOLTIP_SELECTAMMO;
  			onToolBoxSelChanged = "TOG_jtac_CAS_ammoType = (_this select 1);";
  			onLoad = "(_this select 0) ctrlShow false;";
		};
		class TOG_jtac_aborttitle: TOG_RscStructuredText {
  			idc = -1;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 17 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			text = $STR_CODE_ABORT;
		};
		class TOG_jtac_abortcode: TOG_RscEdit {
  			idc = IDC_TOG_ABORT_CODE;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 17.52 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
		};

		class TOG_jtac_request: TOG_RscButton {
  			idc = IDC_TOG_CAS_REQUEST;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 18.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
  			text= $STR_REQUEST_CAS;
  			onMouseButtonClick = "call TOG_fnc_jtac_CAS_request;";
		};
		////////// TAB BTNS
		class TOG_jtac_btn1: TOG_RscButton {
  			idc = 100001;
			x = 21.8 * GUI_GRID_W + GUI_GRID_X;
			y = 22 * GUI_GRID_H + GUI_GRID_Y;
			w = 1.2 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
  			text= "";
  			toolTip = "CAS";
  			onMouseButtonClick = "";
  			colorDisabled[] ={1,1,1,0};
			soundEnter[] = { "", 0, 1 };  //no sound
			soundPush[] = { "", 0, 1 };
			soundClick[] = {"tog_jtac\sound\beep_target.wss",0.09,1};
			soundEscape[] = { "", 0, 1 };
			colorBackground[] ={1,1,1,0};
			colorBackgroundDisabled[] ={1,1,1,0};
			colorBackgroundActive[] ={1,1,1,0};
			colorFocused[] ={1,1,1,0};
			colorShadow[] ={1,1,1,0};
			colorBorder[] ={1,1,1,0};

		};
		class TOG_jtac_btn2: TOG_RscButton {
  			idc = 100001;
			x = 22.8 * GUI_GRID_W + GUI_GRID_X;
			y = 22 * GUI_GRID_H + GUI_GRID_Y;
			w = 1.2 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
  			text= "";
  			toolTip = "Transport";
  			onMouseButtonClick = "[true] call TOG_fnc_jtac_CAS_callsign; closeDialog 0;  [] spawn TOG_fnc_jtac_showTab_Trans;";
  			colorDisabled[] ={1,1,1,0};
			soundEnter[] = { "", 0, 1 };  //no sound
			soundPush[] = { "", 0, 1 };
			soundClick[] = {"tog_jtac\sound\beep_target.wss",0.09,1};
			soundEscape[] = { "", 0, 1 };
			colorBackground[] ={1,1,1,0};
			colorBackgroundDisabled[] ={1,1,1,0};
			colorBackgroundActive[] ={1,1,1,0};
			colorFocused[] ={1,1,1,0};
			colorShadow[] ={1,1,1,0};
			colorBorder[] ={1,1,1,0};
		};
		class TOG_jtac_btn3: TOG_RscButton {
  			idc = 100001;
			x = 23.8 * GUI_GRID_W + GUI_GRID_X;
			y = 22 * GUI_GRID_H + GUI_GRID_Y;
			w = 1.2 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
  			text= "";
  			toolTip = "REQUESTED";
  			onMouseButtonClick = "[true] call TOG_fnc_jtac_CAS_callsign; closeDialog 0;  [] spawn TOG_fnc_jtac_showTab_Abort;";
  			colorDisabled[] ={1,1,1,0};
			soundEnter[] = { "", 0, 1 };  //no sound
			soundPush[] = { "", 0, 1 };
			soundClick[] = {"tog_jtac\sound\beep_target.wss",0.09,1};
			soundEscape[] = { "", 0, 1 };
			colorBackground[] ={1,1,1,0};
			colorBackgroundDisabled[] ={1,1,1,0};
			colorBackgroundActive[] ={1,1,1,0};
			colorFocused[] ={1,1,1,0};
			colorShadow[] ={1,1,1,0};
			colorBorder[] ={1,1,1,0};
		};
	};
};




