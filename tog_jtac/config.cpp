class CfgPatches{
	class TOG_jtac
	{
		version = 1.6.5;
		author = "Sushi";
		units[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"A3_Modules_F","CBA_main"};
	};
};

#include <TOG_jtac_Defines.hpp>
#include <TOG_jtac_TAB.hpp>
#include <TOG_jtac_TAB_trans.hpp>
#include <TOG_jtac_TAB_abort.hpp>

class CfgFactionClasses
{
	class TOG_jtac_modules {
		displayName = "JTAC Modules";
		priority = 5000;
		side = 7;
	};
};
//Definicje funkcji
class CfgFunctions 
{
	class TOG
	{
		class JTAC
		{
			file = "\tog_jtac\functions";
			class jtac_init{description = "Enable JTAC modules";};
			class jtac_init_plane{description = "Inits planes for jtac CAS";};
			class jtac_init_heli{description = "Inits heli for jtac CAS";};
			class jtac_init_transport{description = "Inits heli for jtac Transport";};
			class jtac_CAS_onMapClick{description = "";};
			class jtac_Trans_onMapClick{description = "";};
			class jtac_CAS_callsign{description = "";};
			class jtac_Trans_callsign{description = "";};
			class jtac_Trans_sequrity{description = "";};
			class jtac_CAS_vehNum{description = "";};
			class jtac_Trans_vehNum{description = "";};
			class jtac_CAS_changeMrkDir{description = "";};
			class jtac_CAS_markType{description = "";};
			class jtac_Trans_markType{description = "";};
			class jtac_CAS_request{description = "";};
			class jtac_Trans_request{description = "";};
			class jtac_Trans_spawnVeh{description = "";};
			class jtac_CAS_spawnPlane{description = "";};
			class jtac_Rtb{description = "";};
			class jtac_CAS_direct{description = "";};
			class jtac_CAS_launchGuided{description = "";};
			class jtac_CAS_launchMissile{description = "";};
			class jtac_ifalive{description = "";};
			class jtac_tablet_start{description = "";};
			class jtac_showTab_Trans{description = "";};
			class jtac_showTab_CAS{description = "";};
			class jtac_Trans_vehGo{description = "";};
			class jtac_Trans_vehGoRemoveAction{description = "";};
			class jtac_Abort_request{description = "";};
			class jtac_Abort_check{description = "";};
			class jtac_showTab_Abort{description = "";};
			class jtac_Abort_track{description = "";};
			class jtac_Search_Mark{description = "";};
			class jtac_CAS_attack_plane{description = "";};
			class jtac_CAS_attack_heli{description = "";};
			class jtac_remove_wp_all{description = "";};
			class jtac_break_pass{description = "";};
			class jtac_openDoor{description = "";};
			class jtac_execOnOperator{description = "";};
			class jtac_client_storeAction{description = "";};
			class jtac_client_removeActions{description = "";};
			class jtac_client_addSmokeAction{description = "";};
			class jtac_client_addBreakPassActions{description = "";};
			class jtac_client_addHeliMissileActions{description = "";};
			class jtac_server_confirmSmoke{description = "";};
			class jtac_server_setPassState{description = "";};
			class jtac_getDirectFireWeapons{description = "";};
			class jtac_addTabletAction{description = "";};
			class jtac_getAirSpawnPos{description = "";};
			class jtac_operatorGroupId{description = "";};
		};
	};
};

//Definicje modułów
class CfgVehicles {
	class Logic;
	class Module_F: Logic
	{
		class ArgumentsBaseUnits
		{
			class Units;
		};
		class ModuleDescription
		{
			class AnyBrain;
			class AnyPlayer;
		};
	};
		
	//Modół enable JTAC
	class TOG_module_jtac_init: Module_F
		{	
			Author="Sushi";
			scope = 2; 
			displayName = "[JTAC] Enable"; 
			category = "TOG_jtac_modules";
			side = 7;
			function = "TOG_fnc_jtac_init";
			functionPriority = 5;
			isGlobal = 1;
			isPersistent = 0;
			isTriggerActivated = 0;
			isDisposable = 0;
			class Arguments: ArgumentsBaseUnits
			{
				class Units: Units {};
				class TOG_jtac_Respawn
				{
					displayName = "Respawn delay"; // Argument label
					description = "Respawn delay for destroyed units - 0 means no respawn"; // Tooltip description
					typeName = "NUMBER"; 
					defaultValue = 0;
				};
				class jtacSunrise
				{
					displayName = "Sunrise (Hour)"; // Argument label
					description = "Hour of sunrise (0-23) - for night target marking"; // Tooltip description
					typeName = "NUMBER"; 
					defaultValue = 5;
				};
				class jtacSunset
				{
					displayName = "Sunset (Hour)"; // Argument label
					description = "Hour of sunset (0-23) - for night target marking"; // Tooltip description
					typeName = "NUMBER"; 
					defaultValue = 22;
				};
				
			};
			
			class ModuleDescription
			{
				description = "Enable JTAC modules"; // Short description, will be formatted as structured text
				sync[] = {"TOG_module_jtac_init_plane"}; // Array of synced entities (can contain base classes)
		 
