--INSERÇÕES

--inserção de CEP
--dados ( id_cep | rua | bairro | cidade | estado )
execute inserir_cep 04438100, 'Rua Doutor Epaminondas Barra', 'Vila do Castelo', 'São Paulo', 'SP'
--teste de erro
execute inserir_cep 04438100, 'Rua Doutor Epaminondas Barra', 'Vila do Castelo', 'São Paulo', 'SP'

execute inserir_cep 11015000, 'Avenida Conselheiro Nébias', 'Paquetá', 'Santos', 'SP'
execute inserir_cep 17064480, 'Rua Sargento Leôncio Ferreira dos Santos', 'Parque Roosevelt', 'Bauru', 'SP'

select * from CEP

----------------------------------------------------------------------------------------------------------

--inserção de CLIENTE
--dados ( nome | n_cep | cpf_cnpj | insc_municipal | numero_end | compl_end )
execute inserir_cliente 'Fábio Marcos da Mata', 04438100, '39615899763', '128790363445', '567', '50'
execute inserir_cliente 'Stella Carolina Ribeiro', 11015000, '19876703617', '301559705710', '998', '90'
execute inserir_cliente 'Yago Elias Juan Aragão', 17064480, '50535061080', '024000951973', '451', '87'
execute inserir_cliente 'Jéssica Beatriz Baptista', 11015000,'53649231182', '28472941730', '470', '68'

--teste de erro do registro do cep
execute inserir_cliente 'Manoel', 04438101, '39615899763', '128790363445', '567', '50'

select * from CLIENTE

delete from CLIENTE

DBCC CHECKIDENT (CLIENTE, RESEED, 0)

----------------------------------------------------------------------------------------------------------

--inserção de NOTA_FISCAL
--dados ( id_cliente | dt_emissao )
execute inserir_nota_fiscal 1, '20220203 12:02:01 AM'
execute inserir_nota_fiscal 2, '20220205 12:06:07 AM'
execute inserir_nota_fiscal 3, '20220207 12:10:10 AM'
execute inserir_nota_fiscal 1, '20220207 10:10:10 AM'

select * from NOTA_FISCAL

delete from nota_fiscal

dbcc CHECKIDENT (NOTA_FISCAL, RESEED, 0)

----------------------------------------------------------------------------------------------------------

--inserção de IMPOSTO
--dados ( sigla | descrico | aliquota )
execute inserir_imposto 'IRPJ', 'Tributo cobrado de organizações que têm cadastro jurídico, sociedade mista, estatais, empreendedoras', 0.15
execute inserir_imposto 'CSLL', 'Tributo federal com destinação ao financiamento da seguridade social', 0.10

--teste de erro do registro da sigla
execute inserir_imposto 'IRPJ', 'Tributo cobrado de organizações que têm cadastro jurídico, sociedade mista, estatais, empreendedoras', 0.15

select * from IMPOSTO

----------------------------------------------------------------------------------------------------------

--inserção de SERVICO
--dados ( descricao | preco_unit | unidade )
execute inserir_servico 'leite', 2.45, 1
execute inserir_servico 'chocolate', 5.45, 1
execute inserir_servico 'bolacha', 3.45, 1
execute inserir_servico 'salgadinho', 7.45, 1

--teste de erro do registro da descricao
execute inserir_servico 'salgadinho', 7.45, 1

select * from SERVICO

----------------------------------------------------------------------------------------------------------

select * from SERVICO
select * from NOTA_FISCAL

SELECT NF.id_nf, S.id_servico FROM NOTA_FISCAL AS NF, SERVICO AS S WHERE NF.id_nf = 1 AND S.id_servico = 1

--inserção de SERVICO_NF
--dados ( id_nf | id_servico | qtde )
execute inserir_servico_nf 1, 1, 3
--teste de erro
execute inserir_servico_nf 1, 1, 3
execute inserir_servico_nf 80, 1, 3
execute inserir_servico_nf 1, 80, 3
execute inserir_servico_nf 80, 80, 3

execute inserir_servico_nf 2, 2, 2
execute inserir_servico_nf 3, 3, 1
execute inserir_servico_nf 4, 2, 3

select * from SERVICO_NF
select * from SERVICO

----------------------------------------------------------------------------------------------------------

--inserção de IMP_SERVICO
--dados ( id_imposto | id_servico | id_nf )
execute inserir_imp_servico 1, 1, 1
--teste de erro
execute inserir_imp_servico 1, 1, 1
execute inserir_imp_servico 80, 1, 3
execute inserir_imp_servico 1, 80, 3
execute inserir_imp_servico 1, 1, 80
execute inserir_imp_servico 80, 80, 80

execute inserir_imp_servico 1, 2, 2
execute inserir_imp_servico 2, 3, 3
execute inserir_imp_servico 2, 2, 4

select * from IMP_SERVICO
select * from IMPOSTO

----------------------------------------------------------------------------------------------------------

--CONSULTAS

--1. Listar todos os clientes cadastrados em ordem crescente, mostrando todos os seus dados relacionados.

execute select_1


--2. Listar todos os clientes que possuem alguma compra; mostre o nome do cliente, e a quantidade de compras feitas nos últimos 30 dias.

execute select_2


--3. Listar todas as vendas mostrando os serviços, quantidades e valores.

execute select_3


--4. Faça mais duas consultas a seu critério, que permita a utilização de comandos avançados de JOIN.
--4.1. Mostrar todos os clientes que fizeram ou não uma compra, e o total gasto por aqueles que compraram.

execute select_4_1


--4.2. Mostrar todos os servicos/produtos que foram e não foram vendidos, e o total de cada um que foram.

execute select_4_2


--APAGAR DADOS
execute delete_cep
execute delete_cliente
execute delete_nota_fiscal
execute delete_imposto
execute delete_servico
execute delete_servico_nf
execute delete_imp_servico

select*from CEP
select*from CLIENTE
select*from SERVICO
select*from IMPOSTO
select*from NOTA_FISCAL
select*from SERVICO_NF
select*from IMP_SERVICO

drop table IMP_SERVICO
drop table SERVICO_NF
drop table NOTA_FISCAL
drop table IMPOSTO
drop table SERVICO
drop table CLIENTE
drop table CEP
