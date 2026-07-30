# ***ALOSToy Installer***



This is the ALOSToy Installer. The foundation to install ALOSToy v1.0 Standard or Extended.



##### Your **ultimate** USB to **rescue** a broken pc.



## Comes in two editions:



ALOSToy Standard



ALOSToy Extended



### **Streamlined, Modern, Packed**



*By Aarav Katariya*



# ***A Helpful Guide To The ALOSToy Installer (Like a Kickstart lol.)***



**ALOSToy Installer** is a bat installer only for Windows. (I will not make a Linux version. Sorry!!!)



## **What can I do? What is in this installer?**

* You can select an edition.

  * Standard
  * Extended

If you want, you can grab the OSimages extensions as well for the standard version. (Standard With Extensions)

And you can install **ALOSToy** on your USB drive, turning it into a bootable Ventoy drive.



## **Requirements To Get Going**

* Windows 10 or Windows 11 (Make sure it is build 17763+! Run winver to find the build.)
* PowerShell
* curl
* Internet access to download tools.esd, Ventoy and ALOSToy!
* Admin rights, so that we can do elevated operations. (THAT INCLUDES FORMATTING!!! :O)
* A tools.esd file which extracts to 24 files in %Root%bin.

# **Download the installer from releases first and then follow instructions.**


## **Installation**

1. Run **ALOSTOY-INSTALLER.BAT**.
2. Wait, obviously.
3. Accept EULA.
4. Accept Antivirus Warning.
5. You will see a main menu. Choose out of 7 buttons

   1. Install ALOSToy Standard
   2. Install ALOSToy Extended
   3. Install Extensions For ALOSToy Standard (Currently <True or False>)
   4. Verifiy Your Installation
   5. Delete Leftover Verfication Databases
   6. Quit The Installer
   7. Look Into The Installer (This one will look jarring because you get to see inside **ALOSTOY-INSTALLER.BAT**.)
6. Accept license terms of the product.
7. Wait for the installer to fetch the latest version.
8. Choose a drive. (BE CAREFUL!!!)
9. Confirm that drive.
10. Say Yes or No to GPT and Secure Boot.
11. Install Ventoy
12. Reconfirm drive.
13. Download the main files.
14. Wait for download.
15. Wait for extract.
16. Done!



**ALOSTOY-INSTALLER.BAT** is the file to run.



## **I NEED HELP!**

No worries! Use one of these to see the help or press H on the main menu with the 7 buttons. (Casing does not matter. Press H or h.)
```
ALOSTOY-INSTALLER.BAT /Help
ALOSTOY-INSTALLER.BAT /H
ALOSTOY-INSTALLER.BAT /?
```


You can also use -Help, -H, -?, or --Help, --H, --?.


If you add either:
/InstallGuide
-InstallGuide
--Install-Guide
to your help command line. Eg:
```
ALOSTOY-INSTALLER.BAT /? /InstallGuide
ALOSTOY-INSTALLER.BAT -? -InstallGuide
ALOSTOY-INSTALLER.BAT --? --Install-Guide
```


Please note, this help is for the command-line, is very detailed and it spans 10 PAGES!



## **Does this support command line arguments?**

Yes! It does. Check them here.



### **Custom logfile**

By default, **ALOSTOY-INSTALLER.BAT** logs to ALOSToy-Installer.log in the root directory. You can actually change that if you desire to.



```
**ALOSTOY-INSTALLER.BAT** /LogFile C:\\Logs\\ALOSToy-Installer.log
```



You can also use -LogFile or --Log-File.



### **Choose a Ventoy version**



```
**ALOSTOY-INSTALLER.BAT** /VentoyVersion 1.1.12
```



Ensure your format is of **1.X.XX** or else it is invalid.



You can also use -VentoyVersion or --Ventoy-Version.



### **Ventoy Download Mode**



```
**ALOSTOY-INSTALLER.BAT** /DownloadVentoyVersion 1.1.12 /SaveLocation C:\\Downloads
```



You can even request **interactive** selections too!



```
**ALOSTOY-INSTALLER.BAT** /DownloadVentoyVersion 1.1.12 /SaveLocation Prompt
```



You can even input **"Latest"** to grab the latest version.

The above examples will work with **Latest** as your selected Ventoy version.



You can also use -DownloadVentoyVersion and -SaveLocation or --Download-Ventoy-Version and --Save-Location.



## **Product Selection**



```
**ALOSTOY-INSTALLER.BAT** /Product Standard


**ALOSTOY-INSTALLER.BAT** /Product Standard+Extensions


**ALOSTOY-INSTALLER.BAT** /Product Extended
```



The following examples can be used to select a product automatically.



**THE INSTALLER WILL EXIT ON ANY SUCCESS OR ERROR!!!!**



You can also use -Product or --Product.



## **ALOSToy Banner On Start And Completion:**

By default, you see a logo branding show in the current console window and not again. You can actually control it.

You choose to never see it or always see it.



The following example never shows the logo branding:



```
**ALOSTOY-INSTALLER.BAT** /NoBanner

```


The following example always shows the logo branding:



```
**ALOSTOY-INSTALLER.BAT** /ForceBanner
```



