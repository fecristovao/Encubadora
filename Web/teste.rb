require 'date'
require 'chronic'
require 'pp'

temperaturas = {}
for i in 0..10
	hora = Time.now + i*60*60	
	temperaturas[hora] = i
end

variacao = {}

pp temperaturas

for i in 1..temperaturas.size-1
	 data = temperaturas.keys[i]
	 temperatura = temperaturas.values[i] - temperaturas.values[i-1]
	 variacao[data] = temperatura
end

pp variacao