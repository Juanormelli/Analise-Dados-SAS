/*
Programa:ByEx5.SAS
Autor: Juan Ormelli de Medeiros
Data: 10/03/2020
Versão: 1.01

Ajustes feitas na Atualização do Codigo:
Adicionado o Proc Sort por Depto a fim de corrigir
bug ao relizar datastep AcumuladoDepto

Descrição: Solução Atividade 5 - uso das quebras de grupo utilizando DataSteps


*/

/*Organizando os dados Para Realizar o Merge*/
proc sort data=cgdexcel.produtos out=work.produtosort;
	by CodProduto;
run;

proc sort data=cgdexcel.vendas out=work.vendassort;
	by CodProduto;
run;
/*Realizando o Merge Entre Vendas E produtos*/
data GroupTable;
	merge work.vendassort (in=a)
	  	work.produtosort(in=b);
	by CodProduto;
	if a=b;
run;

proc sort data=work.grouptable;
	by CodDepto;
run;

/*Organizando os dados paa realizar o Acumulado Grupo*/
proc sort data=work.grouptable;
	by CodGrupo;
run;
/*Realizando o Acumulado Grupo e Totalvendas */
data TesteTable;
	set work.grouptable;
	/*Definindo a Key a ser Utilizada*/
	by CodGrupo;
	/*Atribuindo a variavel first ao cod Produto e realizando a logica para o calculo*/
	if first.CodProduto then totalvendas=precounitario*qtdevendida ;
	else totalvendas=precounitario*qtdevendida;
	/*Atribuindo a variavel ao CODGRUPO e realizando a logica para o acumulado grupo*/
	if first.CodGrupo then AcumuladoGrupo = totalvendas;
	else AcumuladoGrupo+totalvendas;
/*Selecionand as colunas quedesejo manter na tabela final*/
	keep CodDepto CodGrupo DataVenda Descricao CodProduto AcumuladoGrupo 
	PrecoUnitario QtdeVendida totalvendas;
run;
/*Organizandoo dados para fazer o Acumulado Depto*/
proc sort data=work.testetable;
	by CodDepto;
run;
/*Realizando o Acumulado Depto e escolhendo onde vai ser salva a tabela final*/
LIBNAME cgdexcel BASE "/SASLibraries";
data cgdexcel.AttTesteTable;
	set work.testetable;
	by CodDepto;
	if first.CodDepto then AcumuladoDepto= totalvendas;
	else AcumuladoDepto+totalvendas;
run;
/*Realizando a impressao da tabela conforme modelo solicitado */
proc print data=cgdexcel.atttestetable;
	title bold "Exercicio 5 ";
	var CodDepto CodGrupo DataVenda Descricao  QtdeVendida PrecoUnitario totalvendas AcumuladoGrupo 
	AcumuladoDepto;
run;

