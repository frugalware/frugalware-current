; Audio
(Parameter.set 'Audio_Method 'linux16audio)
;(Parameter.set 'Audio_Method 'esdaudio)
;(Parameter.set 'Audio_Method 'mplayeraudio)
;(Parameter.set 'Audio_Method 'sunaudio)

; For a list of voices, look in /usr/lib/festival/voices/
; To use the mbrola voices, you must emerge the 'mbrola' package
; us1_mbrola is my (eradicator) personal favorite voice.
;(voice_us1_mbrola)

; Maximum number of clients on the server
(set! server_max_clients 10)

; Server port
(set! server_port 1314)

; Log file location
(set! server_log_file "/var/log/festival.log")

; Set the server password
(set! server_passwd nil)

; Server access list (hosts)
(set! server_access_list '("[^.]+" "127.0.0.1" "localhost.*" "192.168.*"))

; Server deny list (hosts)
(set! server_deny_list nil)

