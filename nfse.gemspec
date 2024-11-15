require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
    gem.authors = ["Reinaldo ACDC"]
    gem.name = %q{nfse}
    gem.version = Nfse::Version::CURRENT
    gem.date = %q{2019-08-27}
    gem.summary = %q{Gem para emissão de notas fiscais}
    gem.files = ["./lib/nfse_gem.rb"]
    gem.files += ['./lib/municipios.json']
    gem.files += Dir['./lib/nfse/*.rb']
    gem.files += Dir['./lib/danfe/*.rb']        
    gem.files += Dir['./lib/templates/**/*.mustache']
    gem.require_paths = ["./lib"]


    gem.add_dependency 'mustache', '~> 0.99'
    gem.add_dependency 'savon', '~> 2.15.0'
    gem.add_dependency 'xmldsig', '~> 0.6.6'
    
    gem.add_dependency "nokogiri", "~> 1.8"
    gem.add_dependency "prawn", "~> 2.5"
    gem.add_dependency "prawn-table", "~> 0.2"    
  end