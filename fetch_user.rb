require 'sequel'

class FetchUser

  def call(env)
    process(env['REQUEST_METHOD'], env['PATH_INFO'], env['QUERY_STRING'])
  end

  private

    def process(method, route, query)
      if method == "GET"
        case route
        when "/getusers"
          user_params = Rack::Utils.parse_nested_query(query)
          user_data   = generate_response(user_params)
          display(user_data)
        when "/"
          login
        else
          method_not_allowed(method, route)
        end
      else
        method_not_allowed(method, route)
      end
    end

    def generate_response(params)
      db  = db_conn
      user_data = []

      db[:users].select(:name, :email).where(name: "#{params["name"]}").each do |row|
        user_data << {name: row[:name], email: row[:email]}
      end
      user_data << "No record of #{params["name"]} found" if user_data.empty?
      { user_data: user_data }.to_json
    end

    def db_conn
      Sequel.postgres(database: 'testdb', user: 'postgres')
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
end
