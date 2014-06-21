/*
	Name: Server init
	Desc: Starts the gamemode

*/
[] spawn {
	while{true} do {
		for "_i" from 1 to 4 do {
			call compile format["KART_%1 setDamage 0;",_i];
		};
	};
};

road_selector = compileFinal preprocessfilelinenumbers "Server\Functions\road_selector.sqf";
player_finished = compileFinal preprocessfilelinenumbers "Server\Functions\player_finished.sqf";
start_timeout = compileFinal preprocessfilelinenumbers "Server\Timeout\start_timeout.sqf";
end_timeout = compileFinal preprocessfilelinenumbers "Server\Timeout\end_timeout.sqf";
isRoundOver = compileFinal preprocessfilelinenumbers "Server\Functions\isRoundOver.sqf";
count_players = compileFinal preprocessfilelinenumbers "Server\Functions\count_players.sqf";
clear_markers = compileFinal preprocessfilelinenumbers "Server\Functions\clear_markers.sqf";

[] spawn {
	waitUntil{call count_players >= 2};
	[{hint 'Player count reached...';},"BIS_fnc_Spawn",true,false] call BIS_fnc_MP;
	sleep 20;
	_locations = [
		[50,[3478.74,13106.3],900], //KAVALA
		[20,[16809.6,12679.3],400], //PYGROS
		[20,[14022.3,18685.7],375]  //Athira
	];
	while{true} do {
		if(call count_players < 2) then {
			[] spawn {
				while{call count_players < 2} do {
					_time = time + 60;
					[{hint 'We are waiting for another player to join. Please be patient!';},"BIS_fnc_Spawn",true,false] call BIS_fnc_MP;
					waitUntil{time >= _time || (call count_players >= 2)};
				};
			};
			waitUntil{call count_players >= 2};
		};
		[{hint 'Loading the next race...';},"BIS_fnc_Spawn",true,false] call BIS_fnc_MP;
		if(!isNil "finished_players") then {
			if(count(finished_players) != 0) then {
				publicVariable "finished_players";
				publicVariable "finished_times";
				_code = {
					waitUntil{!isNil "finished_players" && !isNIl "finished_times"};
					0 cutRsc ["RscDisplayFinishPositions","PLAIN"];
					disableserialization;
					waitUntil{!isNull (uiNamespace getVariable ["GUI_FinishPositions",displaynull])};
					_display = uiNamespace getVariable ["GUI_FinishPositions",displaynull];
					if(!isNull _display) then {
						_ctrl = _display displayCtrl 1002;
						_position = 1;
						{	
							_time = finished_times select _forEachIndex;
							if(!isNull _x && isPlayer _x) then {
								_ctrl lbAdd format["%2 - %1 (%3s)",name _x,_position,_time];
								_position = _position + 1;
							};
						} forEach finished_players;
					};
					finished_players = nil;
					finished_times = nil;
				};
				[_code,"BIS_fnc_Spawn",true,false] call BIS_fnc_MP;
			};
		};
		sleep 10;
		finished_players = [];
		finished_times = [];
		call clear_markers;
		_location = _locations select floor(random(count(_locations)));
		_roads = _location call road_selector;
		_markers = [];
		_c = 0;
		_text = "";
		{
			_c = _c + 1;
			_markers = _markers + [format["checkpoint_%1",_c]];
			_text = _text + format['_PlrMark = createMarkerLocal ["checkpoint_%1",%2];_PlrMark setMarkerTypeLocal "Empty";_PlrMark setMarkerPosLocal %2;_PlrMark setMarkerSizeLocal [0.5,0.5];',_c,getpos _x];
		} forEach _roads;
		_code = compile _text;
		[_code,"BIS_fnc_Spawn",true,false] call BIS_fnc_MP;
		MAP_MARKERS = _markers;
		publicVariable "MAP_MARKERS";
		_pos = (_roads select 0) modelToWorld [0,0,0];
		_pos3 = (_roads select 1) modelToWorld [0,0,0];
		_dir = [_pos,_pos3] call BIS_fnc_DIRto;
		_c = 0;
		[{[] execVM "Clients\handleCheckpoints.sqf";},"BIS_fnc_Spawn",true,false] call BIS_fnc_MP;
		{
			if(isPlayer _x) then {
				_c = _c + 1;

				_pos2 = [(_pos select 0) - (random 5)*sin(_dir),(_pos select 1) - (random 5)*cos(_dir),0.1];
				call compile format["KART_%1 setposatl _pos2;KART_%1 setDir %2;",_c,_dir];
				_x setposatl _pos2;
				_player = _x;
				if(_player == vehicle _player) then {
					_karts = nearestObjects [_x, ["car"],20];
					{
						if(count(crew _x) == 0) exitWith {
							_player moveInDriver _x;
						};
					} forEach _karts;
				};
			};
		} forEach allUnits;	
		[{hint 'The race has started!';},"BIS_fnc_Spawn",true,false] call BIS_fnc_MP;
		waitUntil{call isRoundOver};
	};
};