				class TOG_module_jtac_init_plane
				{
					description[] = { // Multi-line descriptions are supported
						"[CAS]Fixed-wing",
						"Set settings for CAS fixed wings group"
					};
					position = 0; // Position is taken into effect
					direction = 0; // Direction is taken into effect
					optional = 0; // Synced entity is optional
					duplicate = 0; // Multiple entities of this type can be synced
					synced[] = {}; // Pre-define entities like "AnyBrain" can be used. See the list below
				};
				
			};
		};
	
	
		
	//Modół init planes
	class TOG_module_jtac_init_plane: Module_F
		{	
			Author="Sushi";
			scope = 2; 
			displayName = "[CAS]Fixed-wing"; 
			category = "TOG_jtac_modules";
			side = 7;
			function = "TOG_fnc_jtac_init_plane";
			functionPriority = 10;
			isGlobal = 0;
			isPersistent = 0;
			isTriggerActivated = 0;
			isDisposable = 0;
			class Arguments: ArgumentsBaseUnits
			{
				class Units: Units {};
				class callsign
				{
					displayName = "Callsign"; 
					description = "Callsign for CAS group, e.g: Alpha"; 
					typeName = "STRING"; 
					defaultValue = "Alpha";
				};
				class vehicleClass
				{
					displayName = "Plane"; 
					description = "Select plane class";
					typeName = "STRING"; 
					class values
					{
					class NATO {name = "[NATO] A-164 Wipeout"; value = "B_Plane_CAS_01_F"; default = 1;};
					class CSAT {name = "[CSAT] To-199 Neophron"; value = "O_Plane_CAS_02_F";};
					class AAF {name = "[AAF] A 143 Buzzard"; value = "I_Plane_Fighter_03_CAS_F";};
					class CUSTOM {name = "Custom"; value = "custom";};
					};
				};
				class vehicleClassCustom
				{
					displayName = "Custom plane"; 
					description = "type custom plane class. Field above must be set to custom.";
					typeName = "STRING"; 
					
				};
				class maxCasNumber
				{
					displayName = "Max CAS request"; // Argument label
					description = "How many times this group can be requested"; // Tooltip description
					typeName = "NUMBER"; // Value type, can be "NUMBER", "STRING" or "BOOL"
					defaultValue = 4;
				};
				class maxPassNum
				{
					displayName = "Max pass number"; // Argument label
					description = "How many pass unit can make in one request"; // Tooltip description
					typeName = "NUMBER"; 
					defaultValue = 2;
				};
				
			};
			
			class ModuleDescription
			{
				description = "Set settings for CAS fixed wings group"; // Short description, will be formatted as structured text
				sync[] = {"TOG_module_jtac_init"}; // Array of synced entities (can contain base classes)
		 		position = 1;
				class TOG_module_jtac_init
				{
					description[] = { // Multi-line descriptions are supported
						"[JTAC] Enable",
						"Every CAS or Transport module must be sync with [JTAC] Enable module"
					};
					position = 0; // Position is taken into effect
					direction = 0; // Direction is taken into effect
					optional = 0; // Synced entity is optional
					duplicate = 0; // Multiple entities of this type can be synced
					synced[] = {}; // Pre-define entities like "AnyBrain" can be used. See the list below
				};
				
			};
		}; 
		
	//Modół init heli
	class TOG_module_jtac_init_heli: Module_F
		{	
			Author="Sushi";
			scope = 2; 
			displayName = "[CAS]rotary-wings"; 
			category = "TOG_jtac_modules";
			side = 7;
			function = "TOG_fnc_jtac_init_heli";
			functionPriority = 10;
			isGlobal = 0;
			isPersistent = 0;
			isTriggerActivated = 0;
			isDisposable = 0;
			class Arguments: ArgumentsBaseUnits
			{
				class Units: Units {};
				class callsign
				{
					displayName = "Callsign"; 
					description = "Callsign for CAS group, e.g: Alpha"; 
					typeName = "STRING"; 
					defaultValue = "Bravo";
				};
				class vehicleClass
				{
					displayName = "Heli"; 
					description = "Select heli class";
					typeName = "STRING"; 
					class values
					{
					class NATO {name = "[NATO] AH-99 Blackfoot"; value = "B_Heli_Attack_01_F"; default = 1;};
					class NATOO {name = "[NATO] AH-9 Pawnee"; value = "B_Heli_Light_01_armed_F";};
					class CSAT {name = "[CSAT] Mi-48 Kajman"; value = "O_Heli_Attack_02_F";};
					class AAF {name = "[AAF] WY-55 Hellcat"; value = "I_Heli_light_03_F";};
					class CUSTOM {name = "Custom"; value = "custom";};
					};
				};
				class vehicleClassCustom
				{
					displayName = "Custom heli"; 
					description = "type custom heli class. Field above must be set to custom.";
					typeName = "STRING"; 
					
				};
				class maxCasNumber
				{
					displayName = "Max CAS request"; // Argument label
					description = "How many times this group can be requested"; // Tooltip description
					typeName = "NUMBER"; // Value type, can be "NUMBER", "STRING" or "BOOL"
					defaultValue = 4;
				};
				class maxAt
				{
					displayName = "Max AT"; // Argument label
					description = "How many AT rockets carry each Heli"; // Tooltip description
					typeName = "NUMBER"; // Value type, can be "NUMBER", "STRING" or "BOOL"
					defaultValue = 2;
				};
				class maxAp
				{
					displayName = "Max AP"; // Argument label
					description = "How many AP rockets carry each Heli"; // Tooltip description
					typeName = "NUMBER"; // Value type, can be "NUMBER", "STRING" or "BOOL"
					defaultValue = 4;
				};
				class maxPassNum
				{
					displayName = "Max pass number"; // Argument label
					description = "How many pass unit can make in one request"; // Tooltip description
					typeName = "NUMBER"; 
					defaultValue = 2;
				};
				
			};
			
