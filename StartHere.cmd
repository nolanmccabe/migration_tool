@echo off
Color 02
If exist "D:\migration_tool*\" goto StartTeacherMigrationTool
:StartTeacherMigrationTool
powershell.exe -executionpolicy unrestricted -noprofile -WindowStyle Maximized -command "&{start-process powershell -ArgumentList '-executionpolicy unrestricted -noprofile -WindowStyle Maximized -file D:\TeacherMigrationTool\TeacherMigrationTool.ps1' -verb RunAs}"
exit
