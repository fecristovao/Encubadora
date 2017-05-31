class ControladorController < ApplicationController
	def list
		#Dado.get_dados
		@dados = Dado.all.order('created_at DESC')
		@atr = {
			:max_t => 0,
			:min_t => 999,
			:max_u => 0,
			:min_u => 999,
			:media_t => 0,
			:media_u => 0
		}


		@temperaturas = {}
		@umidades = {}

		@dados.each do |data|
			@temperaturas[data.created_at] = data.temperatura
			@umidades[data.created_at] = data.umidade
		end


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
