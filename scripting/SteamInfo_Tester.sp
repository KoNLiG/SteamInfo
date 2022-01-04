#include <sourcemod>
#include <SteamInfo>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "SteamInfo - Tester", 
	author = "KoNLiG", 
	description = "Testing the functionality of SteamInfo API.", 
	version = "1.0.0", 
	url = "https://github.com/KoNLiG/SteamInfo"
};

public void OnPluginStart()
{
	StringMap steaminfo = SteamInfo_GetData();
	
	StringMapSnapshot steaminfo_snapshot = steaminfo.Snapshot();
	
	int key_size;
	char value[32];
	
	for (int current_key; current_key < steaminfo_snapshot.Length; current_key++)
	{
		// Get the buffer size for the current Key.
		key_size = steaminfo_snapshot.KeyBufferSize(current_key);
		
		// Create a buffer to store the current Key.
		char[] key = new char[key_size];
		
		// Get the current Snapshot.
		steaminfo_snapshot.GetKey(current_key, key, key_size);
		
		steaminfo.GetString(key, value, sizeof(value));
		
		PrintToServer("%s=%s", key, value);
	}
	
	/* Output:
	
	PatchVersion=1.38.1.3
	ClientVersion=1400
	SourceRevision=6979832
	VersionDate=Dec 27 2021
	ProductName=csgo
	appID=730
	ServerVersion=1400
	VersionTime=19:30:50 
	
	*/
	
	delete steaminfo_snapshot;
	
	delete steaminfo;
	
	char appID[8];
	SteamInfo_GetValue("appID", appID, sizeof(appID));
	PrintToServer("SteamInfo_GetValue(\"AppID\") = %s", appID);
	
	/* Output:
	
	SteamInfo_GetValue("AppID") = 730
	
	*/
} 