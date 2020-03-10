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
        puts "Current location: " + "#{player.last_location}".blink

        CLI::UI::Prompt.ask("SELECTION") { |handler|
          if(player.last_location.to_sym == :arena)
            handler.option("BATTLE") {
              # todo: npc prep
              # battle loop should run whilst player != is_dead
              CLI::UI::Prompt.ask("OPPONENT") { |handler|
                handler.option("Gael from Dark Souls") {
                  while(!player.is_dead)
                    puts "Name: #{player.name}, Health: #{player.hp}, Level: #{player.level}, Base damage: #{player.damage}"
                    player.take_damage(10)
                    if(!player.is_dead)
                      sleep(0.5)
                    end
                  end
                }

                handler.option("Steve from Minecraft") {
                  player.take_damage(1000)
                }
              }

              if(player.is_dead)
                puts "#{player.name} died!".colorize(:red)
                puts "Reviving..."
                player.is_dead = false
                player.hp = 100
                sleep(2)
              end
            }
          end

          handler.option("INVENTORY") {
            puts player.inventory.to_s.on_red.blink
            puts "Press [ENTER] to continue..."
            gets
          }

          handler.option("WARP") {
            CLI::UI::Prompt.ask("LOCATION") { |handler|
              # loop to iterate through locations hash
              for location_key in player.map.locations.keys
                # only display non-current locations
                if(location_key != player.last_location)
                  handler.option(location_key.to_s.upcase) { |selection|
                    player.map.locations[selection.downcase.to_sym] = 1
                    player.map.locations[player.last_location.to_sym] = 0
                    player.last_location = selection.downcase.to_sym

                    case selection.downcase.to_sym
                    when :shop
                      puts "Fair nuff m8tie180"
                      sleep(4)
                    end
                  }
                end
              end

              handler.option("BACK") {
                # flow falls through back to menu-loop
              }
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
