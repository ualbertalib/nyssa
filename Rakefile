desc "Pull sfx2sirsi data down from bromyard"
task :fetch_data do
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/holderr.txt > data/holderr.txt`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/matchissn.txt > data/matchissn.txt`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/badissn.txt > data/badissn.txt`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/notSFX.txt > data/notSFX.txt`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/notSIR > data/notSIR`
  `curl http://resolver.library.ualberta.ca/sfx2sirsi/data/sfxdata.xml > data/sfxdata.xml`   
end

