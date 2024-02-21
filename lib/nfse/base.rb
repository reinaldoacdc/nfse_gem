module Nfse

    class Base < Mustache

        attr_accessor :code_ibge

        def get_wsdl
            if Rails.env.production?
                {
                    '3131703' => 'http://servicosweb.itabira.mg.gov.br:90/nfse.portal.integracao/services.svc?Wsdl',                
                    '3106200' => 'https://bhissdigitalws.pbh.gov.br/bhiss-ws/nfse?wsdl'
                }
            else
                {
                    '3106200' => 'https://bhisshomologa.pbh.gov.br/bhiss-ws/nfse?wsdl'
                }
            end
        end
    end
end