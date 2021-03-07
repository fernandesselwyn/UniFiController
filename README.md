# UniFiController
Notes on unifi controller setup on Debian
#Prerequsites 
#JavaJRE1.8
#MongoDB 3.6.x
#and all their dependencies!

#The write up on Unbiquti is pretty straight forward
Read this https://help.ubnt.com/hc/en-us/articles/220066768-UniFi-How-to-Install-and-Update-via-APT-on-Debian-or-Ubuntu

Once you add the repo the actual install is straight forward.

Since the repo is in place upgrades are quite straight forward with an apt upgrade BUT as any cautious admin I want to control when the controller is upgrades. 
To that end I put a hold in apt to prevent auto upgrade when regular patching occurs.

Things to do after the install:

-Secure the password
-Possibly tie it to MFA with your UniFi.com account (I keep things local)
-Setup SSH key exchange 
-Setup backup location and backup schedule
-Cron job to SCP the backup externally, encrypted. 
