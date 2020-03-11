=begin
    Morgan Webb - CA2020
    T1A2 - Terminal Application
=end

require_relative 'player'
require_relative 'npc'
require 'cli/ui'
require 'colorize'

class Game
    attr_accessor :title, :player, :shop_npc, :gael

    def initialize(title, player, shop_npc, gael)
        @title = title
        @player = player
        @shop_npc = shop_npc
        @gael = gael
        show_title_screen()
    end

    def main_frame()
        clear_screen()
        # we should print player location for each new main frame
        puts "Player location: " + @player.location.to_s().blink()
        # we're going to open the frame in blockless mode
        CLI::UI::Frame.open(title)
        # past this point is technically dangerous if we do not remember to pop the frame off the framestack (which the pop_frame method does)
            yield()

        # if we get here
        pop_frame()
    end

    # we will have to call this method to close the frame since our main frame is in blockless mode
    def pop_frame()
        CLI::UI::Frame.close("Pop!")
    end

    def show_title_screen()
        main_frame {
            CLI::UI::Prompt.ask("Title Screen") { |handler|
                handler.option("New game") { show_main_screen() }
                handler.option("Load save") {
                    if(player.load_save())
                        puts "Save found! Starting game...".blink()
                    else
                        puts "No save found! Starting new game...".blink()
                    end

                    sleep(2)
                    show_main_screen()
                }
                handler.option("Exit") { exit() }
            }
        }
    end

    def show_main_screen()   
        pop_frame()
        main_frame {
            CLI::UI::Prompt.ask("Main Menu") { |handler|
                if(@player.location == @player.map.locations[:arena])
                    handler.option("Battle") {
                        show_battle_screen()
                    }
                end
                handler.option("Inventory") {
                    # @player.write_save()
                    show_inventory_screen()
                }
                if(@player.location == @player.map.locations[:shop])
                    handler.option("Shop") {
                        show_shop_screen()
                    }
                end
                handler.option("Warp") {
                    show_warp_screen()
                }
                handler.option("Exit") {
                    exit()
                }
            }
        }
    end

    def show_inventory_screen()
        pop_frame()
        main_frame {
            CLI::UI::Frame.open("Inventory", color: CLI::UI::Color::MAGENTA) {
                puts player.inventory.to_s.on_red.blink
                puts "Press [ENTER] to continue..."
                gets
            }
            show_main_screen()
        }
    end

    def show_warp_screen()
        pop_frame()
        main_frame {
            CLI::UI::Prompt.ask("Location") { |handler|
                @player.map.locations.each() { |key, value|
                    # ignore our current location
                    if(@player.location != @player.map.locations[key])
                        handler.option(value) { |selection|
                            @player.location = selection
                            show_main_screen()
                        }
                    end
                }
            }
        }
    end

    def show_shop_screen()
        pop_frame()
        # we should iterate over the npc's inventory to display options
        main_frame {
            CLI::UI::Prompt.ask("Shop Items") { |handler|
                @shop_npc.inventory.each() { |key_sym, value|
                    @shop_npc.inventory[key_sym].each { |key, value|
                        handler.option("Item: #{key} | Quantity: #{value} | Price: #{@shop_npc.price_list[key_sym]}") { |selection|
                            if(@player.gold - @shop_npc.price_list[key_sym] >= 0 && @shop_npc.inventory[key_sym][key] > 0)
                                @player.gold -= @shop_npc.price_list[key_sym]
                                @player.inventory[key_sym] += 1
                                @shop_npc.inventory[key_sym][key] -= 1
                                puts "Remaining balance: #{@player.gold} | Stock left: #{@shop_npc.inventory[key_sym][key]}".blink()
                                sleep(2)
                                show_main_screen()
                            else
                                puts "Item out of stock!"
                                sleep(2)
                            end
                        }
                        handler.option("Back") {
                            show_main_screen()
                        }
                    }
                }
            }
        }
    end

    def show_battle_screen()
        pop_frame()
        main_frame {
            CLI::UI::Prompt.ask("Choose your opponent") { |handler|
                handler.option("Gael from Dark Souls") {
                    battle_prep_gael()
                }
            }
        }
    end

    def battle_prep_gael()
        pop_frame()
        main_frame {
            CLI::UI::Prompt.ask("Gael: so you wanna die?") { |handler|
                handler.option("no u") {
                    puts "Gael dropped dead. rip."
                    sleep(2)
                }

                handler.option("Bring it on!") {
                    init_gael_battle()
                }

                handler.option("Actually, now that I think of it, I have to be somewhere.") {
                    show_main_screen()
                }
            }

            show_main_screen()
        }
    end

    def init_gael_battle()
        pop_frame()
        while(@player.alive && @gael.alive)
            main_frame {
                puts @player.hp
                @player.take_damage(10)
                sleep(0.1)
                pop_frame()
            }
    
        end
    end

    def clear_screen()
        # linux || windows
        system("clear") || system("cls")
    end

    def exit()
        # maybe should implement a way to make sure the entire framestack is clear
        pop_frame()
        abort("Cya!")
    end
end

player = Player.new("Morgan")
shop_npc = NPC.new("Mike")
gael = Boss.new("Gael")
game = Game.new("Terminal RPG", player, shop_npc, gael)