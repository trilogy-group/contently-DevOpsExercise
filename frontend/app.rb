require 'httparty'
require 'sinatra'
require 'logger'
require 'pg'

set :bind, '0.0.0.0'

log = Logger.new(STDERR)

get '/ping' do
	'pong'
end

get '/' do
	log.info("Received request")

	begin
		log.info("Loading days since last accident")
		conn = PGconn.open(
			dbname: ENV['POSTGRES_DB'] || 'example',
			host: ENV['POSTGRES_HOST'] || 'localhost',
			user: ENV['POSTGRES_USER'] || 'user',
			password: ENV['POSTGRES_PASSWORD'] || 'password'
		)
		res  = conn.exec('SELECT accident_date FROM accidents ORDER BY accident_date DESC;')
		days_since_last_accident = (Date.today - Date.parse(res.getvalue(0,0))).to_i
	rescue => err
		days_since_last_accident = '???'
		log.error("Failed while retrieving days since last accident")
		log.error(err)
	end

	begin
		log.info("Loading gifs")
		gifs = HTTParty.get("http://#{ENV['BACKEND_HOST'] || 'localhost'}:#{ENV['BACKEND_PORT'] || '5000'}/get-gifs").to_a
		puts gifs
	rescue => err
		gifs = nil
		log.error("Failed while retrieving gifs")
		log.error(err)
	end

	erb :index, locals: {
		gifs: gifs, 
		days_since_last_accident: days_since_last_accident
	}
end