if(isServer) then {
	[] execVM "Admin.sqf";
	[] execVM "Server\init.sqf";
};

if(!isDedicated) then {
	[] spawn {
		waitUntil{alive player};
		player allowDamage false;
		[] execVM "Admin.sqf";
	};
	player addAction ["Fix Kart",{_oldPos = getposatl vehicle player;vehicle player setVectorUp (surfaceNormal _oldPos);_oldPos set[2,(_oldPos select 2)+0.1]; vehicle player setPosATL _oldPos;},[],0,false,false,"","vehicle player != player"];
};