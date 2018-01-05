This module will customize your CommandBox prompt while in the interactive shell.  It has multiple "cars" that are part of the train
and each car can contribute some output to the prompt that is working directory-aware.  

**THIS MODULE REQUIRES THE LATEST COMMANDBOX 4.0 SNAPSHOT RELEASE!**

This project is based on the Zsh Bullet Train theme which is based on the Powerline shell prompt.  The goal is to add in additional information 
to your prompt that is specific to the current working directory, or the last command you ran. 

![](https://raw.githubusercontent.com/commandbox-modules/commandbox-bullet-train/master/images/BTfullPrompt.png)

## Installation

Install the module like so:

```bash
install commandbox-bullet-train
```

## Fonts

This module uses some special Unicode characters to draw the prompt that may not be in your default terminal.  You can turn off all Uniode chars and live with an uglier shell like so:

```bash
config set modules.commandbox-bullet-train.unicode=false
```

Or try a font like `Consolas`, `DejaVu Sans Mono`, or `Fira Code`.  The best way to get all the characters to work is to install a "Powerline patched" font and set your terminal to use it.  This may differ based on your operating system.

https://github.com/powerline/fonts.git

Here is a guide for setting a new font up to be used with the Windows cmd terminal:

https://www.techrepublic.com/blog/windows-and-office/quick-tip-add-fonts-to-the-command-prompt/

For Windows users, we also recommend using ConEMU as your terminal.

# Usage

You don't need to do anything special.  Just continue to use the CommandBox interactive shell like you always do.  
You'll notice that the prompt is spanned across two lines and contains additional information.  
Cars that do not apply to the current directory will simply not be displayed.
Familiarize yourself with what each bullet train "car" represents and soon you'll be using the data in the prompt without even thinking about it!

# Bullet Train Cars

Here are the cars that come with the module.  They can be turned on/off, ordered, and customized on an individual basis.
For foreground and background colors you can choose from any of the 8 ANSI-supported colors:

* black
* red
* green
* yellow
* blue
* magenta
* cyan
* white

All config items are nested under `modules.commandbox-bullet-train` and can be configured with the `config set` command.  Ex:

```
config set modules.commandbox-bullet-train.enable=true
```


##  Execution Time

This displays the number of milliseconds the previous command took to execute.  Commands who are so fast they fall below a certain
threshold are ignored. 

![](https://raw.githubusercontent.com/commandbox-modules/commandbox-bullet-train/master/images/BTExecTime.png)

**Config Items**

* `execTimeEnable` - True/false enable this car
* `execTimeText` - ANSI text color
* `execTimeBG` - ANSI background color
* `execTimeThresholdMS` - Only show exec time if it's over this many milliseconds

## Timestamp

This displays the current time that the prompt was displayed.
 

![](https://raw.githubusercontent.com/commandbox-modules/commandbox-bullet-train/master/images/BTTime.png)


* `timeEnable` - True/false enable this car
* `timeText` - ANSI text color
* `timeBG` - ANSI background color

## Server Info

If the current working directory has a server that has been started in it, the engine name and version will display.  The current status of the server (running/stopped) will also display.
 

![](https://raw.githubusercontent.com/commandbox-modules/commandbox-bullet-train/master/images/BTServer.png)


* `serverEnable` - True/false enable this car
* `serverText` - ANSI text color
* `serverBG` - ANSI background color

## Current Working Directory

This will output the last folder name of the current working directory.  If you are in your home dir, it will show `~` and if you are in a folder beneath your home dir, it will show the path starting with `~`.
 

![](https://raw.githubusercontent.com/commandbox-modules/commandbox-bullet-train/master/images/BTDir.png)


* `dirEnable` - True/false enable this car
* `dirText` - ANSI text color
* `dirBG` - ANSI background color

## Git Repo Info

If the current working directory is a Git repo, this car will display the name of the branch currently checked out.  The color of the car will be green if the repo's status is "clean" and red if there are uncommitted changes.  This car will also show the number of added, modified, and removed files (staged and unstaged).  

It is a current known limitation that modified file that are also ignored show in the counts.
 

![](https://raw.githubusercontent.com/commandbox-modules/commandbox-bullet-train/master/images/BTGit.png)


* `gitEnable` - True/false enable this car
* `gitText` - ANSI text color
* `gitCleanBG` - ANSI background color when the Git repo is "clean"
* `gitDirtyBG` - ANSI background color when the Git repo is "dirty"
* `gitTimeoutMS` -Large Git repos can take a while to collect the information from.  The info is acquired async and this controls how many milliseconds to wait before giving up and rendering partial data on the prompt.  If you see "..." in the car, that means we gave up, but don't worry, when the thread completes, the info is cached and it will show up the next time the prompt is drawn for that directory. 
* `gitPrefix` - Override Unicode char if you're not using a Powerline font.  It controls the character that displays at the start of the car.  Set to a space to not have a char at all.. 

## Previous Command Status

This car will show you if your previous command executed successfully or not.  The background of the car will be green if successful and red if failed.  If the previous command failed and the exit code is something other than `1`, the exit code will also be displayed.  
 

![](https://raw.githubusercontent.com/commandbox-modules/commandbox-bullet-train/master/images/BTStatus.png)


* `statusEnable` - True/false enable this car
* `statusText` - ANSI text color
* `statusSuccessBG` - ANSI background color when previous command succeeded
* `statusFailBG` - ANSI background color when previous command failed 

## CommandBox Version 

This shows the current version of the CommandBox CLI.
 

![](https://raw.githubusercontent.com/commandbox-modules/commandbox-bullet-train/master/images/BTBoxVersion.png)


* `boxVersionEnable` - True/false enable this car
* `boxVersionText` - ANSI text color
* `boxVersionBG` - ANSI background color

## Package Info

If the current working directory is a package (has a `boxjson`) the name and version of the package will appear here.
 

![](https://raw.githubusercontent.com/commandbox-modules/commandbox-bullet-train/master/images/BTPackage.png)


* `packageEnable` - True/false enable this car
* `packageText` - ANSI text color
* `packageBG` - ANSI background color

# Configuration

There are also a number of top-level configuration items you can specify for CommandBox Bullet Train


* `enable` - True/false enable the entire module
* `promptChar` - The character to display just prior to the actual blinking cursor (not part of any car).  Defaults to `>`
* `separateLine` - Place line break between cars and prompt
* `addNewLine` - Add new line prior to cars to help separate from previous command output.
* `unicode` -` - True/false use Unicode characters.  When false, defaults to standard ugly AACII.
* `carOrder` - A comma-delimited list of cars in the order you wish them to display.  Removing a car from this list will not make it go away, it just falls to the end.

The names of the default cars are as follows: `execTime,status,time,boxVersion,dir,package,server,git`

# Extending CommandBox Bullet Train

You can create your own custom cars and extend the base module very easily.  If you have an idea for a module that everyone would find useful, contact us and we'll see about just adding it to the core.  To extend CommandBox butter train, create a module whose `ModuleConfig.cfc` listens to the `onBulletTrain` interception point.  Your interceptor will add its formatted text to the `intercept` data and the main Bullet Train module will pick it up and display it.  Here's the steps to extend bullet train in less than one minute.

```bash
mkdir myBulletTrainCar --cd
init type=commandbox-modules slug=myBulletTrainCar
touch ModuleConfig.cfc --open
```
Paste this code in your new `ModuleConfig.cfc`:
```js
component {    
  function configure() {}

  function onBulletTrain( interceptData ) {
    // This helper will create ANSI-formatted text colors
    var print = wirebox.getInstance( 'print' );
    // Set our formatted text into the cars struct
    interceptData.cars.myBulletTrainCar.text = print.whiteOnRed( ' This sure is easy! ' );
    // Tell the main module what our background color was so it can "finish" the car's arrow
    interceptData.cars.myBulletTrainCar.background = 'red';        
  }    
}
```
Now just one more task before we see it all in action!
```bash
package link
```
The shell will reload and you should see your new Bullet Train car at the end of the list.  Feel free to change the order of where your car shows and also make it configurable.  All of the settings from the main module are available to your interceptor in the variable `interceptData.settings`.  Just remember to default all values in case they don't exist.

