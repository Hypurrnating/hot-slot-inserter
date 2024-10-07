# Hot slot inserter
 This is a Roblox script which allows users to insert their own slots using a GUI. \
 Shoutout to `outrun917` and `sjark` for the original GUI, scripts, and idea.


[![Static Badge](https://img.shields.io/badge/download_rbxm-here?style=for-the-badge&color=blue)](https://github.com/Hypurrnating/Roblox-slot-inserter/raw/main/hsi.rbxm)

 The script creates a record of what models were insert by who and when in a lua table. It then uses that data to set a cool-down (or debounce) on each player. \
 The script also logs the insert to a discord webhook, although you should also specify a guilded webhook as a fallback.

 > [!IMPORTANT]
 > Although the script does help enhance security, it is not an alternative for manually checking the slots that are inserted.

 ## How to install this to a game?

 ### 1: Download the file
 Download the RBXM file using the blue button above, and drop it into the game.

 ### 2: Move the objects to where they belong
 Basically just move the HSI folder which just got inserted to ServerScriptService, and the inserter will install itself when the game runs

 ### 3: Setup webhooks
 Now you need to open the `RemoteEventScript` file, which is under the folder `ServerScriptService` (IN THE HSI FOLDER, *not the actual ServerScriptService*).
 When you open the file, you will notice a table array called `post_urls`. Just add your webhook urls to the array.

 ## How to access the records/logs of everyone who inserted using the GUI?
 You can get a READONLY COPY of the records 

  in script:
  ```lua
  local ServerScriptService = game:GetService("ServerScriptService")
  local GetRecords = ServerScriptService:FindFirstChild('InsertManager')

  local records: table = GetRecords:Invoke()

  -- Do what you want with this data
  ```

  In local script:
  ```lua
  local ReplicatedStorage = game:GetService("ReplicatedStorage")
  local GetRecords = ReplicatedStorage:FindFirstChild('GetRecords')

  local records: table = GetRecords:InvokeServer()

  -- Do what you want with this data
  ```
The data returned is an array of tables, sorted by user id

  ```lua
 {
    ["user id"] = {
        [1] = {
            ['utc'] = "The time at which this was inserted",
            ['ID'] = "The asset ID which was used to fetch this from marketplace",
            ['Model'] = "The model object for this car. Usually have to do :GetChildren[1] to get the actual car",
            ['Product'] = "Product info for this asset from marketplace."
        },
        [2] = {
            "You get the idea"
        }
    }
 }
  ```
