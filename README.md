https://github.com/morganw-code/terminal_rpg/

# R5. Purpose and Scope

Terminal RPG is a basic turn-based ‘Role-Playing Game’ written in Ruby, for the terminal. When starting the game, players spawn in at the ‘Hub’, where players can then access the ‘Warp’ menu to travel to different locations within the game, with each location having it’s own unique route. From the ‘Shop’, players may access the shop NPC (non-player character) where players can then purchase weapons and potions to help aid in battle, and from the ‘Arena’, players may initiate battle against a chosen opponent. Each opponent has a set of attacks, which are randomly selected each turn the computer takes. Each attack from an opponent has a 1 in 5 chance of missing, while each chosen attack from the player has a 1 in 2 (50%) chance of missing. The objective of the game is to defeat all unique opponents. There is no end-game, you may re-initiate battle with any fallen foe. So what problem does this solve? Well, not much. Terminal RPG was developed to help aid boredom throughout our busy and boring lives (and maybe for an assignment submission). Terminal RPG features only a very basic, simple, and repetitive RPG-style experience. Terminal RPG can run smoothly on just about any low-spec computer. Terminal RPG is for people who enjoy playing a repeatitive, time-wasting, simple, terminal-based RPG that is cross-platform and free!

# R6. Features

## Shop
When the game starts, the inventory for the player is initialized with the starting items (1x sword, 2x health potions, 5x mana potions, and 300 gold) which is stored in a hash. Players can access the Shop NPC to buy items, but stock is limited to the inventory of the NPC. The Shop NPC’s inventory will reset every time an opponent is defeated by applying the default values to the hash. Players purchase items using gold, and the inventory for both the player and the NPC is updated accordingly after each transaction. If an item is out of stock, the player is unable to make the purchase (stock is tracked in the inventory hash :item_symbol => stock_num of the shop NPC). The shop prompt options will update dynamically, so adding additional items is a breeze.

## Saving Progression
When the game starts, players are given the option to load an existing save, or start a new game. Player progress is saved by writing instance data to an XML file for both the player and the shop NPC. Loading the saved data will initialize both the Player instance, and the shop NPC instance with the appropriate data (name, inventory, etc) from the saved XML file. If the save file does not exist when attempting to load a save, the player is then prompted accordingly and a new game begins.

## Fast Travel
Players can warp between areas to access certain routes like the ‘Shop’ to access the ‘Shop’ NPC, or the ‘Arena’ to initiate battle with a chosen opponent. Warping between locations update the players current location where conditional statements then determine which options are visible in the main menu each time the player is in the main menu, and the warp menu will only reflect unique locations that the player does not currently reside in.

## Battle Mechanics
Each time the computer takes a turn the attack is randomized sampling a random attack multiplier symbol from an array, which is then used to lookup the multiplier for the attack from a hash. When an attack is determined, the given damage multiplier is then used to calculate the resulting damage amount from the base attack value of the opponent. The computer has a 1 in 5 chance of missing an attack, which then results in the attack using up one turn without any damage value applied to the health of the player.

Each time the player takes a turn they’re given the option to choose their attack. If the player has the appropriate mana for the given attack, the attack is then applied and the player then has a 50/50 chance of landing the attack successfully. Like the opponent, if a player misses an attack, the turn is used up for that iteration of the battle loop. 

# R7. Interaction and Experience

## Inventory

When the player starts the game they're prompted with the option to view their inventory where they can check their current items. When the player is in the inventory menu, their items are iterated through and printed on the screen and the player can then return to the main menu by pressing the enter key.

## Fast Travel

When the player wants to warp to a new location, they can access the warp menu from the main menu. When a player enters the warp menu, only locations that they're not currently at will display.

## Shop

The option to access the Shop NPC is only available from the main menu when the player location is at the 'Shop'. When a player enters the shop menu, the NPC inventory is iterated through and items are displayed to the player accordingly. If an item is out of stock, or the player does not have enough gold, they're unable to make the purchase.

## Battle

The option to enter battle is only available from the main menu when the player is at the 'Arena'. From the battle menu, the player may initiate battle with an opponent. During battle, the battle loop will run as long as both the player and the boss is alive.

## Loading Save File

When loading a save the game checks to make sure the save actually exists before attempting to do anything with the save file. If the file does not exist, the player is prompted accordingly and a new game begins.

# R8. Control Flow

![Terminal RPG control flow](/docs/control-flow-chart.png)

# R9. Implementation Plan

![Terminal RPG implementation plan](/docs/implementation-plan.png)

# R10. Installation
Install Ruby
[Ruby Programming Language](https://www.ruby-lang.org/en/)

## Gem Dependencies
`cli/ui`
`colorize`
`terminal-table`
`nokogiri`

To run the game execute `game.rb`
