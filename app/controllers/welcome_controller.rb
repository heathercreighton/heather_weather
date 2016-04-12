class WelcomeController < ApplicationController
  def test
 	response  = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/GA/Atlanta.json")

 	@location = response['location']['city']
 	@temp_f = response['current_observation']['temp_f']
 	@temp_c = response['current_observation']['temp_c']
 	@weather_icon = response['current_observation']['icon_url']

 	@weather_words = response['current_observation']['weather']
 	@forecast_link = response['current_observation']['forecast_url']
 	@real_feel =  response['current_observation']['feelslike_f'] 

  end

  	def index
  	@body_class = "default"

		@states = %w(HI AK CA OR WA ID UT NV AZ NM CO WY MT ND SD NE KS OK TX LA AR MO IA MN WI IL IN MI OH KY TN MS AL GA FL SC NC VA WV DE MD PA NY NJ CT RI MA VT NH ME DC PR)

		# puts states in alphabetical order
		@states.sort!
		@locations = Location.all



		if params[:city] != nil


			city = params[:city].gsub(" ", "_")

		  	response  = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/#{params[:state]}/#{city}.json")

		 	@location = response['location']['city']
		 	@temp_f = response['current_observation']['temp_f']
		 	@temp_c = response['current_observation']['temp_c']
		 	@weather_icon = response['current_observation']['icon_url']

		 	@weather_words = response['current_observation']['weather']
		 	@forecast_link = response['current_observation']['forecast_url']
		 	@real_feel =  response['current_observation']['feelslike_f'] 
		 	@image = response['current_observation']['image']['url']

		 	


		 	count = 0
		 	@locations.each do |loc|
		 		if params[:city].downcase  == loc.city.downcase && params[:state].downcase == loc.state.downcase
		 			count +=1
		 		end	
		 	end	

		 	if count == 0

			 	location = Location.new
			 	location.city = params[:city]
			 	location.state = params[:state]
			 	location.save
			 	@locations = Location.all	
		 	end
			if @weather_words == "Sunny" || @weather_words == "Clear"
				@body_class = "sunny"
			elsif @weather_words == "Snow"
				@body_class = "snow"
			elsif @weather_words.include?('Rain') || @weather_words == "Shower"	
				@body_class = "rain"

			elsif @weather_words == "Overcast" || @weather_words == "Mostly Cloudy"
				@body_class = "cloudy"
			elsif @weather_words.include?('Fog') 	
				@body_class = "foggy"	
			elsif @weather_words == "Partly Cloudy" || @weather_words == "Partly Sunny"
				@body_class = "partly_sunny"	
			else
				@body_class = "default_body"
			end		 	
		

		end



		
					

  end
end
