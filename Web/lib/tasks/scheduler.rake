desc "Pega os dados atuais"
task :get_dados => :environment do
  puts "Pegando dados as: #{Time.now}"
  Dado.get_dados
  #puts "done."
end