
#define COL_WHITE					{1, 1, 1, 0.3}
#define COL_DARKGRAY				{0.7, 0.7, 0.7, 0.3}
#define COL_BLACK					{0, 0, 0, 0.2}
#define COL_GREY					{0.5, 0.5, 0.5, 0.2}

class RscText;
class ScrollBar;

class RscTitles
{
	class RscDisplayFinishPositions {
		idd = 5001;
		movingEnable = 0;
		duration = 5;
		onLoad = "uiNamespace setVariable ['GUI_FinishPositions', _this select 0];";
		class ControlsBackground {
			class FinishPositions_Background: RscText {
				idc = -1;
				x =	safezoneX + (safezoneW / 4);
				y = safezoneY + (safezoneH / 4);
				w = safezoneW / 2;
				h = safezoneH / 2;
				style = 2;
				type = 13;
				text = "";	
				size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
				colorBackground[] = COL_BLACK;
			};
			class FinishPositions_TitleBackgorund: RscText {
				idc = -1;
				x =	safezoneX + (safezoneW / 4);
				y = safezoneY + (safezoneH / 4);
				w = safezoneW / 2;
				h = (safezoneH / 2)/ 20;// 1/20th of the height of the original background
				style = 2;
				type = 13;
				text = "";	
				size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
				colorBackground[] = COL_GREY;
			};
		};
		class Controls {
			class Title: RscText {
				idc = 1001;
				style = 2;
				type = 13;
				size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
				x =	safezoneX + (safezoneW / 4);
				y = safezoneY + (safezoneH / 4);
				w = safezoneW / 2;
				h = (safezoneH / 2)/ 20;
				text = "Altis Raceway - Finishing Results";
				font = "PuristaSemiBold";
			};
			class List {
				idc = 1002;
				type = 5;
				text = "";
				style = 0;
				rowHeight = 0;
				x =	(safezoneX + (safezoneW / 4)) + ((safezoneW / 2)/20);
				y = (safezoneY + (safezoneH / 4)) + ((safezoneH / 2)/10); 
				w = (18*(safezoneW / 2))/20; 
				h = (17*(safezoneH / 2))/ 20;
				size = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
				sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
				font = "PuristaSemiBold";
				shadow = false;
				period = 1.2;
				maxHistoryDelay = 1.0;
				tooltipColorText[] = COL_WHITE;
				tooltipColorBox[] = COL_DARKGRAY;
				tooltipColorShade[] = COL_GREY;
				colorBackground[] = COL_GREY;
				colorShadow[] = {0, 0, 0, 0.5};
				colorText[] = {1, 1, 1, 1};
				colorDisabled[] = COL_BLACK;
				colorScrollbar[] = COL_BLACK;
				colorSelect[] = COL_DARKGRAY;
				colorSelect2[] = COL_DARKGRAY;
				colorSelectBackground[] = COL_BLACK;
				colorSelectBackground2[] = COL_BLACK;
				soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect", 0.09, 1};
				class ListScrollBar : ScrollBar {
					color[] = COL_BLACK;
					autoScrollEnabled = 1;
				};
			};
		};
	};

};