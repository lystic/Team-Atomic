============ Team-Atomic's Basic Anticheat - V1.4 ============
========================= By: Lystic =========================

Anticheat Features:
	- Anti-invisibility
	- File Scanning
	- Variable Scanning
	- Menu Detection
	- No Recoil Detection
	- Anti-NoGrass
	- Anti-NoClip
	- Anti-MapTeleport
	- Anti-GodMode

Admin Menu Features:
	- Vehicle Spawning
	- Teleporting
	- Server Clean Up
	- Teleport All
	- Kick
	- Disable/Enable Input
	- Logging
	- Player Markers
	- Vehicle Markers
	- Name Tags
	- God Mode
	- Spectating
	
Installation:
	1) place Anticheat.sqf inside your missions root directory
	2) place AdminMenu.sqf inside your missions root directory
	3) at the bottom of your missions init.sqf add the line: [] execVM "anticheat.sqf";
	4) Modify anticheat.sqf and change the admin uids list to include your admins
	5) Modify adminmenu.sqf and change the admin uids list to include admins with menu access
	
Change Log:
	[1.4] Latest Update
		- Added AH_fnc_MP protection to Admin Menu so it is further protected when being run while in standalone
		- Updated Admin Menu to use AH_fnc_MP
		
	[1.3] Spawning And Logging
		- Added Vehicle Spawning to the Admin Menu
		- Added Function Logging to the Admin Menu
		- Added Keybind for deleting vehicle and repairing them
		
	[1.2] Admin Menu Update
		- Added an admin menu to the anticheat
		- Added protection to the admin menu
		- Connected admin menu and anticheat
		- Enabled admin menu to be run without anticheat required
		
	[1.1] Critical Update
		- Added anti-invisibility
		- Added anti-mapteleport
		- Added anti-godmode
		- Added anti-noclip
		- Added anti-nograss
		- Fixed kicked client notification
		
	[1.0] Initial Release
		- Initial release of public anticheat
