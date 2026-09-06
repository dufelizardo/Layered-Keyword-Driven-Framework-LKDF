*** Comments ***
    ViaCEP response schemas. Every field returned by the API is a string - including the "numeric-looking"
    ones (ddd, ibge, siafi, gia) - confirmed directly against the live API, not just the docs.
*** Variables ***
${ADDRESS_SCHEMA}         ${{{'required': ['cep', 'logradouro', 'bairro', 'localidade', 'uf'], 'types': {'cep': str, 'logradouro': str, 'complemento': str, 'unidade': str, 'bairro': str, 'localidade': str, 'uf': str, 'estado': str, 'regiao': str, 'ibge': str, 'gia': str, 'ddd': str, 'siafi': str}, 'enums': {}}}}
${CEP_NOT_FOUND_SCHEMA}   ${{{'required': ['erro'], 'types': {'erro': str}, 'enums': {}}}}
