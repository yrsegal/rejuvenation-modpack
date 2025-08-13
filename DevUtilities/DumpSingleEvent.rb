module EventExport

  def self.writeSingleEvent(event)
    File.open("dump.txt", "wb") { |f|
      @@f = f
      @@index = 0
      @@system = load_data("Data/System.rxdata")
      @@update_timer = 0
      @@list = event.list
      writeEventCommands
    }
  end
end
