local varMAC
:local varComment
:local varStatus
:local varSignal
:local varInterface

:foreach i in=[/interface/wifi access-list find where comment~"^SHP-.*"] do={
     :set varMAC [/interface/wifi access-list get $i "mac-address"]
     :set varComment [/interface/wifi access-list  get $i "comment"]
     :if ([:len [/interface/wifi registration-table find where mac-address=$varMAC] ] != 0 ) do={
       :set varStatus 1
       :local regID [/interface/wifi registration-table find where mac-address="$varMAC"]
       :set varSignal [/interface/wifi registration-table get $regID "signal"]
       :set varInterface [/interface/wifi registration-table get $regID "interface"]
     } else={
       :set varStatus 0
       :set varSignal 0
       :set varInterface "none"
     } 
     :set varComment [:pick $varComment (4) ([:len $varComment])]
     /iot mqtt publish broker="SHC" retain=yes message=$varComment topic="mikrotik/presence/$varMAC/name"
     /iot mqtt publish broker="SHC" retain=no message=$varStatus topic="mikrotik/presence/$varMAC/occupancy"
     /iot mqtt publish broker="SHC" retain=no message=$varSignal topic="mikrotik/presence/$varMAC/signal"
     /iot mqtt publish broker="SHC" retain=no message=$varInterface topic="mikrotik/presence/$varMAC/interface" 
}
