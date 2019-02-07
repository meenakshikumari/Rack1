require 'sequel'

class HelloWorld
  def call(env)
    db = db_conn
    arr= []
    db.fetch("SELECT name, email FROM users") do |row|
      p arr << {name: row[:name], email: row[:email]} 
    end
    # p db.fetch("SELECT * FROM users")
    puts env

    json = { data: arr }.to_json
    ['200', {'Content-Type' => 'application/json'}, [json]]
  end

  def db_conn
    return Sequel.postgres(database: 'testdb', user: 'postgres')
  end
end
