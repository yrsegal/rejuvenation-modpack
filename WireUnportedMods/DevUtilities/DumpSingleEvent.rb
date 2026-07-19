module EventExport

  def self.writeSingleEvent(event, map = nil)
    File.open("dump.txt", "wb") { |f|
      @@f = f
      @@index = 0
      @@system = load_data("Data/System.rxdata")
      @@actors = load_data("Data/Actors.rxdata")
      @@skills = load_data("Data/Skills.rxdata")
      @@weapons = load_data("Data/Weapons.rxdata")
      @@armors = load_data("Data/Armors.rxdata")
      @@states = load_data("Data/States.rxdata")
      @@enemies = load_data("Data/Enemies.rxdata")
      @@troops = load_data("Data/Troops.rxdata")
      @@items = load_data("Data/Items.rxdata")
      @@common_events = load_data("Data/CommonEvents.rxdata")
      @@mapinfos = load_data("Data/MapInfos.rxdata")
      @@animations = load_data("Data/Animations.rxdata")
      @@classes = load_data("Data/Classes.rxdata")
      @@tilesets = load_data("Data/Tilesets.rxdata")
      @@events = {} unless defined?(@@events)
      @@events = map.events if map
      @@update_timer = 0
      if event.respond_to?('list')
        @@list = event.list
        writeEventCommands
      else
        f.write("Event Name: " + event.name + "\n")
        f.write(sprintf("(X,Y): (%03d,%03d)\n\n", event.x, event.y))
        for i in 0...event.pages.length
          f.write("Page ##{i+1}\n")
          begin
            writeEventPage(event.pages[i])
          rescue
            pbPrintException($!)
            errmsg = "INVALID EVENT COMMAND DATA\n\n"
            errmsg += sprintf("Event ID: %03d\n", event.id)
            errmsg += "Event Name: " + event.name + "\n"
            errmsg += sprintf("(X,Y): (%03d,%03d)\n\n", event.x, event.y)
            errmsg += "Line Number: #{@@index + 1}\n\n"
            errmsg += "Check the end of the event text file that was generated before the script crashed to see which event command has invalid data."
            raise errmsg
          end
        end
      end
    }
  end
end
