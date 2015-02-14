key notecardQueryId;
string notecardName = "UUID of notecard";
integer notecardLine;

default {
	state_entry() {
		if (llGetInventoryKey(notecardName) == NULL_KEY)
		{
			llOwnerSay( "Notecard '" + notecardName + "' missing or unwritten");
			return;
		}
		notecardQueryId = llGetNotecardLine(notecardName, notecardLine);
	}
	
	dataserver(key query_id, string data)
	{
		if (query_id == notecardQueryId)
		{
			if (data == EOF)
			{
				llOwnerSay("Notecard loaded, read " + (string) notecardLine + " lines.");
			}
			else
			{
				++notecardLine;
				llOwnerSay("Line: " + (string) notecardLine + " " + data);
				notecardQueryId = llGetNotecardLine(notecardName, notecardLine);
			}
		}
	}
}