			class ModuleDescription
			{
				description = "Set settings for CAS fixed wings group"; // Short description, will be formatted as structured text
				sync[] = {"TOG_module_jtac_init"}; // Array of synced entities (can contain base classes)
		 		position = 1;
				class TOG_module_jtac_init
				{
					description[] = { // Multi-line descriptions are supported
						"[JTAC] Enable",
						"Every CAS or Transport module must be sync with [JTAC] Enable module"
					};
					position = 0; // Position is taken into effect
					direction = 0; // Direction is taken into effect
					optional = 0; // Synced entity is optional
					duplicate = 0; // Multiple entities of this type can be synced
					synced[] = {}; // Pre-define entities like "AnyBrain" can be used. See the list below
				};
				
			};
		};
		
	//Modół init trans
	class TOG_module_jtac_init_trans: Module_F
		{	
			Author="Sushi";
			scope = 2; 
			displayName = "[TRANSPORT]rotary-wings"; 
			category = "TOG_jtac_modules";
			side = 7;
			function = "TOG_fnc_jtac_init_transport";
			functionPriority = 10;
			isGlobal = 0;
			isPersistent = 0;
			isTriggerActivated = 0;
			isDisposable = 0;
			class Arguments: ArgumentsBaseUnits
			{
				class Units: Units {};
				class callsign
				{
					displayName = "Callsign"; 
					description = "Callsign for transport group, e.g: Alpha"; 
					typeName = "STRING"; 
					defaultValue = "Charlie";
				};
				class vehicleClass
				{
					displayName = "Heli"; 
					description = "Select heli class";
					typeName = "STRING"; 
					class values
					{
					class NATO {name = "[NATO] UH-80 Ghost Hawk"; value = "B_Heli_Transport_01_F"; default = 1;};
					class NATOO {name = "[NATO] MH-9 Hummingbird"; value = "B_Heli_Light_01_F";};
					class CSAT {name = "[CSAT] PO-30 Orca"; value = "O_Heli_Light_02_F";};
					class AAF {name = "[AAF] CH-49 Mohawk"; value = "I_Heli_Transport_02_F";};
					class CUSTOM {name = "Custom"; value = "custom";};
					};
				};
				class vehicleClassCustom
				{
					displayName = "Custom heli"; 
					description = "type custom heli class. Field above must be set to custom.";
					typeName = "STRING"; 
					
				};
				class vehicleClassE
				{
					displayName = "Escort Heli"; 
					description = "Select escort heli class";
					typeName = "STRING"; 
					class values
					{
					class NATOE {name = "[NATO] AH-99 Blackfoot"; value = "B_Heli_Attack_01_F"; default = 1;};
					class NATOOE {name = "[NATO] AH-9 Pawnee"; value = "B_Heli_Light_01_armed_F";};
					class CSATE {name = "[CSAT] Mi-48 Kajman"; value = "O_Heli_Attack_02_F";};
					class AAFE {name = "[AAF] WY-55 Hellcat"; value = "I_Heli_light_03_F";};
					class CUSTOME {name = "Custom"; value = "custom";};
					};
				};
				class vehicleClassCustomE
				{
					displayName = "Custom escort heli"; 
					description = "type custom escort heli class. Field above must be set to custom.";
					typeName = "STRING"; 
					
				};
				class maxTransNumber
				{
					displayName = "Max transport request"; // Argument label
					description = "How many times this group can be requested"; // Tooltip description
					typeName = "NUMBER"; // Value type, can be "NUMBER", "STRING" or "BOOL"
					defaultValue = 10;
				};
				
				
			};
			
			class ModuleDescription
			{
				description = "Set settings for transport fixed wings group"; // Short description, will be formatted as structured text
				sync[] = {"TOG_module_jtac_init"}; // Array of synced entities (can contain base classes)
		 		position = 1;
				class TOG_module_jtac_init
				{
					description[] = { // Multi-line descriptions are supported
						"[JTAC] Enable",
						"Every CAS or Transport module must be sync with [JTAC] Enable module"
					};
					position = 0; // Position is taken into effect
					direction = 0; // Direction is taken into effect
					optional = 0; // Synced entity is optional
					duplicate = 0; // Multiple entities of this type can be synced
					synced[] = {}; // Pre-define entities like "AnyBrain" can be used. See the list below
				};
				
			};
		};
		
		

};