However, combining both parameters (regardless of order) makes the force banner option take precedence over the no banner option. (It gets annoying pretty quick.)



You can also use:

\-NoBanner or --No-Banner

\-ForceBanner or --Force-Banner



## **Update Control**

There is an updater in **ALOSTOY-INSTALLER.BAT** that checks for the latest version and lets **YOU** choose whether to update or not.



Specifying **NoUpdate** tells the installer **not** to check for or apply updates to the installer. Useful if you believe the current version is fine for you.



Example:

```
**ALOSTOY-INSTALLER.BAT** /NoUpdate
```



Specifying **ForceUpdate** tells the installer to update to the newest or current version regardless. Useful for accidentally modifying **ALOSTOY-INSTALLER.BAT** and then needing to revert back.



Example:

```
**ALOSTOY-INSTALLER.BAT** /ForceUpdate
```


Specifying **AutoUpdate** tells the installer to automatically apply the latest update if a new version is found.


Example:

```
**ALOSTOY-INSTALLER.BAT** /AutoUpdate
```


You can also use:

\-NoUpdate or --No-Update

\-ForceUpdate or --Force-Update

\-AutoUpdate or --Auto-Update



## **Argument rules (VERY IMPORTANT!!!)**

* Any and all arguments are case-insensitive by default. I know.
* You are only able to pick from one prefix:

  * /
  * \-
  * \-- <---- Picking this prefix makes all arguments case-sensitive.
* Never ever mix a prefix. Chose "/"? Use "/" only. Same for the other prefixes.



A good example:



```
**ALOSTOY-INSTALLER.BAT** /Product Standard /NoBanner <---- Works
```



A bad example:



```
**ALOSTOY-INSTALLER.BAT** /Product Standard --No-Banner <---- Throws an error.
```



You do need to note that once you use the -- prefix, you then have to type it in **exactly as shown**. Arguments become **case-sensitive** once used. It is great right? I made a new function for it.



The **NoUpdate** and **ForceUpdate** arguments are compatible with all other arguments except themselves.



**ALOSTOY-INSTALLER.BAT** /NoUpdate /ForceUpdate will **NOT** work. Same for the other way round.

## **Troubleshooting**

### "No. You must install PowerShell."

Check PowerShell existence, add it to path, reset path, check that you are not using WinPE.

### "No. You must install curl."

Run "where curl" into Command Prompt. If it shows a location like C:\\Windows\\System32\\curl.exe, that is good. If not, go to https://curl.se to download and install it.

### "Unsupported OS version found."

You are using an old Windows 10 or a legacy version like:

* Windows XP

  * RTM
  * Service Pack 1
  * Service Pack 2
  * Service Pack 3
  * x64 Edition (rare back in those days!)
* Windows Vista

  * RTM
  * Service Pack 1
  * Service Pack 2
* Windows 7

  * RTM
  * Service Pack 1 (May 2011 - January 2020)
* Windows 8 (⊙x⊙;)
* Windows 8.1

  * RTM
  * Update 1
  * Update 2 (Actually August 2014 Update)
  * Update 3
* Windows 10

  * RTM (Threshold 1)
  * November Update (Threshold 2)
  * Anniversary Update (Redstone 1)
  * Creators Update (Redstone 2)
  * Fall Creators Update (Redstone 3)
  * April 2018 Update (Redstone 4)

Any system running Windows 10 October 2018 Update (Redstone 5) or later as well as any Windows 11 system is fine.

### "Do not directly run this as admin."

The error speaks for itself. Just make sure you did not **right-click and click "Run As Administrator"**. What that actually does is **forcibly override** the working directory and set it to %SystemRoot%\\System32.



You can run **ALOSTOY-INSTALLER.BAT** in System32 though. Just do not run the program directly with %SystemRoot%\\System32 as the working directory if it is not located there.

### "Relaunching as an administrator."

Totally normal thing. Just click OK and accept the User Account Control prompt.

### "I see you tried to download a depreciated Ventoy version."

The author of Ventoy (longpanda) depreciates some releases due to critical flaws or bugs. These versions cannot be downloaded.

### Any antivirus warning.

Any antivirus or antimalware like **Bitdefender** (which the author of **ALOSToy Installer** has) can **flag** safe, legitimate software as **malware**.

You should **disable** it while running and **re-enable** it after completion.



## **License Terms**

Copyright (C) 2026 Aarav Katariya



This program is **free software**: you can **redistribute** it and/or **modify**

it under the terms of the GNU General Public License as published by

the Free Software Foundation, either version 3 of the License, or

(at your option) **any later version**.



This program is distributed in the hope that it will be useful,

but **WITHOUT ANY WARRANTY**; without even the implied warranty of

**MERCHANTABILITY** or **FITNESS FOR A PARTICULAR PURPOSE**. See the

GNU General Public License for more details.



You **should have received** a copy of the GNU General Public License

along with this program. If not, see [**https://www.gnu.org/licenses/**](https://www.gnu.org/licenses/)**.**



To see the full GNU GPL v3.0 License, open the **LICENSE** file on this repo.

## **Author**

Aarav Katariya



# ***End Of The Guide***

