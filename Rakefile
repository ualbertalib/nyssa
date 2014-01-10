desc "Pull sfx2sirsi data down from bromyard"
task :fetch_data do
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/holderr.txt > data_scripts/data/holderr.txt`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/matchissn.txt > data_scripts/data/matchissn.txt`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/badissn.txt > data_scripts/data/badissn.txt`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/notSFX.txt > data_scripts/data/notSFX.txt`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/notSIR > data_scripts/data/notSIR`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/data/sfxdata.xml > data_scripts/data/sfxdata.xml`   
end

