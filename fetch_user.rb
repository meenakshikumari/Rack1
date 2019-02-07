require 'sequel'

class FetchUser

  def call(env)
    handle_request(env['REQUEST_METHOD'], env['PATH_INFO'], env['QUERY_STRING'])
  end

  private
    def handle_request(method, path, query)
      if method == "GET" && path == "/getusers"
        params = Rack::Utils.parse_nested_query(query)
        db  = db_conn
        arr = []
        db[:users].select(:name, :email).where(name: "#{params["name"]}").all.each do |row|
          arr << {name: row[:name], email: row[:email]}
        end

        json = { data: arr }.to_json
        get(json)
      else
        method_not_allowed(method, path)
      end
    end

    def get(json)
      [200, { "Content-Type" => "application/json" }, [json]]
    end

    def method_not_allowed(method, path)
      [405, {}, ["Method not allowed for: #{method} and path #{path}"]]
    end

    def db_conn
      return Sequel.postgres(database: 'testdb', user: 'postgres')
    end
end
