#### Modify these values to match your requirements ####
 
#Your email address to receive the backups
:local toemail ""
 
#The From address (you can use your own address if you want)
:local fromemail ""
 
#A mail server your machines can send through
:local emailserver ""
 
############## Don’t edit below this line ##############
 
:local sysname [/system identity get name]
:local textfilename
:local backupfilename
:local time [/system clock get time]
:local date [/system clock get date]
:local newdate "";

:for i from=0 to=([:len $date]-1) do={ :local tmp [:pick $date $i];
    :if ($tmp !="/") do={ :set newdate "$newdate$tmp" }
    :if ($tmp ="/") do={}
}

#check for spaces in system identity to replace with underscores
:if ([:find $sysname " "] !=0) do={
    :local name $sysname;
    :local newname "";
    :for i from=0 to=([:len $name]-1) do={ :local tmp [:pick $name $i];
        :if ($tmp !=" ") do={ :set newname "$newname$tmp" }
        :if ($tmp =" ") do={ :set newname "$newname_" }
    }
    :set sysname $newname;
}

:set textfilename ("Monthly" . "-" . $"newdate" . "-" . $"sysname" . ".rsc")												  
:set backupfilename ("Monthly" . "-" . $"newdate" . "-" . $"sysname" . ".backup")

:execute [/export file=$"textfilename"]									   
:execute [/system backup save name=$"backupfilename"]
#Allow time for export to complete
:delay 2s
 
#email copies
:log info "Emailing backups"
/tool e-mail send to=$"toemail" from=$"fromemail" server=[:resolve $emailserver] port=25 subject="[Config Backup Text]" file=$"textfilename"																																			  
#Send as different subjects to force GMail to treat as new message thread.
:local time [/system clock get time]
/tool e-mail send to=$"toemail" from=$"fromemail" server=[:resolve $emailserver] port=25 subject="[Config Backup]" file=$"backupfilename"
 
#Allow time to send
:delay 10s
 
#delete copies
/file remove $textfilename						  
/file remove $backupfilename