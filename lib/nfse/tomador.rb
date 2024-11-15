require 'mustache'

module Nfse
    module Envio

        class Tomador < Mustache
            attr_accessor :cpf_cnpj, :cpf, :cnpj, :razao_social, :endereco, :endereco_numero,
                          :complemento, :bairro, :cod_cidade, :uf, :cep,
                          :telefone, :email


            def initialize(args)
                self.template_path = File.expand_path("../../templates/", __FILE__)
                
                @cpf_cnpj = args[:cpf_cnpj]                
                @razao_social = args[:razao_social]
                @endereco = args[:endereco]
                @endereco_numero = args[:endereco_numero]
                @complemento = args[:complemento]
                @bairro = args[:bairro]
                @cod_cidade = args[:cod_cidade]
                @uf = args[:uf]
                @cep = args[:cep]
                @telefone = args[:telefone]
                @email = args[:email]

                self.formatted_doc()
            end

            def formatted_doc
                doc = @cpf_cnpj
                doc = doc.tr('.', '').tr('-', '').tr('/', '')
                
                if doc.length == 14
                    @cnpj = doc
                else 
                    @cpf = doc
                end
            end 

            def has_address?
                [@endereco, @endereco_numero, @bairro, @cod_cidade, @uf, @cep].all?
            end

            def has_contact?
                [@telefone, @email].any?
            end

            def complemento
                if @complemento.empty? then nil else @complemento end
            end

            def cep 
                if @cep.empty? then nil else @cep.scan(/\d/).join end    
            end
        end

    end
end