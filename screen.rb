require 'cli/ui'
require 'colorize'

class Screen
  attr_accessor :main_frame_title,
                :inventory_frame_title,
                :battle_frame_title

  def initialize(main_frame_title, player)
    @inventory_frame_title = "Inventory"
    @battle_frame_title = "Battle"

    clear_screen()

    # enable standard output router
    CLI::UI::StdoutRouter.enable()
    # color class: https://rubydoc.info/github/Shopify/cli-ui/master/CLI/UI/Color
    # render main frame
    CLI::UI::Frame.open(main_frame_title, color: CLI::UI::Color::MAGENTA) {
      # render prompt
      CLI::UI::Prompt.ask("START") { |handler| # handler object for the selections
        handler.option("BEGIN") { #|selection|
          start(player)
        }
        handler.option("EXIT") {
          quit()
        }
      }
    }
  end

  def clear_screen()
    # linux || windows
    system("clear") || system("cls")
  end

  def start(player)
    # game loop
    while(true)
      clear_screen()

      CLI::UI::Frame.open("MENU") {
        puts "Current location: #{player.last_location}"

        CLI::UI::Prompt.ask("SELECTION") { |handler|
          if(player.last_location.to_sym == :arena)
            handler.option("BATTLE") {
              # todo: npc prep
              sleep(5)
            }
          end

          handler.option("INVENTORY") {
            puts player.inventory.to_s.on_red.blink
            sleep(4)
          }

          handler.option("WARP") {
            CLI::UI::Prompt.ask("LOCATION") { |handler|
              # loop to iterate through locations hash
              for location_key in player.map.locations.keys
                # only display non-current locations
                if(location_key != player.last_location)
                  handler.option(location_key.to_s.upcase) { |selection|
                    player.map.locations[selection.downcase.to_sym()] = 1
                    player.map.locations[player.last_location.to_sym()] = 0
                    player.last_location = selection.downcase.to_sym()
                  }
                end
              end
            }
          }

          handler.option("EXIT") {
            quit()
          }
        }
      }
    end
  end

  def quit()
    abort("boo!")
  end
end
