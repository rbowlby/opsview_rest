require 'spec_helper'

describe OpsviewRest do

  let(:opsview_rest) { OpsviewRest.new("https://example.com", :username => "hi", :password => "hello") }

  before :each do
    stub_request(:post, "https://example.com/rest/login").
    with(:body => "{\"username\":\"hi\",\"password\":\"hello\"}",
      :headers => {'Content-Length'=>'36', 'Content-Type'=>'application/json'}).
    to_return(:status => 200, :body => fixture("login_key"))
  end

  describe '#new' do
    it 'can create an object with given parameters' do
      opsview_rest.username.should eql 'hi'
      opsview_rest.password.should eql 'hello'
      opsview_rest.rest.should be_an_instance_of RestClient::Resource
      opsview_rest.rest.url.should eql 'https://example.com/rest/'
    end
  end

  describe '#login' do
    it 'can login' do
      login_response = opsview_rest.login
      login_response.to_json.should eql "{\"token\":\"88dffa0974c364e56431697f257564fb1524b029\"}"
    end

    it 'stores login token from login command' do
      login_response = opsview_rest.login
      opsview_rest.rest.headers[:x_opsview_username].should eql 'hi'
      opsview_rest.rest.headers[:x_opsview_token].should eql '88dffa0974c364e56431697f257564fb1524b029'
    end
  end

  describe '#list' do
    it 'returns list of hosts by default' do
      stub_request(:get, "https://example.com/rest/config/host?rows=all").
         with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'X-Opsview-Token'=>'88dffa0974c364e56431697f257564fb1524b029', 'X-Opsview-Username'=>'hi'}).
         to_return(:status => 200, :body => fixture('list'))

      list_response = opsview_rest.list
      list_response.to_s.should include "Network - Base", "Monitoring Servers", "/images/logos/opsview_small.png", "Application - Opsview Master"
    end

    it 'returns a full list for a given value' do
      stub_request(:get, "https://example.com/rest/config/hosttemplate?rows=all").
         with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'88dffa0974c364e56431697f257564fb1524b029', 'X-Opsview-Username'=>'hi'}).
         to_return(:status => 200, :body => fixture('list_hosttemplate'))

      list_response_hosttemplate = opsview_rest.list(:type => 'hosttemplate')
      list_response_hosttemplate.to_s.should include "Opsview Housekeeping Cronjob Monitor", "Microsoft Active Directory", "Apache current requests"
    end
  end

  describe '#reload' do
    it 'returns current reload status' do
      pending 'Gives no response'
      stub_request(:get, "https://example.com/rest/reload").
         with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Opsview-Token'=>'88dffa0974c364e56431697f257564fb1524b029', 'X-Opsview-Username'=>'hi'}).
         to_return(:status => 200, :body => fixture('reload'))

      opsview_rest.reload
    end
  end

  describe '#find' do
    it 'returns an error if name is nil' do
      expect {opsview_rest.find}.to raise_error ArgumentError, "Need to specify the name of the object."
    end
  end

  describe '#purge' do
    it 'returns an error if name is nil' do
      expect {opsview_rest.purge}.to raise_error ArgumentError, "Need to specify the name of the object."
    end
  end

end