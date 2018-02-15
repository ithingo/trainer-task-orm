module DBConnection
  private

  def connect
    begin
      connection = PG.connect :dbname => 'crieera', :user => 'crieera', :password => ''
    rescue PG::Error => e
      puts e.message
    end
    connection
  end

  def disconnect(connection)
    connection.close if connection
  end
end