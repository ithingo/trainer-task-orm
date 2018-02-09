require 'pg'
#working example
begin
  conn = PG.connect :dbname => 'crieera', :user => 'crieera'  #, :password => 'password'
  puts conn.server_version

  rs = conn.exec "SELECT * FROM test_table"
  rs.each do |row|
    puts "%s %s" % [ row['id'], row['name']]
  end

  user = conn.user
  db_name = conn.db

rescue PG::Error => e
  puts e.message
ensure
  conn.close if conn
end
=begin
  conn = PG.connect :dbname => 'crieera', :user => 'crieera'  #, :password => 'password'
    puts conn.server_version

    user = conn.user
    db_name = conn.db
   # pswd = conn.pass

    puts "User: #{user}"
    puts "Database name: #{db_name}"
   # puts "Password: #{pswd}"


  con.exec "DROP TABLE IF EXISTS Cars"
    con.exec "CREATE TABLE Cars(Id INTEGER PRIMARY KEY,
        Name VARCHAR(20), Price INT)"
    con.exec "INSERT INTO Cars VALUES(1,'Audi',52642)"
    con.exec "INSERT INTO Cars VALUES(2,'Mercedes',57127)"
    con.exec "INSERT INTO Cars VALUES(3,'Skoda',9000)"
    con.exec "INSERT INTO Cars VALUES(4,'Volvo',29000)"
    con.exec "INSERT INTO Cars VALUES(5,'Bentley',350000)"
    con.exec "INSERT INTO Cars VALUES(6,'Citroen',21000)"
    con.exec "INSERT INTO Cars VALUES(7,'Hummer',41400)"
    con.exec "INSERT INTO Cars VALUES(8,'Volkswagen',21600)"


    rs = con.exec 'SELECT VERSION()'
    puts rs.getvalue 0, 0

    rs = con.exec "SELECT * FROM Cars LIMIT 5"
    rs.each do |row|
      puts "%s %s %s" % [ row['id'], row['name'], row['price'] ]
    end


=end
# rescue PG::Error => e
#   puts e.message
# ensure
#   rs.clear if rs
#   conn.close if conn
# end