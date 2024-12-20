@echo off
REM /*
REM	Packt Dateien in einem Verzeichnis bzw. dessen Unterverzeichnisse
REM	und verschiebt diese in ein 5-Stufen Ringspeicher-Archiv.
REM
REM	20111013 b.stromberg@data-systems.de
REM */
title Der freundliche Dateipacker


REM -- Where is the 7Zip Binary (free@www.7zip.org)?
REM -- (NO SPACES allowed, use 8+3 naming, like c:\progra~1)
set sevenzip=C:\Programme\7-Zip\7z.exe

REM -- This is primary path to start over
set starthere=D:\SMTPSERVER-Logfiles

REM -- Travel recursive? (In alle Unterverzeichnissen ab 'starthere')
REM -- [r-yes] oder [r-no]
set recursive=r-yes

REM -- Everything gets moved into the archives that is older than ...
REM -- (in most cases it is a goo idea to skip the current file)
set daysolder=1

REM -- Move which files?
set files=*.log

REM -- Name the archive? (Number suffix is added automatically)
SET filename=archiv



REM -------------------------------------------------------------------------------------------------------------------

goto %recursive%

:r-yes
for /f %%i in ('dir /b %starthere%') do (
	if exist "%starthere%\%%i\%files%" (

		REM Ringspeicher-Renaming ...
		if exist "%starthere%\%%i\%filename%_5.7z" del "%starthere%\%%i\%filename%_5.7z"
		if exist "%starthere%\%%i\%filename%_4.7z" ren "%starthere%\%%i\%filename%_4.7z" %filename%_5.7z
		if exist "%starthere%\%%i\%filename%_3.7z" ren "%starthere%\%%i\%filename%_3.7z" %filename%_4.7z
		if exist "%starthere%\%%i\%filename%_2.7z" ren "%starthere%\%%i\%filename%_2.7z" %filename%_3.7z
		if exist "%starthere%\%%i\%filename%_1.7z" ren "%starthere%\%%i\%filename%_1.7z" %filename%_2.7z
		
		REM Einpacken und loeschen ...
		forfiles /P %starthere%\%%i /M %files% /D -%daysolder% /C "cmd /c %sevenzip% a -mx9 %starthere%\%%i\%filename%_1.7z @path"
		forfiles /P %starthere%\%%i /M %files% /D -%daysolder% /C "cmd /c del @path"

	)
)
goto eof


:r-no
if exist "%starthere%\%filename%_5.7z" del "%starthere%\%filename%_5.7z"
if exist "%starthere%\%filename%_4.7z" ren "%starthere%\%filename%_4.7z" %filename%_5.7z
if exist "%starthere%\%filename%_3.7z" ren "%starthere%\%filename%_3.7z" %filename%_4.7z
if exist "%starthere%\%filename%_2.7z" ren "%starthere%\%filename%_2.7z" %filename%_3.7z
if exist "%starthere%\%filename%_1.7z" ren "%starthere%\%filename%_1.7z" %filename%_2.7z

forfiles /P %starthere% /M %files% /D -%daysolder% /C "cmd /c %sevenzip% a -mx9 %starthere%\%filename%_1.7z @path"
forfiles /P %starthere% /M %files% /D -%daysolder% /C "cmd /c del @path"
goto eof

:eof