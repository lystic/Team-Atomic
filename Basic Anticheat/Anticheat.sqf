/*	
	AUTHOR: Lystic
	DATE: 05/11/14
	FILE: Anticheat.sqf
	COMMENT: Do not edit this file. Run this file from your mission init!

*/

  /* Configuration */

_Enabled = true;							//Enable or disable the anticheat
_Admins = ["01234567891234567"]; 			//Add your admin UID here
_Use_Life_fnc_MP = false;					//If you are using altis life change this to true

//Add new cheat files & variables & menus to these lists
_DetectedFiles = ["JM3.sqf","JM3.png","wookie.sqf","wookie_wuat\start.sqf","lystoarma3\start.sqf","hack.sqf","cheat.sqf","JxMxE.sqf","JME.sqf","wookiev5.sqf","menu.sqf"];			
_DetectedVariables = ["ESP","Wookie","Extasy","GOD","GodMode","JxMxE_Exec","Lystic","Hack","Script","Wookie_Exec","Bypass"];
_DetectedMenus = [3030];
/* End Configuration */

if(!_Enabled) exitWith {};

AH_fnc_MP = BIS_fnc_MP;
if(_Use_Life_fnc_MP) then {
	AH_fnc_MP = LIFE_fnc_MP;
};

if(isDedicated) then {
	diag_log "<ANTICHEAT>: Initialized!";
	Notify_Kick = compileFinal '
		_name = _this select 0;
		_uid = _this select 1;
		_reason = _this select 2;
		diag_log "<ANTICHEAT> Kicked User";
		diag_log _name;
		diag_log _uid;
		diag_log _reason;
		diag_log "<ANTICHEAT> End Kicked";
		[_this,"Receive_Notify",true,false] call AH_fnc_MP;
	';
	Notify_Load = compileFinal '
		diag_log format["<ANTICHEAT> %1",_this];
	';
} else {
	waitUntil{!isnull player};
	waitUntil{alive player};
	Receive_Notify = compileFinal "
		hint format['%1 was kicked for %2. Notify an admin!',_this select 0,_this select 2];
	";

	if(getplayeruid player in _Admins) exitWith {
		hint "WELCOME ADMIN";
		[[format["The Admin %1 has Joined",name player]],"Notify_Load",false,false] call AH_fnc_MP; 
	};		

	Kick = compileFinal "
		for '_i' from 0 to 100 do {(findDisplay _i) closeDisplay 0;};
		disableUserInput true;
	";

	[_DetectedFiles] spawn {
		_name = name player;
		_uid = getplayeruid player;
		loadFile "";
		{
			_text = loadFile _x;
			_numLetters = count(toArray(_text));
			if(_numLetters > 0) exitWith {
				[[_name,_uid,format["Bad Script: %1",_x],"Notify_Kick",false,false] call AH_fnc_MP;
				call Kick;
			};
		} foreach (_this select 0);
	};
	[_DetectedVariables] spawn {
		{
			_x spawn {
				waitUntil{!isNil _this};
				[[_name,_uid,format["Bad Variable: %1",_this],"Notify_Kick",false,false] call AH_fnc_MP;
				call Kick;
			};
		} forEach (_this select 0);
	};
	[_DetectedMenus] spawn {
		{
			_x spawn {
				waitUntil{!isNUll (findDisplay _this)};
				[[_name,_uid,format["Bad Menu: %1",_this]],"Notify_Kick",false,false] call AH_fnc_MP;
				call Kick;
			};
		} forEach (_this select 0);
	};
	[] spawn {
		_name = name player;
		_uid = getplayeruid player;
		while{true} do {
			if(unitRecoilCoefficient player < 1) exitWith {
				[[_name,_uid,"Recoil Hack"],"Notify_Kick",false,false] call AH_fnc_MP;
				call Kick;
			};
			_time = time + 5;
			setTerrainGrid 25;
			waitUntil{time >= _time};
		};
	};
	[[format["The Player %1 Has Initialized",name player]],"Notify_Load",false,false] call AH_fnc_MP; 
};