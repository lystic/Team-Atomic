/*
	Name: Road Selector
	Desc: Handles random race track selection and wall generation

	Parameters:
		_this select 0: number of roads to select (integer) (optional)
		_this select 1: center loaction to look for roads (2D or 3D array) (optional)
		_this select 2: radius to look for roads (integer) (optional)
		_this select 3: generate walls or no (true/false) (optional)
		_this select 4: object to use for the wall (string) (optional)

*/
_numRoads = [_this, 0, 20,[0]] call BIS_fnc_param;	
_center = [_this,1,[0,0],[[]],[2,3]] call BIS_fnc_param;
_radius = [_this,2,100000,[0]] call BIS_fnc_param;
_generateWall = [_this,3,false,[true]] call BIS_fnc_param;
_typeOfWall = [_this,4,"Land_CncWall4_F",[""]] call BIS_fnc_param;

_roads = _center nearRoads _radius;
_road = _roads select (floor(random(count(_roads))));
_roadList = [_road];
if(_generateWall) then {
	{
		deleteVehicle _x;
	} foreach ([0,0,0] nearObjects [_typeOfWall,100000]);
};
for "_i" from 1 to _numRoads do {
	_connected = roadsConnectedTo _road;
	_foundVal = false;
	{
		if !(_x in _roadList) exitWith {
			//generate a wall
			if(_generateWall) then {
				_road setDir ([_road,_x] call BIS_fnc_DIRto);//set the roads direction towards the next road
				_bounds = boundingBoxReal _road;
				_minx = (_bounds select 0) select 0;
				_maxx = (_bounds select 1) select 0;
				_miny = (_bounds select 0) select 1;
				_maxy = (_bounds select 1) select 1;
				_center = boundingCenter _road;
				_centery = _center select 1;
				_centerx = _center select 0;
				_front = _road modelToWorld [_centerx,_maxy,0];
				_rear = _road modelToWorld [_centerx,_miny,0];
				_dir = [_front,_rear] call BIS_fnc_DIRto;
				_dir = _dir + 90;
				_repetitions = ceil(_maxy-_miny);
				_max = ceil(_miny+_repetitions);
				for "_y" from floor(_miny) to _max step 3 do {
					_left = _road modelToWorld [_maxx,_y,0];
					_right = _road modelToWorld [_miny,_y,0];
					_left set[2,0];
					_right set[2,0];
					_obj = _typeOfWall createVehicle _left;
					_obj setVectorUp surfaceNormal _left;
					_obj setdir _dir;
					_obj setpos _left;					
					_obj = _typeOfWall createVehicle _right;
					_obj setVectorUp surfaceNormal _right;
					_obj setdir _dir;
					_obj setpos _right;
				};
			};
			_road = _x;
			_roadList = _roadList + [_road];
			_foundVal = true;
		};
	} forEach _connected;
	if (!_foundVal) exitWith {_road setDir getdir (_roadList select (count(_roadList)-2))};//set the last roads direction to the same that the previous road had
};
//if there was a bad selection than lets repick
if(count(_roadList) <= floor(_numRoads/3)) then {
	_roadList = _this call road_selector;
};
_roadList;