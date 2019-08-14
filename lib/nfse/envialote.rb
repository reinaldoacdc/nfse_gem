require 'mustache'
require 'savon'
require 'xmldsig'
require 'nokogiri'

module Nfse

    class EnviaLote < Mustache
        attr_accessor :wsdl, :xml_lote

        def initialize(wsdl, xml_lote)
           self.template_path = File.expand_path("../../templates/", __FILE__)

            @wsdl = wsdl
            @xml_lote = xml_lote
        end

        def enviar_lote_rps()
            client = Savon.client(wsdl: @wsdl)   

            self.xml_lote = self.assinar_xml(self.xml_lote.render, 'cert.pem')        
            puts self.render
            export_xml(self.render, 'teste-signed.xml')
            response = client.call(:recepcionar_lote_rps, xml: self.render)
            data = response.body
            #puts data
            return data[:recepcionar_lote_rps_response][:recepcionar_lote_rps_result]                
        end
    
        def assinar_xml(xml_original, certificado)
            xml = sign_xml(xml_original, certificado)        
            xml = add_cert_to_xml(xml, certificado, "//ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509Certificate")
            #export_xml(xml, 'teste-signed.xml')
            return xml
            
        end

        private

        def load_xml(xml_input)
          Nokogiri::XML(File.open(xml_input)).to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML)
        end
         
        def sign_xml(unsigned_xml, pem_file)
          private_key = OpenSSL::PKey::RSA.new(File.read(pem_file))
          unsigned_document = Xmldsig::SignedDocument.new(unsigned_xml)
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
         
        def export_xml(xml_text, xml_file)
          File.write(xml_file, xml_text)
        end
      




    end
end