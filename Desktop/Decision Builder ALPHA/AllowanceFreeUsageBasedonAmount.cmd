@ECHO OFF
SETLOCAL
REM Variables you must configure
REM ** do not add any spaces
REM the parameter table name below will show in your offering\
set DECISIONNAME=DecisionNameHere
set USAGEPINAME=UsagePriceableItemName
set CONFIGPARAMTABLENAME=ParameterTableName


REM Defaulted Variables
set DATABASENAME=NetMeter
set DATABASELOGIN=sa
set DATABASEPASS=MetraTech1


REM DO NOT TOUCH ANYTHING BELOW THIS LINE
REM -------------------------------------------------------
set EXECSQLFILE=sqlcmd -d %DATABASENAME% -U %DATABASELOGIN% -P %DATABASEPASS% -i 
xcopy templates "%DECISIONNAME%\" /Y /S /q > nul
tools\fart.exe -r -q %DECISIONNAME%\*.* DATABASENAME %DATABASENAME%
REM %EXECSQLFILE% %DECISIONNAME%\DBBACKUP.sql

tools\fart.exe -r -q -f %DECISIONNAME%\*.* DECISIONNAME %DECISIONNAME% > nul
tools\fart.exe -r -q %DECISIONNAME%\*.* DECISIONNAME %DECISIONNAME%
tools\fart.exe -r -q -f %DECISIONNAME%\*.* CONFIGPARAMTABLENAME %CONFIGPARAMTABLENAME% > nul
tools\fart.exe -r -q %DECISIONNAME%\*.* CONFIGPARAMTABLENAME %CONFIGPARAMTABLENAME%
tools\fart.exe -r -q %DECISIONNAME%\*.* USAGEPINAME %USAGEPINAME%
xcopy %DECISIONNAME%\CDE "%MTRMP%\Extensions\CDE\" /Y /S /q

REM ntloggerrollover logger
net stop pipeline
net stop activityservices
net stop billingserver
net stop metratech.fileservice
mvmlistener -i
net stop mvmlistener

echo *******  SYNCHRONIZING ALL HOOKS NOW
pushd %MTRMP%\install\scripts\
C:\Windows\SysWOW64\cscript //nologo RunHook.vbs all
popd


run script to create UQG
run script to create Amount chain
run script to create decision

Have a nice day

