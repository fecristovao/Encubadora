class ControladorController < ApplicationController
	def list
		Dado.get_dados
		@dados = Dado.all
		
	end
end
