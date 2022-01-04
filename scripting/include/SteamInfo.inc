#if defined _SteamInfo_included
 #endinput
#endif
#define _SteamInfo_included

/**
 * Retrieves a value by the given key identifier via 'steam.inf'.
 *
 * @param key        	Key identifier.
 * @param buffer        Destination string buffer.
 * @param maxlen     	Maximum length of output string buffer.
 * 
 * @return           	True on success, false if the key isn't exists.
 */
native bool SteamInfo_GetValue(char[] key, char[] buffer, int maxlen);

/**
 * Retrieves a stringmap that contains the steam information extracted data.
 * Use StringMapSnapshot to find all the available keys.
 *
 * The StringMap must be freed via delete or CloseHandle().
 *
 * @return               StringMap handle filled with 'steam.inf' data.
 */
native StringMap SteamInfo_GetData();

#if !defined REQUIRE_PLUGIN
public __pl_SteamInfo_SetNTVOptional()
{
	MarkNativeAsOptional("SteamInfo_GetValue");
	MarkNativeAsOptional("SteamInfo_GetData");
}
#endif

public SharedPlugin __pl_SteamInfo = 
{
	name = "SteamInfo", 
	file = "SteamInfo.smx", 
#if defined REQUIRE_PLUGIN
    required = 1, 
#else
    required = 0, 
#endif
}; 