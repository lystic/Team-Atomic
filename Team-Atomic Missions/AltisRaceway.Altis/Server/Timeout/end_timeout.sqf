/*
	Name: End Timeout
	Desc: Forces a round to end if the timeout for that round has ended

*/


if !(call isRoundOver) then {
	_alreadyFinished = count finished_players;
	_max = call count_players;
	_loops = _max - _alreadyFinished;
	if(_loops > 0) then {
		for "_i" from 1 to _loops do {
			finished_players = finished_players + [objnull];
			finished_times = finished_times + [-1];
		};
	};
};