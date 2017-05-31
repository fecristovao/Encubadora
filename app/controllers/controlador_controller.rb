class ControladorController < ApplicationController
	def index
		@titulo = "Encubadora - #{Date.today.strftime("%d/%m/%y")}"
		@dados = graficos
	end

	def day

		ano = params[:year]
		mes = params[:month]
		dia = params[:day]
		@titulo = "Encubadora - #{dia}/#{mes}/#{ano}"
		@dados = graficos(ano, mes, dia)

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

	private

		def graficos(ano=0, mes=0, dia=0)
			
			if (ano!=0 && mes!=0 && dia!=0)
				data = Date.parse("#{ano}-#{mes}-#{dia}")
				dados = Dado.where(:created_at => data..data+	1.day)
			else
				dados = Dado.where(:created_at => Date.today..Date.today+1.day)
			end

			temperaturas = {}
			umidades = {}
			anterior_t = 0
			anterior_u = 0
			dados.each do |data|
				if anterior_t != data.temperatura || data == dados.last
					temperaturas[data.created_at] = data.temperatura
					anterior_t = data.temperatura
				end
				if anterior_u != data.umidade || data == dados.last
					umidades[data.created_at] = data.umidade
					anterior_u = data.umidade
				end
			end

			retorno = {
				:temperatura => temperaturas,
				:umidade => umidades
			}

			return retorno
		end

		def intervalos(data)
			

		end
end
