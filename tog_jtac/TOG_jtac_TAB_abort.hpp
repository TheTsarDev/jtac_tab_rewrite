//////////////////////////////
//	Advanced JTAC module	//
//		  Rewrite			//
//		 by Tsardev			//
//							//
//////////////////////////////

class TOG_jtac_abort_dlg {
	idd = 1000001;
	movingEnable = true;
	onLoad = "uiNamespace setVariable ['TOG_jtac_abort_dlg', (_this select 0)];";
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
			text = $STR_TITLE_ABORT;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 7 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
		};

		class TOG_jtac_numtype_title: TOG_RscStructuredText {
			idc = -1;
			text = $STR_CALLSIGN_ABORT;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 8 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
		};

		/*class TOG_jtac_vehnum: TOG_RscCombo {
			idc = IDC_TOG_CAS_VEHNUM;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 8.52 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			onLBSelChanged = "call TOG_fnc_jtac_Trans_vehNum";
		};*/

		class TOG_jtac_vehtype: TOG_RscCombo {
			idc = IDC_TOG_CAS_VEHTYPE;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 8.52 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);

		};

		class TOG_jtac_tracker: TOG_RscToolbox {
  			idc = IDC_TOG_TRACK_ONOF;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 9.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);

			strings[] = {$STR_TRACK_START,$STR_TRACK_STOP};
  			values[] = {1,1};
  			toolTip = $STR_TOOLTIP_TRACKER;
  			onToolBoxSelChanged = "[_this select 1] spawn TOG_fnc_jtac_Abort_track;";
		};

		class TOG_jtac_dsttgttitle: TOG_RscStructuredText {
  			idc = -1;
			x = 25 * GUI_GRID_W + GUI_GRID_X;
			y = 11 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			text = $STR_DSTTGT_TRACKER;
		};
		class TOG_jtac_dstiptitle: TOG_RscStructuredText {
  			idc = -1;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 11 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			text = $STR_DSTIP_TRACKER;
		};
		class TOG_jtac_dsttgttracker: TOG_RscStructuredText {
  			idc = IDC_TOG_TRACK_DISTTGT;
			x = 25 * GUI_GRID_W + GUI_GRID_X;
			y = 11.52 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			colorBackground[] = {0,0,0,0};
			text = $STR_UNKNOW_TRACKER;
		};
		class TOG_jtac_dstiptracker: TOG_RscStructuredText {
  			idc = IDC_TOG_TRACK_DISTIP;
			x = 21 * GUI_GRID_W + GUI_GRID_X;
			y = 11.52 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			size = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.75);
			colorBackground[] = {0,0,0,0};
			text = $STR_UNKNOW_TRACKER;
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
  			text= $STR_BTN_ABORT;
  			onMouseButtonClick = "call TOG_fnc_jtac_Abort_request";

			colorBackgroundActive[] ={1,0,0,0.75};
			colorFocused[] ={1,0,0,0.75};

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
  			onMouseButtonClick = "closeDialog 0;  [] spawn TOG_fnc_jtac_showTab_CAS;";
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
  			onMouseButtonClick = "closeDialog 0;  [] spawn TOG_fnc_jtac_showTab_Trans;";
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
	};
};




