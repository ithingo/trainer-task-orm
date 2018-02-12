class TestConnect
  def self.connect(db_name, username, pass)
    begin
      connection = PG.connect :dbname => db_name, :user => username, :password => pass
      puts "Connecting..."
      check_connection = true
    rescue PG::Error => e
      check_connection = false
      puts "Maybe you mixed some parameters up. Try again"
      puts e.message
    ensure
      connection.close if connection
      puts "Connection closed"
    end
    check_connection
  end
end