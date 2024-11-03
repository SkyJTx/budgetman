@echo off
setlocal enabledelayedexpansion

set "test_dir=integration_test"
for %%f in (%test_dir%\*.dart) do (
    echo Running flutter test on %%f
    flutter test %%f
)

endlocal