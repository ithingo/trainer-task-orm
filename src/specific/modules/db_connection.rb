module DBConnection
  private

  def connect
    begin
      connection = PG.connect :dbname => DB_NAME, :user => USERNAME, :password => PASS
    rescue PG::Error => e
      puts e.message
    end
    connection
  end

  def disconnect(connection)
    connection.close if connection
  end
end