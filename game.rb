=begin
    Morgan Webb - CA2020
    T1A2 - Terminal Application
=end
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
        # we're going to open the frame in blockless mode
        CLI::UI::Frame.open(title)
            yield
        # past this point is technically dangerous if we do not remember to pop the frame off the framestack (which the pop_frame method does)
    end

    # we will have to call this method to close the frame since our "main" frame is in blockless mode
    def pop_frame()
        CLI::UI::Frame.close(nil)
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
                            handler.option("Shop") { }
                            handler.option("Warp") { }
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
        abort("cya!")
    end
end

game = Game.new("Terminal RPG", nil)