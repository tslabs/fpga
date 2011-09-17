@echo This batch file will run an utility to help you update the paths in the CII_Starter_1.0.0 demonstration files. A dialog window will appear where you can select the folder that contains the C2SDK_1.0.0 demonstration files.

@fixpath -opath "c:\CII_Starter_1.0.0" -projdir "C2SDK_*" -sprompt "Select the directory containing the C2SDK_1.0.0 demonstration project files."

