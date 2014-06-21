/*
	Name: Player Finished
	Desc: Handles players finishing the current race

	Parameters:
		_this: object that finished the race

	Notes: use [player,"player_finished",false,false] call BIS_fnc_MP to execute this
*/
private ["_place","_code"];
if(call isRoundOver) exitWith {};
finished_players = finished_players + [_this];
finished_times = finished_times + [_this getVariable ["LAP_TIME",-1]];
_place = count(finished_players);
_code = compile format["hint 'You are the #%1 person to finish!';",_place];
[_code,"BIS_fnc_Spawn",_this,false] call BIS_fnc_MP;
if(_place == 1) then {
	[] spawn start_timeout;
};