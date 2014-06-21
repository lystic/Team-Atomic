/*
	Name: Count Players
	Desc: Returns the number of players alive on the map

*/
_count2 = 0;
{
	if(isPlayer _x) then {
		_count2 = _count2 + 1;
	};
} forEach allunits;
_count2;