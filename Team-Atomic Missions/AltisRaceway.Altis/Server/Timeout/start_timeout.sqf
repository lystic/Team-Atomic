/*
	Name: Start Timeout
	Desc: Handles starting the timeout for others to finish the race

	Notes: this executes on all clients that do not have the variable FINISHED set to true
*/

[{if !(player getVariable ["FINISHED",false]) then {hint 'You have 30 seconds to finish the race!';};},"BIS_fnc_Spawn",true,false] call BIS_fnc_MP;
_timeout = true;
for "_i" from 1 to 30 do {
	_time = time + 1;
	waitUntil{(call isRoundOver) || time >= _time};
	if(call isRoundOver) exitWith {_timeout = false;};
};
if(_timeout) then {
	[] spawn end_timeout;
};