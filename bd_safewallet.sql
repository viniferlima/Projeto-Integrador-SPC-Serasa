create database safewallet;
use safewallet;
create table pessoa_fisica(
cpf_cli varchar(11) not null,
senha varchar(20) not null,
sexo char(1) not null,
data_nascimento date not null,
cidade varchar(100) not null,
estado varchar(100) not null,
Check(sexo = 'F' or 'M'),
primary key(cpf_cli)
);
create table fonte(
id_fonte int not null,
nome_comercial varchar(200) not null unique,
primary key(id_fonte)
);

create table modalidade(
cod_modalidade int not null,
descricao_modalidade varchar(250) not null,
primary key(cod_modalidade)
);

create table operacoes(
id_operacao int not null,
cpf_cli varchar(11) not null,
tipo_cli char(1) not null,
id_fonte int not null,
numero_contrato int not null,
cod_modalidade int not null,
qtd_parcelas int not null,
data_vct_ult_pcl date not null,
data_contrato date not null,
vlr_total_parcelado decimal(10,2) not null default(0.00),
vlr_total_consorcio decimal(10,2) not null default(0.00),
sdo_ddr_cc_consorcio decimal(10,2) not null default(0.00),
primary key(id_operacao, numero_contrato, tipo_cli),
Check(tipo_cli = 'F' or 'J')
);

ALTER TABLE operacoes ADD FOREIGN KEY (cpf_cli) REFERENCES pessoa_fisica(cpf_cli);
ALTER TABLE operacoes ADD FOREIGN KEY (id_fonte) REFERENCES fonte(id_fonte);
ALTER TABLE operacoes ADD FOREIGN KEY (cod_modalidade) REFERENCES modalidade(cod_modalidade);

create table movimento(
id_operacao int not null,
cpf_cli varchar(11) not null,
tipo_cli char(1) not null,
id_fonte int not null,
numero_contrato int not null,
data_venc date not null,
qtd_pcl_vnc int not null,
qtd_pcl_pgr int not null,
vlr_total_fat decimal(10,2) not null default(0.00),
vlr_min_fat decimal(10,2) not null default(0.00),
vlr_pcl decimal(10,2) not null default(0.00),
tipo_movimento varchar(50) not null,
periocidade varchar(20) null,
primary key(data_venc),
Check(periocidade = 'mensal' or 'anual' or 'semestral')
);
ALTER TABLE movimento ADD FOREIGN KEY (id_operacao) REFERENCES operacoes(id_operacao);
ALTER TABLE movimento ADD FOREIGN KEY (cpf_cli) REFERENCES pessoa_fisica(cpf_cli);
ALTER TABLE movimento ADD FOREIGN KEY (id_fonte) REFERENCES fonte(id_fonte);

create table pagamento(
id_operacao int not null,
cpf_cli varchar(11) not null,
tipo_cli char(1) not null,
id_fonte int not null,
numero_contrato int not null,
data_venc date not null,
data_pagamento date not null,
vlr_pago decimal(10,2) not null default(0.00),
cod_modalidade int not null
);
ALTER TABLE pagamento ADD FOREIGN KEY (id_operacao) REFERENCES operacoes(id_operacao);
ALTER TABLE pagamento ADD FOREIGN KEY (cpf_cli) REFERENCES pessoa_fisica(cpf_cli);
ALTER TABLE pagamento ADD FOREIGN KEY (id_fonte) REFERENCES  fonte(id_fonte);
ALTER TABLE pagamento ADD FOREIGN KEY (data_venc) REFERENCES movimento(data_venc);
ALTER TABLE pagamento ADD FOREIGN KEY (cod_modalidade) REFERENCES modalidade(cod_modalidade);
