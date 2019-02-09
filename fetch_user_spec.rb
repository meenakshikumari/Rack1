require 'rspec'
require 'rack'
require_relative 'fetch_user'

RSpec.describe 'FetchUser' do

  context "get to /getusers" do
    let(:app)      { FetchUser.new }
    let(:env)      { { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/getusers" , "QUERY_STRING" => "name=User3"} }
    let(:response) { app.call(env) }
    let(:status)   { response[0] }
    let(:body)     { response[2][0] }

    it "returns the status 200" do
      expect(status).to eq 200
    end

    it "returns the user_data" do
      user_data = "{\"user_data\":[{\"name\":\"User3\",\"email\":\"user3@gmail.com\"},{\"name\":\"User3\",\"email\":\"user31@gmail.com\"},{\"name\":\"User3\",\"email\":\"user32@gmail.com\"}]}"
      expect(body).to eq user_data
    end

    it "returns no user found when user not present" do
      env["QUERY_STRING"] = "User7"
      response = app.call(env)
      status   = response[0]
      body     = response[2][0]
      expect(status).to eq 200
      expect(body).to eq "{\"user_data\":[\"No record of  found\"]}"
    end
  end

  context "get to /" do
    it "returns the body after successfully Login" do
      env      = { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/" }
      response = FetchUser.new.call(env)
      status   = response[0]
      body     = response[2][0]
      expect(status).to eq 200
      expect(body).to eq "Logged in successfully"
    end
  end

  context "methods not allowed" do

    it "returns no method allowed for wrong path" do
      env      = { "REQUEST_METHOD" => "GET", "PATH_INFO" => "/getname" }
      response = FetchUser.new.call(env)
      status   = response[0]
      body     = response[2][0]
      expect(status).to eq 405
      expect(body).to eq "Method not allowed for: GET and route /getname"
    end

    it "returns no method allowed for other method" do
      env      = { "REQUEST_METHOD" => "POST" }
      response = FetchUser.new.call(env)
      status   = response[0]
      body     = response[2][0]
      expect(status).to eq 405
      expect(body).to eq "Method not allowed for: POST and route "
    end
  end
end