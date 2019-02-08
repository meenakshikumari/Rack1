require 'sequel'

class FetchUser

  def call(env)
    handle_request(env['REQUEST_METHOD'], env['PATH_INFO'], env['QUERY_STRING'])
  end

  private

    def handle_request(method, route, query)
      if method == "GET" && route == "/getusers"
        user_params = Rack::Utils.parse_nested_query(query)
        user_data   = generate_response(user_params)
        display(user_data)
      elsif method == "GET" && route == "/"
        login
      else
        method_not_allowed(method, route)
      end
    end

    def display(user_data)
      [200, { "Content-Type" => "application/json" }, [user_data]]
    end

    def login
      [200, {}, ["Logged in successfully"]]
    end

    def method_not_allowed(method, route)
      [405, {}, ["Method not allowed for: #{method} and route #{route}"]]
    end

    def generate_response(params)
      db  = db_conn
      user_data = []

      db[:users].select(:name, :email).where(name: "#{params["name"]}").all.each do |row|
        user_data << {name: row[:name], email: row[:email]}
      end
      user_data << "No record of #{params["name"]} found" if user_data.empty?
      { user_data: user_data }.to_json
    end

    def db_conn
      Sequel.postgres(database: 'testdb', user: 'postgres')
    end

end
