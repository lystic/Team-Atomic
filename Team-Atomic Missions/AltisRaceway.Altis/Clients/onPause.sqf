[] spawn {
	waitUntil{!isNull (findDisplay 49)};
	disableserialization;
	while{!isNull (findDisplay 49)} do {
		_display = (findDisplay 49);
		_ctrl = _display displayCtrl 103;
		_ctrl ctrlSetText "Altis Raceway";
		_ctrl ctrlEnable false;
		_ctrl ctrlCommit 0;
		_ctrl = _display displayCtrl 1010;
		_ctrl ctrlSetText "By: Team-Atomic";
		_ctrl ctrlEnable false;
		_ctrl ctrlCommit 0;
		_ctrl = _display displayCtrl 122;
		_ctrl ctrlEnable false;
		_ctrl ctrlShow false;
		_ctrl ctrlSetposition [-1000,-1000,0,0];
		_ctrl ctrlCommit 0;
	};
};