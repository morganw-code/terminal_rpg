=begin
    Morgan Webb - CA2020
    T1A2 - Terminal Application
=end

require_relative 'player'
require 'cli/ui'

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
                handler.option("Start") {
                    # technically the frame shouldn't end here in normal flow, but we pullin' strings to make this work!
                    # temporary fix!
                    pop_frame()
                    main_frame {
                        CLI::UI::Prompt.ask("Main Menu") { |handler|
                            handler.option("Shop") {
                                # todo
                              }
                            handler.option("Warp") {
                                CLI::UI::Prompt.ask("Location") { |handler|
                                    player.map.locations.each() { |key, value|
                                        handler.option(value) {
                                            player.location = value.to_sym()
                                        }
                                    }
                                }
                            }
                            handler.option("Exit") { }
                        }
                        # temporary fix!
                        pop_frame()
                    }
                }

                handler.option("Exit") {
                    exit()
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
        abort(nil)
    end
end

player = Player.new("Morgan")
game = Game.new("Terminal RPG", player)