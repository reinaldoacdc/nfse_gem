require 'mustache'

module Nfse
    module Envio

        class Lote < Mustache
            attr_accessor :id, :numero_lote, :cnpj, :inscricao_municipal, :quantidade, :lista_rps

            def initialize(args)
                self.template_path = File.expand_path("../../templates/", __FILE__)
                args = defaults.merge(args)

                @lista_rps = []
                @id = args[:id]
                @numero_lote = args[:numero_lote]
                @cnpj = args[:cnpj]
                @inscricao_municipal = args[:inscricao_municipal]                
            end

            def quantidade
                @quantidade = @lista_rps.size
            end

            def defaults
                {id: 'assinar'}
            end

            def add_rps(rps)
                @lista_rps << rps
            end

            def render_rps
                @lista_rps.reduce('') do |xml,obj|
                    xml << assinar_xml(obj.render, 'cert.pem').gsub('<?xml version="1.0"?>', '')
                end
            end

            def assinar_xml(xml_original, certificado)
                xml = sign_xml(xml_original, certificado)        
                xml = add_cert_to_xml(xml, certificado, "//ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509Certificate")
                return xml            
            end
    
            private
            def sign_xml(unsigned_xml, pem_file)
              private_key = OpenSSL::PKey::RSA.new(File.read(pem_file))
              unsigned_document = Xmldsig::SignedDocument.new(unsigned_xml, id_attr: "Id")
              unsigned_document.sign(private_key)
            end
             
            def add_cert_to_xml(signed_xml, pem_file, path)
              signed_xml = Nokogiri::XML(signed_xml)
             
              certificate = '';
              OpenSSL::X509::Certificate.new(File.read(pem_file)).to_pem.each_line do |line|
                certificate += line unless /^-{5}/.match(line)
              end
             
              signed_xml.xpath(path, {"ds" => "http://www.w3.org/2000/09/xmldsig#"}).each do |element|          
                element.content = certificate
              end
              signed_xml.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
            end
        end    

    end

end