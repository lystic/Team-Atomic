/*
	Name: Is Round Over
	Desc: Returns true/false if the current round has ended
	
*/

_count = count finished_players;
_count2 = call count_players;
_val = (_count >= _count2);
_val;