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
                  xml << obj.render
                end
              end
        end    

    end

end