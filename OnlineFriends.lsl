key notecardQueryId;
string notecardName = "UUID of notecard";
integer notecardLine;
list stridedFriendsList;
integer strideLength;

integer fncStrideCount(list lstSource, integer intStride)
{
  return llGetListLength(lstSource) / intStride;
}

list fncGetStride(list lstSource, integer intIndex, integer intStride)
{
  integer intNumStrides = fncStrideCount(lstSource, intStride);
  
  if (intNumStrides != 0 && intIndex < intNumStrides)
  {
    integer intOffset = intIndex * intStride;
    return llList2List(lstSource, intOffset, intOffset + (intStride - 1));
  }
  return [];
}

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
				state observe;
			}
			else
			{
				++notecardLine;
				llOwnerSay("Line: " + (string) notecardLine + " " + data);
				list stride = [data, FALSE, NULL_KEY];
				strideLength = llGetListLength(stride);
				stridedFriendsList += stride;
				notecardQueryId = llGetNotecardLine(notecardName, notecardLine);
			}
		}
	}
}

state observe {
	state_entry()
	{
		llSetTimerEvent(60);
	}
	timer()
	{
		length = fncStrideCount(stridedFriendsList, 2);
		integer i;
		for(i=0;i < length,i++) {
			list stride = fncGetStride(stridedFriendsList, i, 2);
			//llRequestAgentData(llList2Key(fncGetElement(stridedFriendsList, i, 0, 
		}
	}
}
