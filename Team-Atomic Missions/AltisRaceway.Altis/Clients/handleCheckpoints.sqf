/* Configuration */

_arrowType = "Pointers"; //Markers or Pointers - Pointers will point towards the next checkpoint

_checkpoint_prefix = "checkpoint"; //all markers should be named (PREFIX HERE)_1, (PREFIX HERE)_2

_marker_size = "Large"; //Change to Large or Small (ONLY FOR Markers Type)
_marker_Color = "Blue";//Red, Green, Blue, Pink, Yellow, or Cyan

_activation_distance = 5;//distance from checkpoint to activate it

MARKER_OBJECTS = [format["Sign_Arrow%1%2_F",_marker_size,_marker_Color],format["Sign_Arrow_Direction%1_F",_marker_Color]];

/* Core Code */

_checkpoints = [];
_markers = [];
if(toLower(_marker_size) == "small") then {
	_marker_size = "";
} else {
	_marker_size = "_" + _marker_size;
};
if(toLower(_marker_Color) == "red") then {
	_marker_Color = "";
} else {
	_marker_Color = "_" + _marker_Color;	
};

if(toLower(_arrowType) == "markers") then {

	_marker_object = format["Sign_Arrow%1%2_F",_marker_size,_marker_Color];

	for "_i" from 1 to 10000000 do {
		_markerName = format["%1_%2",_checkpoint_prefix,_i];
		_pos = getMarkerPos _markerName;
		


		_x = _pos select 0;
		if(_x == 0) exitWith {};

		_object = _marker_object createVehicleLocal _pos;
		_object setpos _pos;

		_object hideObject true;

		_markers = _markers + [_markerName];
		_checkpoints = _checkpoints + [_object];

		_object spawn {
			_object = _this;
			_height = 2;
			_totalSeconds = 2;
			_totalJumps = 10;
			while{true} do {
				_numJumps = _totalJumps*_height; 
				for '_i' from 0 to _numJumps do {
					_pos = getPosATL _object;
					_pos set[2,_i/_totalJumps];
					_object setPosATL _pos;
					sleep (1/_totalJumps);
				};
				for '_i' from 0 to _numJumps do {
					_pos = getPosATL _object;
					_pos set[2,_height - (_i/_totalJumps)];
					_object setPosATL _pos;
					sleep (1/_totalJumps);
				};		
			};
		};
		_object spawn {
			_object = _this;
			while{true} do {
				_object setDir ((getDir _object)+1);
				sleep (4/360);
			};
		};
	};

} else {
	_marker_object = format["Sign_Arrow_Direction%1_F",_marker_Color];

	for "_i" from 1 to 10000000 do {
		_markerName = format["%1_%2",_checkpoint_prefix,_i];
		//Check if is last marker
		_pos = getMarkerPos _markerName;
		_x = _pos select 0;
		if(_x == 0) exitWith {};


		_nextCheckpoint = format["%1_%2",_checkpoint_prefix,_i+1];
		_nextPos = getMarkerPos _nextCheckpoint; 
		_nextX = _nextPos select 0;
		if(_nextX == 0) then {
			_marker_object = format["Sign_Arrow%1%2_F",_marker_size,_marker_Color];

			_object = _marker_object createVehicleLocal _pos;
			_object setpos _pos;

			_object hideObject true;

			_markers = _markers + [_markerName];
			_checkpoints = _checkpoints + [_object];

			_object spawn {
				_object = _this;
				_height = 2;
				_totalSeconds = 2;
				_totalJumps = 10;
				while{true} do {
					_numJumps = _totalJumps*_height; 
					for '_i' from 0 to _numJumps do {
						_pos = getPosATL _object;
						_pos set[2,_i/_totalJumps];
						_object setPosATL _pos;
						sleep (1/_totalJumps);
					};
					for '_i' from 0 to _numJumps do {
						_pos = getPosATL _object;
						_pos set[2,_height - (_i/_totalJumps)];
						_object setPosATL _pos;
						sleep (1/_totalJumps);
					};		
				};
			};
			_object spawn {
				_object = _this;
				while{true} do {
					_object setDir ((getDir _object)+1);
					sleep (4/360);
				};
			};
		} else {

			_dir = [_pos, _nextPos] call BIS_fnc_dirTo;
			_pos set[2,0.1];
			_object = _marker_object createVehicleLocal _pos;
			_object setpos _pos;
			_object setDir _dir;

			_object hideObject true;

			_markers = _markers + [_markerName];
			_checkpoints = _checkpoints + [_object];
		};

	};

};
player setVariable ["START_TIME",time,true];
player setVariable ["FINISHED",false,true];
{
	_object = _checkpoints select _forEachIndex;
	_object hideObject false;
	if((_forEachIndex+1) < count(_checkpoints)) then {
		_nextObject = _checkpoints select (_forEachIndex+1);
		_nextObject hideObject false;
	};
	waitUntil{
		player distance (getMarkerPos _x) < _activation_distance
	};
	_object hideObject true;

	_num = ([_x,"_"] call BIS_fnc_splitString) select 1;
	_number = call compile format["%1",_num];
	player setVariable ["lastMarker",_number,true];
	
} forEach _markers;
player setVariable ["FINISHED",true,true];
player setVariable ["LAP_TIME",time - (player getVariable ["START_TIME",0]),true];
player setVariable ["FINISH_TIME",time,true];
[player,"player_finished",false,false] call BIS_fnc_MP;
vehicle player engineOn false;
