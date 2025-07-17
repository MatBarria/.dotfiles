#!/bin/bash

## Mount FNAL folders!
sshfs -p 22 mbarrial@cmslpc-el9.fnal.gov:/uscms_data/d1/mbarrial/ /home/truga/projects/nobackup_lpc -o auto_cache,reconnect 
#sshfs -p 22 mbarrial@cmslpc-el9.fnal.gov:/uscms_data/d1/mbarrial/ /home/truga/projects/nobackup_lpc -o auto_cache,reconnect,allow_other,default_permissions  

echo 'Folders nobackup and home mounted!'
