class ControladorController < ApplicationController
	def index
		@dados = Dado.all.order('created_at DESC').where(:created_at => Date.today..Date.today+1.day)
		@temperaturas = {}
		@umidades = {}

		@dados.each do |data|
			@temperaturas[data.created_at] = data.temperatura
			@umidades[data.created_at] = data.umidade
		end
	end

	def day
		data = Date.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
		puts data
		@dados = Dado.all.order('created_at DESC').where(:created_at => data..data+1.day)
		@temperaturas = {}
		@umidades = {}

		@dados.each do |data|
			@temperaturas[data.created_at] = data.temperatura
			@umidades[data.created_at] = data.umidade
		end

		render :index
	end

	def list
		#Dado.get_dados
		@dados = Dado.all
		@atr = {
			:max_t => 0,
			:min_t => 999,
			:max_u => 0,
			:min_u => 999,
			:media_t => 0,
			:media_u => 0
		}



		@dados.each do |dado|
			if @atr[:max_t] <= dado.temperatura
				@atr[:max_t] = dado.temperatura
			end
			
			if @atr[:max_u] <= dado.umidade
				@atr[:max_u] = dado.umidade
			end
			
			if @atr[:min_t] >= dado.temperatura
				@atr[:min_t] = dado.temperatura
			end

			if @atr[:min_u] >= dado.umidade
				@atr[:min_u] = dado.umidade
			end

			@atr[:media_u] = @atr[:media_u] + dado.umidade
			@atr[:media_t] = @atr[:media_t] + dado.temperatura

		end
			@atr[:media_u] = @atr[:media_u]/@dados.count
			@atr[:media_t] = @atr[:media_t]/@dados.count


	end
end
