desc "Pull sfx2sirsi data down from bromyard"
task :fetch_data do
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/holderr.txt > data/holderr.txt`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/matchissn.txt > data/matchissn.txt`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/badissn.txt > data/badissn.txt`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/notSFX.txt > data/notSFX.txt`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/notSIR > data/notSIR`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/data/sfxdata.xml > data/sfxdata.xml`   
end

desc "Create Sirsi Only records" 
task :sirsi_records do
  `ruby data_scripts/main.rb sirsi data_scripts/data/notSFX.txt data_scripts/data/sirsi_solr.xml`
end

desc "Create SFX records" 
task :sfx_records do
  `ruby data_scripts/main.rb sfx data_scripts/data/sfxdata.xml data_scripts/data/matchissn.txt data_scripts/data/badissn.txt data_scripts/data/holderr.txt data_scripts/data/summary_holdings data_scripts/data/solr.xml`
end
