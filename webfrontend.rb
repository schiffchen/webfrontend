require 'rubygems'
require 'sinatra'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: "mysql2",
  host: ENV["DB_HOST"],
  database: ENV["DB_DATABASE"],
  username: ENV["DB_USER"],
  password: ENV["DB_PASSWORD"]
)

class Player < ActiveRecord::Base
  has_many :statistics, :foreign_key => :winner_pid
  # has_many :wins, :through => :statistics, :foreign_key => :winner_pid
end

class Statistic < ActiveRecord::Base
  belongs_to :player, :primary_key => :winner_pid
end

get '/' do
  @players = Player.all().sort do |x,y|
    x.statistics.size <=> y.statistics.size
  end
  @players.reverse!
  
  erb :index
end

get '/anonlogin.json' do
  content_type :json
  { :jid => 'anonymous@battleship.me',
    :password => '4080da143eca2ca421d25e4ee9bf1ec5d7b0ddbd',
    :resource => [Time.now.to_i, Random.rand(1337)].join}.to_json
end