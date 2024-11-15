require 'xmldsig'

module Nfse

    class EnviaLote < Base
        attr_accessor :code_ibge, :lote, :xml_lote

        def initialize(code_ibge, lote)
           self.template_path = File.expand_path("../../templates/", __FILE__)

            @code_ibge = code_ibge
            @lote = lote
        end

        def enviar_lote_rps()
            wsdl = get_wsdl[@code_ibge]          
            client = Savon.client(
              wsdl: wsdl, 
              ssl_cert: OpenSSL::X509::Certificate.new(File.read('cert.pem')), 
              ssl_cert_key: OpenSSL::PKey::RSA.new(File.read('cert.pem'))
            )
            @xml_lote = self.assinar_xml(@lote.render, 'cert.pem').gsub('<?xml version="1.0"?>', '')
            #export_xml(self.render, 'teste-signed.xml')
            response = client.call(:gerar_nfse, xml: self.render)
            data = response.body[:gerar_nfse_response][:output_xml]
            #Tratar retorno com erros
            xml = Nokogiri::XML(data)
            if xml.xpath('//xmlns:MensagemRetorno').empty?
              return data
            else
              puts data
              return nil
            end
        end
    
        def assinar_xml(xml_original, certificado)
            xml = sign_xml(xml_original, certificado)        
            xml = add_cert_to_xml(xml, certificado, "//ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509Certificate")
            return xml            
        end

        private

        def load_xml(xml_input)
          Nokogiri::XML(File.open(xml_input)).to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
        end
         
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

          signed_xml.xpath(path, {"ds" => "http://www.w3.org/2000/09/xmldsig#"}).last.content = certificate

          signed_xml.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
        end
         
        def export_xml(xml_text, xml_file)
          File.write(xml_file, xml_text)
        end
      
    end
end