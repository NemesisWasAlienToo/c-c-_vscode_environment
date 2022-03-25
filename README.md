# Vscode C and C++ Environemt setup helper

Here are a Makefile and launch.json and tasks.json used to setup the build and run environment for vscode.

## How to user
- Copy the Makefile in the roo pf your project.
- Copy launch.json and tasks.json to .vscode folder of your project.
- Change flags, compiler, compiler or linker flags, etc to gain the desired compiling process in the Makefile

## Modes
Makefile can be used in 3 ways:
- launch Source/Main.cpp
- launch Test/Test.cpp
- launch The viewing cpp file

you can basically select the mode in vscode by changing the selected launch task.

you can use a simple script like bellow to create new project structure fast:

```sh
#!/bin/bash

#Script to create new C/C++ File scheme project

# Global Variable Initialization

if [ "$#" -le 0 ]; then
	echo "Please pass the name of your project"
fi

PROJECT=$1
CD=$(pwd)
MAKEFILE="Makefile"
LAUNCH="launch.json"
TASKS="tasks.json"

echo "$CD/$1/"

mkdir $PROJECT

echo "	- $CS/Source"

mkdir $PROJECT/Source/

echo "	- $CS/Library"

mkdir $PROJECT/Library/

echo "	- $CS/Build"

mkdir $PROJECT/Build/

echo "	- $CS/Sample"

mkdir $PROJECT/Sample/

echo "	- $CS/Test"

mkdir $PROJECT/Test/

echo "	- $CS/Makefile"
cp  $MAKEFILE $PROJECT/$MAKEFILE 

echo "	- $CS/.vscode"
mkdir $PROJECT/.vscode
cp  $TASKS $PROJECT/.vscode/$TASKS
cp  $LAUNCH $PROJECT/.vscode/$LAUNCH

code $PROJECT
exit



```