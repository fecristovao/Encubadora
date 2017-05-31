require 'open-uri'

class Dado < ApplicationRecord
	def self.get_dados
		pagina = open("http://casardo.ddns.net:8080").read

		pagina = pagina.scan(/<br\/>Atual: (.*?)<br\/>/)
		pagina[0] = pagina[0].to_s.gsub!('["', "").gsub!('"]', "").gsub(" C", "")
		pagina[1] = pagina[1].to_s.gsub!('["', "").gsub!('"]', "").gsub(" %", "")

		novo = Dado.new
		novo.temperatura = pagina[0]
		novo.umidade = pagina[1]

		novo.save
	end
end
