require 'net/http'

url = URI.parse('http://casardo.ddns.net:8080')
pagina = Net::HTTP.get(url)


pagina = pagina.scan(/<br\/>Atual: (.*?)<br\/>/)

		
pagina[0] = pagina[0].to_s.gsub!('["', "").gsub!('"]', "").gsub(" C", "")
pagina[1] = pagina[1].to_s.gsub!('["', "").gsub!('"]', "").gsub(" %", "")
