require 'nfse_gem'

#wsdl = 'http://servicosweb.itabira.mg.gov.br:90/NFSe.Portal.Integracao.Teste/Services.svc?singleWsdl'
#puts Nfse::ConsultaLote.new(wsdl, '02395172000137', '12345678', '111111').consultar()


lote = Nfse::Envio::Lote.new( '5abc', 1, '02395172000137', '12345678', 1)
rps = Nfse::Envio::Rps.new(1, 1, 2)

prestador = Nfse::Envio::Prestador.new('02395172000137', '12345678', 'Razao Social')
rps.prestador = prestador

tomador = Nfse::Envio::Tomador.new( cnpj: '35606203847', razao_social: 'Reinaldo',
                                    endereco: 'Rua dos Figos', endereco_numero: '96',
                                    complemento: 'N/A', bairro: 'Vila Maria', 
                                    cod_cidade: '3550308', uf: 'SP',
                                    telefone: '96838-9078', email: 'reinaldoacdc@gmail.com' )

rps.tomador = tomador
                                    
lote.add_rps(rps)
puts lote.render
