:::: Windows Time Service ::::

::#############################################################################
::							#DESCRIPTION#
::
::	SCRIPT STYLE: Interactive
::	
::	
::#############################################################################

:::: Developer ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Author:		David Geeraerts
:: Location:	Olympia, Washington USA
:: E-Mail:		dgeeraerts.evergreen@gmail.com
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: GitHub :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::	
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: License ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Copyleft License(s)
:: GNU GPL v3 (General Public License)
:: https://www.gnu.org/licenses/gpl-3.0.en.html
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Versioning Schema ::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::		VERSIONING INFORMATION												 ::
::		Semantic Versioning used											 ::
::		http://semver.org/													 ::
::		Major.Minor.Revision												 ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Command shell ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@Echo Off
@SETLOCAL enableextensions
SET "$PROGRAM_NAME=Windows Time Service"
SET $Version=0.1.0
SET $BUILD=2021-03-24 10:30
Title %$PROGRAM_NAME%
Prompt WTS$G
color 8F
mode con:cols=75 lines=40
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Configuration - Basic ::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Declare Global variables
:: All User variables are set within here.
:: Defaults
::	uses user profile location for logs
SET "$LOGPATH=%USERPROFILE%\Documents\WTS"
SET "$LOG=%COMPUTERNAME%-WTS.log"
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Configuration - Advanced :::::::::::::::::::::::::::::::::::::::::::::::::
:: Advanced Settings

SET $DC=EVDC9

:: List of NTP Servers
SET "$NTP_POOL=time-a-b.nist.gov time-a-g.nist.gov 0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org"

:: DEBUG
:: {0 [Off/No] , 1 [On/Yes]}
SET $DEGUB_MODE=0
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




::#############################################################################
::	!!!!	Everything below here is 'hard-coded' [DO NOT MODIFY]	!!!!
::#############################################################################



:::: Directory ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:CD
	:: Launched from directory
	SET "$PROGRAM_PATH=%~dp0"
	::	Setup logging
	IF NOT EXIST "%$LOGPATH%" MD "%$LOGPATH%"
	cd /D "%$LOGPATH%"
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


Goto start

:::: banner :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:banner
:: CONSOLE MENU ::
cls
	echo  ***********************************************************************
	echo		%$PROGRAM_NAME%
	echo			Version: %$Version%
	IF %$DEGUB_MODE% EQU 1 echo			Build: %$BUILD%
	echo.
	echo		 	%DATE% %TIME%
	echo.
	echo  ***********************************************************************
echo.
GoTo:EOF
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:start
call :banner
echo. >> "%$LOGPATH%\%$LOG%"
ECHO Start: %DATE% %TIME% >> "%$LOGPATH%\%$LOG%"
HOSTNAME >> "%$LOGPATH%\%$LOG%"
echo Program Version: %$Version% >> "%$LOGPATH%\%$LOG%"
IF %$DEGUB_MODE% EQU 1 echo Build: %$BUILD% >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"

:::: Administrator Privilege Check ::::::::::::::::::::::::::::::::::::::::::::
:subA
	SET $ADMIN_STATUS=0
	openfiles.exe 1> "%$LOGPATH%\var_$Admin_Status_M.txt" 2> "%$LOGPATH%\var_$Admin_Status_E.txt" && (SET $ADMIN_STATUS=1)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::: Admin Privelage Check ::::::::::::::::::::::::::::::::::::::::::::::::::::
:admin
	echo Checking if running with Administrative privelage...
	echo (Running with Administrative privelage is recommended!)
	echo.
	IF %$ADMIN_STATUS% EQU 1 (
		echo Running with Administrative privelage!
		)
		
	IF %$ADMIN_STATUS% EQU 0 (
		color 4E
		echo NOT running with  Administrative privelage!
		echo Right-click script, "Run as administrator"!
		echo program will now abort!
		echo.
		type "%$LOGPATH%\var_$Admin_Status_E.txt" >> "%$LOGPATH%\%$LOG%"
		pause
		GoTo end
		)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:: echo Configuring debug file... 
:: w32tm /debug /enable /file:%$LOGPATH%\%COMPUTERNAME%-W32tn.log /size:1000000 /entries:0-300
echo Running registry dump...
echo Registry Dump: >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
w32tm /dumpreg >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
echo Running Windows Time Service query...
echo Windows Time Service Query: >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
echo Source: >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
w32tm /query /source /verbose >> "%$LOGPATH%\%$LOG%"
echo Status: >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
w32tm /query /status /verbose >> "%$LOGPATH%\%$LOG%"
echo Configuration: >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
w32tm /query /configuration /verbose >> "%$LOGPATH%\%$LOG%"
echo Peers: >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
w32tm /query /peers /verbose >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
echo Running Monitor...
echo Windows Time Service monitor: >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
w32tm /monitor >> "%$LOGPATH%\%$LOG%"
echo Getting Time Zone...
w32tm /tz
echo. >> "%$LOGPATH%\%$LOG%"
echo Time Zone: >> "%$LOGPATH%\%$LOG%"
w32tm /tz >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
echo Comparing time test...
echo Compare time test: >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
w32tm /stripchart /computer:%$DC% /period:2 /samples:15 >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
echo Attempting to time sync...
echo Windows Time Service sync: >> "%$LOGPATH%\%$LOG%"
:: Resync
w32tm /resync /rediscover >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
echo Checking time status...
echo Checking time status: >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
w32tm /query /status >> "%$LOGPATH%\%$LOG%"
echo Running Monitor...
echo Windows Time Service monitor: >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
w32tm /monitor >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
echo Comparing time test...
echo Compare time test: >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
w32tm /stripchart /computer:%$DC% /period:2 /samples:15 >> "%$LOGPATH%\%$LOG%"
:: SET $COUNTER=1
:: FOR /F "tokens=%$COUNTER% delims= " %I IN ("%$NTP_POOL%") DO w32tm /stripchart /computer:%I /period:2 /samples:15 >> "%$LOGPATH%\%$LOG%"
echo Configure Time Servers...
echo Configure Time Servers: >> "%$LOGPATH%\%$LOG%"
echo. >> "%$LOGPATH%\%$LOG%"
w32tm /config /update /syncfromflags:manual /manualpeerlist:"time-a-b.nist.gov time-a-g.nist.gov 0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org" >> "%$LOGPATH%\%$LOG%"
echo.  >> "%$LOGPATH%\%$LOG%"
w32tm /stripchart /computer:time-a-b.nist.gov /period:2 /samples:15 >> "%$LOGPATH%\%$LOG%"


:: Open Directory
@explorer "%$LOGPATH%"

:end
echo. >> "%$LOGPATH%\%$LOG%"
echo End %DATE% %TIME% >> "%$LOGPATH%\%$LOG%"

:: Cleanup files
IF EXIST "%$LOGPATH%\var_$Admin_Status_M.txt" DEL /F /Q "%$LOGPATH%\var_$Admin_Status_M.txt"
IF EXIST "%$LOGPATH%\var_$Admin_Status_E.txt" DEL /F /Q "%$LOGPATH%\var_$Admin_Status_E.txt"

:: echo Disable Debug log...
:: w32tm /debug /disable
echo.
Echo.
IF %$ADMIN_STATUS% EQU 1(
	echo Windows Time Service completed!
	echo.
	PAUSE
	)
EXIT


:subIter
IF $COUNTER GRT 6 GoTo subEnd
SET $COUNTER=1
FOR /F "tokens=$COUNTER delims= " %I IN ("%$NTP_POOL%") DO w32tm /stripchart /computer:%I /period:2 /samples:15
GoTo subIter
:subEnd