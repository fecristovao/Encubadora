require 'open-uri'

pagina = open("http://casardo.ddns.net:8080").read
pagina = pagina.scan(/<br\/>Atual: (.*?)<br\/>/)
		
pagina[0] = pagina[0].to_s.gsub!('["', "").gsub!('"]', "").gsub(" C", "")
pagina[1] = pagina[1].to_s.gsub!('["', "").gsub!('"]', "").gsub(" %", "")
puts pagina[0]
