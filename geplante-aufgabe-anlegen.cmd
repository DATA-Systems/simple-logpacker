REM /* POC only */
schtasks /create /tn pack_logs /tr "c:\Program Files\scripts\pack_logs.cmd" /sc weekly /mo 6 /s %computername% /u .admin
