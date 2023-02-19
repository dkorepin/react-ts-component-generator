SuperStrict

Import MaxGUI.Drivers
Import brl.timerdefault
Import brl.textstream
Import brl.eventqueue


include "./lib/window.bmx";
include "./lib/events.bmx";

BuildMainWindow();

While WaitEvent()
	HandleEvents();
Wend

End