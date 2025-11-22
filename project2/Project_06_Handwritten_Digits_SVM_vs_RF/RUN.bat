@echo off
REM ===================================================================
REM RUN.bat
REM Drop this file in the root of your repo. Double-click to run.
REM - Creates venv (if python in PATH)
REM - Installs requirements.txt (if present)
REM - Runs npm install (if package.json present)
REM - Auto-detects and runs a common entrypoint, or you can set RUN_CMD
REM - Keeps window open (pause) so you can read output
REM ===================================================================

SETLOCAL ENABLEDELAYEDEXPANSION

REM ---------- USER CONFIG (edit only if you want a custom command) ----------
REM If you want to force a specific run command, set RUN_CMD. Example:
REM SET "RUN_CMD=python train_mnist.py --subset 10000 --pca 50"
SET "RUN_CMD="
REM --------------------------------------------------------------------------

REM go to the directory where this script is located
cd /d "%~dp0"
SET "ROOT=%CD%"
REM current script name (filename + ext)
SET "THIS_SCRIPT=%~nx0"

echo.
echo ===================================================================
echo Starting %THIS_SCRIPT%
echo Project root: %ROOT%
echo Timestamp: %DATE% %TIME%
echo ===================================================================
echo. > "%ROOT%\run.log"
echo RUN started at %DATE% %TIME% >> "%ROOT%\run.log"
echo Project root: %ROOT% >> "%ROOT%\run.log"
echo Script: %THIS_SCRIPT% >> "%ROOT%\run.log"
echo. >> "%ROOT%\run.log"

REM -------------------------
REM 1) Setup Python venv & install requirements (if Python exists)
REM -------------------------
where python >nul 2>&1
IF ERRORLEVEL 1 (
    echo Python not found in PATH. Skipping Python venv & pip steps.
) ELSE (
    echo Python detected.
    if exist "%ROOT%\requirements.txt" (
        echo Found requirements.txt - creating/using venv...
        if not exist "%ROOT%\venv" (
            echo Creating venv...
            python -m venv venv
            if ERRORLEVEL 1 (
                echo ERROR: Failed to create venv. Ensure Python supports venv and is in PATH.
            )
        ) else (
            echo Using existing venv/
        )

        REM activate venv for this script
        call "%ROOT%\venv\Scripts\activate.bat" >nul 2>&1
        if ERRORLEVEL 1 (
            echo WARNING: Could not activate venv via Scripts\activate.bat. Will use python -m pip instead.
            echo Upgrading pip and installing requirements...
            python -m pip install --upgrade pip
            python -m pip install -r requirements.txt
        ) else (
            echo venv activated.
            echo Upgrading pip and installing requirements...
            pip install --upgrade pip
            pip install -r requirements.txt
        )
        echo Python dependencies installed (or attempted).
        echo Installed Python deps at %DATE% %TIME% >> "%ROOT%\run.log"
    ) ELSE (
        echo requirements.txt not found. Skipping Python dependency install.
    )
)

REM -------------------------
REM 2) Node: install deps if package.json exists
REM -------------------------
if exist "%ROOT%\package.json" (
    where npm >nul 2>&1
    IF ERRORLEVEL 1 (
        echo npm not found in PATH. Skipping npm install.
    ) ELSE (
        echo package.json found -> running npm install...
        npm install
        echo npm install finished.
        echo npm install finished at %DATE% %TIME% >> "%ROOT%\run.log"
    )
)

REM -------------------------
REM 3) Run the project (auto-detect or use RUN_CMD)
REM -------------------------
echo.
echo Attempting to run the project...
echo (If you want a custom command, edit RUN_CMD at the top of this file.)
echo.

REM If user set RUN_CMD, run it (supports quoted commands)
if not "%RUN_CMD%"=="" (
    echo Running custom command: %RUN_CMD%
    echo Running custom command: %RUN_CMD% >> "%ROOT%\run.log"
    cmd /c "%RUN_CMD%"
) else (
    REM Auto-detect common entry points in priority order
    if exist "%ROOT%\train_mnist.py" (
        echo Found train_mnist.py -> running: python train_mnist.py
        echo Running train_mnist.py >> "%ROOT%\run.log"
        python train_mnist.py
    ) else (
        if exist "%ROOT%\main.py" (
            echo Found main.py -> running: python main.py
            echo Running main.py >> "%ROOT%\run.log"
            python main.py
        ) else (
            if exist "%ROOT%\app.py" (
                echo Found app.py -> running: python app.py
                echo Running app.py >> "%ROOT%\run.log"
                python app.py
            ) else (
                if exist "%ROOT%\package.json" (
                    echo Found package.json -> running: npm start
                    echo Running npm start >> "%ROOT%\run.log"
                    npm start
                ) else (
                    REM Avoid calling this same script; only call repo's run.bat if different filename
                    if exist "%ROOT%\run.bat" (
                        if /I not "%THIS_SCRIPT%"=="run.bat" (
                            echo Found run.bat in repo (different from this script) -> executing it
                            echo Calling run.bat >> "%ROOT%\run.log"
                            call "%ROOT%\run.bat"
                        ) else (
                            REM run.bat is this file (or same name) - skip to prevent recursion
                            REM Do nothing here; user should set RUN_CMD or add an entrypoint.
                            echo Found run.bat but it's this script. Skipping self-call to avoid recursion.
                        )
                    ) else (
                        echo Could not auto-detect an entrypoint (train_mnist.py, main.py, app.py, package.json, run.bat).
                        echo Please edit RUN.bat and set RUN_CMD to the command that runs your project.
                        echo Listing files in the repo root for debugging:
                        dir /b
                        echo >> "%ROOT%\run.log"
                        echo "Could not detect entrypoint" >> "%ROOT%\run.log"
                    )
                )
            )
        )
    )
)

REM -------------------------
REM 4) Wrap up, show log tail, and pause so window stays open
REM -------------------------
echo. >> "%ROOT%\run.log"
echo RUN finished at %DATE% %TIME% >> "%ROOT%\run.log"
echo ===================================================================
echo RUN finished at %DATE% %TIME%
echo Log file: %ROOT%\run.log
echo ===================================================================
echo.
REM show last 40 lines of the run.log (PowerShell used if available)
where powershell >nul 2>&1
IF ERRORLEVEL 0 (
    powershell -Command "Get-Content -Path '%ROOT%\run.log' -Tail 40 -ErrorAction SilentlyContinue"
) ELSE (
    echo (Install PowerShell to view log tail automatically)
)

echo.
echo Done. Press any key to close this window.
pause
ENDLOCAL
