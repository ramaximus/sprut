:local varMAC
:local varComment
:local varStatus
:local varSignal
:local varInterface

:foreach i in=[/caps-man access-list find comment ~ "^SHP-.*"] do={
     :set varMAC [/caps-man access-list  get $i mac-address]
     :set varComment [/caps-man access-list  get $i comment]
     :if ([:len [/caps-man registration-table find mac-address=$varMAC] ] != 0 ) do={    
       :set varStatus 1
       :local regID [/caps-man registration-table find mac-address=$varMAC]
       :set varSignal [/caps-man registration-table get $regID rx-signal]
       :set varInterface [/caps-man registration-table get $regID interface]
} else={
       :set varStatus 0
       :set varSignal 0
       :set varInterface "none"
     } 
 :set varComment [:pick $varComment (4) ([:len $varComment])]
 /iot mqtt publish broker="spruthub" retain=yes message=$varComment topic="mikrotik/presence/$varMAC/name"
 /iot mqtt publish broker="spruthub" retain=no message=$varStatus topic="mikrotik/presence/$varMAC/occupancy"
 /iot mqtt publish broker="spruthub" retain=no message=$varSignal topic="mikrotik/presence/$varMAC/signal"
 /iot mqtt publish broker="spruthub" retain=no message=$varInterface topic="mikrotik/presence/$varMAC/interface" 
}
