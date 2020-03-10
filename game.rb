=begin
    Morgan Webb - CA2020
    T1A2 - Terminal Application
=end

require_relative 'player'
require 'cli/ui'
require 'colorize'

class Game
    attr_accessor :title, :player

    def initialize(title, player)
        @title = title
        @player = player

        show_title_screen()
    end

    def main_frame()
        clear_screen()
        # we should print player location for each new main frame
        puts "Player location: " + player.location.to_s().blink()
        # we're going to open the frame in blockless mode
        CLI::UI::Frame.open(title)
        # past this point is technically dangerous if we do not remember to pop the frame off the framestack (which the pop_frame method does)    
            yield()
    end

    # we will have to call this method to close the frame since our main frame is in blockless mode
    def pop_frame()
        CLI::UI::Frame.close("Pop!")
    end

    def show_title_screen()
        main_frame { 
            CLI::UI::Prompt.ask("Title Screen") { |handler|
                handler.option("Start") { show_main_screen() }
                handler.option("Exit") { exit() }
            }
        }
    end

    def show_main_screen()
        pop_frame()
        main_frame {
            CLI::UI::Prompt.ask("Main Menu") { |handler|
                handler.option("Shop") {
                    # todo
                }
                handler.option("Warp") {
                    show_warp_screen()
                }
                handler.option("Exit") {
                    exit()
                }
            }
        }
    end

    def show_warp_screen()
        pop_frame()
        main_frame {
            CLI::UI::Prompt.ask("Location") { |handler|
                player.map.locations.each() { |key, value|
                    # ignore our current location
                    if(player.map.locations[key] != player.location)
                        handler.option(value) { |selection|
                            player.location = selection
                            show_main_screen()
                        }
                    end
                }
            }
        }
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
game = Game.new("Terminal RPG", player)