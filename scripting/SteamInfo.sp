#include <sourcemod>
#include <regex>

#pragma semicolon 1
#pragma newdecls required

// Contains the extracted data from steam.inf
StringMap g_SteamInfo;

public Plugin myinfo = 
{
	name = "SteamInfo", 
	author = "KoNLiG", 
	description = "Provides Steam Information API.", 
	version = "1.0.0", 
	url = "https://github.com/KoNLiG/SteamInfo"
};

public void OnPluginStart()
{
	// Initialize 'g_SteamInfo'
	if (!(g_SteamInfo = InitSteamInfo()))
	{
		SetFailState("Failed to properly initialize 'g_SteamInfo'");
	}
}

// API
public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	// bool SteamInfo_GetValue(char[] key, char[] buffer, int maxlength)
	CreateNative("SteamInfo_GetValue", Native_GetValue);
	
	// StringMap SteamInfo_GetData()
	CreateNative("SteamInfo_GetData", Native_GetData);
	
	RegPluginLibrary("SteamInfo");
	
	return APLRes_Success;
}

// Native Callbacks
int Native_GetValue(Handle plugin, int numParams)
{
	// Param 1: 'key'
	char key[32];
	GetNativeString(1, key, sizeof(key));
	
	// Param 3: 'maxlen'
	int maxlen = GetNativeCell(3);
	
	// Param 2: 'buffer' (Pre-initialized buffer)
	char[] buffer = new char[maxlen];
	
	bool success = g_SteamInfo.GetString(key, buffer, maxlen);
	
	SetNativeString(2, buffer, maxlen);
	
	return success;
}

any Native_GetData(Handle plugin, int numParams)
{
	return view_as<StringMap>(CloneHandle(g_SteamInfo, plugin));
}

// g_SteamInfo Initializer
StringMap InitSteamInfo()
{
	File steam_info = OpenFile("steam.inf", "r");
	if (!steam_info)
	{
		return null;
	}
	
	// Extract file data using regex expression: '([a-zA-Z]+)=(.+)'
	Regex rgx = new Regex("([a-zA-Z]+)=(.+)");
	if (!rgx)
	{
		return null;
	}
	
	// Store 'steam.inf' raw text, and close the file handle.
	char file_str[PLATFORM_MAX_PATH];
	steam_info.ReadString(file_str, sizeof(file_str));
	delete steam_info;
	
	rgx.MatchAll(file_str);
	
	StringMap data = new StringMap();
	char key[16], value[16];
	
	for (int current_match; current_match < rgx.MatchCount(); current_match++)
	{
		rgx.GetSubString(1, key, sizeof(key), current_match);
		rgx.GetSubString(2, value, sizeof(value), current_match);
		
		TrimString(value);
		data.SetString(key, value);
	}
	
	delete rgx;
	return data;
} 