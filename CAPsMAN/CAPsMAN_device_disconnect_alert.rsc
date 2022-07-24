#### Bot Settings ####
:local bot ""
:local chatid ""
:local text ""

:local Time [/system clock get time];
:local Date [/system clock get date];
:local DeviceName [/system resource get board-name]
:local url ("https://api.telegram.org/bot" . $"bot" . "/sendMessage\?chat_id=" . $"chatid" . "&parse_mode=html&text=" . $"text")

/tool fetch url=$"url" keep-result=no