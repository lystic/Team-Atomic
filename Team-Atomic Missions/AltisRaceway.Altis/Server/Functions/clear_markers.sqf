/*
	Name: Clear Markers
	Desc: Clears the markers from the previous round

*/
if(!isNil "MAP_MARKERS") then {
	_text = "";
	{
		_text = _text + format["deleteMarkerLocal '%1';",_x];
	} forEach MAP_MARKERS;
	_code = compile _text;
	[_code,"BIS_fnc_Spawn",true,false] call BIS_fnc_MP;
	_code = {
		{
			{deletevehicle _x;} forEach (player nearObjects [_x,1000]);
		} forEach MARKER_OBJECTS;
	};
	[_code,"BIS_fnc_Spawn",true,false] call BIS_fnc_MP;
};