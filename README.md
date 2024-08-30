# Hot slot inserter
 This is a Roblox script which allows users to insert their own slots using a GUI. \
 Shoutout to `outrun917` and `sjark` for the original GUI, scripts, and idea.

 [Read more lore](https://gist.github.com/Hypurrnating/03f3b4401d4e67a133a4877f8644f8ed)


[![Static Badge](https://img.shields.io/badge/download_rbxm-here?style=for-the-badge&color=blue)](https://github.com/Hypurrnating/Roblox-slot-inserter/raw/main/hsi.rbxm) \
If you wish to suggest improvements to the code, you can create a pull request and edit the .lua scripts in /src

 The script creates a record of what models were insert by who and when in a lua table. It then uses that data to set a cool-down (or debounce) on each player. \
 The script also logs the insert to a discord webhook, although you should also specify a guilded webhook as fallback (will be introduced later).

 > [!IMPORTANT]
 > Although the script does help enhance security, it is not an alternative for manually checking the slots that are inserted.
 
 I do aim to introduce better security features in the future, but as the warning above says, you have to be aware of what you are allowing into the game.


 ## How to install this to my game?

 ### 1: Download the file
 Download the RBXM file using the blue button above, and drop it into the game.

 ### 2: Move the objects to where they belong
 Open the explorer tab. \
 Import the .rbxm file and you will find a folder called HSI. Expand the folder, you will find subfolders. They have names like:
 `toReplicatedStorage` or `toStartGUI`. \
 Just expand these subfolders, and move the contents to where the title says.
 
 For example: Expand the `toReplicatedStorage` folder, select all the things in the folder, and move them to `ReplicatedStorage` in your game. 

 ### 3: Setup webhooks
 Now you need to open the `RemoteEventScript` file, which you should have already moved to the ServerScriptService.
 When you open the file, you will notice a table called `post_urls`. Just add your webhook urls to the table.

 ## Can I change the GUI?
 Yes. The actual GUI stays in `StarterGUI` folder. The tool just changes visibility of the GUI from `false` to `true`. \
 You can see this in the tool's local script, which you can find in `/src/StartPack/Utilities/LocalScript.client.lua` of this repo. \
 Whatever GUI you make just have to flip the `visible` switch on the `UtilitiesFrame` of the players GUI.

 ## How to access the records/logs of everyone who inserted using the GUI?
  TODO