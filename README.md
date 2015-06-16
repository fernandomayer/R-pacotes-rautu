# R-pacotes-rautu

Criação de pacotes para o R: uma rápida introdução



## Motivação

Como já dizia [John M. Chambers][] quando criou a linguagem S
(predecessora do R), o objetivo da linguagen é

> "... to turn ideas into software, quickly and faithfully."

e transformar usuários em programadores de maneira rápida e
conveniente.

Se você já explorou um pouco mais do que o potencial básico do R,
certamente já criou sua própria função (ou várias funções) para fazer
alguma tarefa específica. A ideia é que se você tiver que realizar uma
tarefa muitas vezes, então deve criar uma função para fazer isso.

A criação de um pacote do R pode ter duas motivações principais:

* Agrupar e manter uma série de funções criadas por você e que são
  basicamente de uso próprio ou rotineiro.
* Compartilhar funções de novos métodos e/ou implementações que você
  tenha criado e queira disponibilizar para outras pessoas usarem.

Não raramente, um pacote de uso pessoal acaba se tornando útil para
outras pessoas e o autor disponibiliza para uso geral. O importante é
então saber como transformar suas funções em um pacote. E mais
importante ainda é saber como fazer isso se preocupando apenas com as
funções, ao invés de se preocupar com todo o processo de criação do
pacote.

A criação de um pacote no R pode ser feita de duas formas:

* Tradicional: usando os comandos padrões do R para criação de pacotes,
  como `R CMD build` para criar e `R CMD check` para conferir o pacote,
  ambos executados através de um terminal e não de uma sessão do R.
* Moderna: usando o pacote `devtools`, que possui funções para criar e
  conferir o pacote (inclusive para testar e documentar as funções) de
  dentro de uma sessão do R.

A maneira tradicional de criar pacotes no R é um pouco mais trabalhosa,
pois cada vez que você quiser checar se seu pacote está funcionando, é
necessário ir para um terminal e rodar os comandos por fora do R. Além
disso, se você quiser testar seu pacote após a instalação, será
necessário instalar de fato o pacote e carregá-lo com `library()`. O
grande problema é que durante o desenvolvimento de um pacote, esses
passos geralmente são repetidos muitas vezes, o que torna todo o
processo muito demorado.

O pacote `devtools` facilita todo esse processo, pois você pode
construir, checar, documentar (e conferir a documentação) de dentro da
própria sessão do R que você está desenvolvendo o pacote. Além disso
esse pacote também permite que, com uma função, você simule a instalação
do seu pacote na mesma sessão R, evitando ter que instalar e desinstalar
para testes todas as vezes.

Um outro aspecto fundamental de todo pacote é a sua documentação. Da
maneira tradicional, é necessário criar os arquivos `.Rd` e escrever
usando uma linguagem muito parecida com o LaTeX. Toda vez que você
quiser editar a documentação é necessário abrir esses arquivos e
modificá-los nesse formato. Para facilitar ainda mais a vida dos
programadores, existe o pacote `roxygen2`, que possibilita escrever a
documentação dentro da própria função `.R`, integrando código e
documentação em um único arquivo, e facilitando a edição das páginas de
ajuda. 

O pacote `roxygen2` pode ser utilizado também na abordagem tradicional
de criação de pacotes, eliminando uma etapa trabalhosa que é a de criar
os arquivos de documentação. No entanto, podemos usar todo o potencial
do `devtools` e do `roxygen2` juntos, e nos preocuparmos apenas com o
design das funções e não com todo o processo de criação do pacote em
si.

## Estrutura de um pacote

Basicamente um pacote do R é uma convenção para organizar e padronizar a
distribuição de funções extras do R. Todo pacote é composto
*obrigatoriamente* por apenas dois diretórios e dois arquivos de meta
dados:

* `R/`: um diretório contendo as funções em arquivos `*.R` (ex.:
  `foo.R`).
* `man/`: um diretório contendo a documentação (páginas de ajuda) de
  cada função do diretório acima. Os arquivos de documentação do R
  terminam com a extensão `.Rd` (ex.: `foo.Rd`).
* `DESCRIPTION`: um arquivo texto contendo as informações sobre o seu
  pacote: autor, licença, outros pacotes dependentes, ...
* `NAMESPACE`: um arquivo texto que informa quais funções do seu pacote
  serão exportadas, ou seja, aquelas que estarão disponíveis para o
  usuário, e quais funções são importadas de outros pacotes dos quais o
  seu depende.

Outros componentes que não são obrigatórios, mas podem estar presentes
no pacote são (nenhum deles serão abordados aqui):

* `tests/`: um diretório contendo scripts com testes unitários, rodados
  durante a criação do pacote, para testar se existe algum resultado não
  esperado sendo retornado por alguma de suas funções.
* `vignettes/`: um diretório que contém uma ou mais *vignettes*, que
  traduzidas literalmente são como "vinhetas", pequenos (ou mesmo
  grandes) textos que explicam com mais detalhes como os usuários podem
  usar as funções de seu pacote.
* `data/`: um diretório contendo arquivos de dados (normalmente em
  formato binário e comprimido do R, `.rda`), que podem ser usados como
  exemplos para aplicação das funções do pacote.

Caso você queira começar um pacote do início, as opções são: 1) criar
todos os componentes (diretórios e arquivos) manualmente e ir
alimentando com conteúdo, ou 2) usar a função `create()` do pacote
`devtools` para criar um "esqueleto" inicial com os arquivos e
diretórios fundamentais de um pacote. Portanto:


```r
library(devtools)
create("meupacote", rstudio = FALSE)
```

```
Error: Directory already exists
```

Como pode ser observado na saída acima, esse comando cria um diretório
chamado `meupacote`, contendo dois arquivos: `DESCRIPTION` e
`NAMESPACE`, e um diretório: `R/`


```
-rw-r--r-- DESCRIPTION
drwxr-xr-x man
-rw-r--r-- NAMESPACE
drwxr-xr-x R
```

Note que na mensagem de criação acima, o arquivo `DESCRIPTION` já é
preenchido com alguns campos padrão, sendo necessário apenas alterá-los
com as informações do seu pacote.

Abaixo serão especificados os detalhes para a criação de cada um dos
componentes obrigatórios criados acima.

## `DESCRIPTION`: Caracterização do pacote

O arquivo `DESCRIPTION` é quem caracteriza o seu pacote: que é (são)
o(s) autor(es), uma breve descrição do que ele faz, qual o tipo de
licença, quais pacotes são necessários para que o seu funcione, e mais
alguns detalhes.

Seguindo os campos do `DESCRIPTION` criados anteriormente com a função
`create()`, temos alguns detalhes:

```
Package: meupacote
```
É simplesmente o nome do seu pacote.

```
Title: What the Package Does (one line, title case)
```
Uma breve descrição (de uma linha) sobre o que o seu pacote faz.

```
Version: 0.0.0.9000
```
A versão inicia (ou atual do pacote). O versionamento de
qualquer pedaço de software é uma coisa muito importante e não há um
consenso de que exista um padrão para todos os casos. No entanto, nos
pacotes do R, recomenda-se que as versões sejam do tipo `x.y-z` ou
`x.y.z` onde `x` seria a versão "maior", `y` a versão "menor", e `z`
os "patches" (alterações menores no código, como correção de bugs por
exemplo).

```
Authors@R: person("First", "Last", email = "first.last@example.com", role = c("aut", "cre"))
```
O autor, ou os autores e contribuidores do pacote. Este campo pode ser
preenchido com a função `person()` do R, no formato que está
apresentada. Se tiver mais de um autor, eles podem ser concatenados com
a função `c()`, por exemplo, `c(person(...), person(...))`. O argumento
`role` é importante pois é ele que identifica o papel de cada autor no
desenvolvimento do pacote. Por padrão, é necessário ter um (e somente
um) autor `"aut"` e um mantenedor `"cre"`, que pode ou não ser a mesma
pessoa. Outros papéis, como por exemplo o de um contribuidor
(`"ctb"`), e outros detalhes dessa função estão em `?person`.

```
Description: What the package does (one paragraph)
```
Uma descrição um pouco mais detalhada sobre o que o seu pacote faz. É
preciso ter pelo menos duas frases completas (sim, o R confere isso),
mas não muito maior do que um parágrafo.

```
Depends: R (>= 3.2.0)
```
Qual a versão do R que o seu pacote depende. É sempre prudente colocar
uma versão que seja maior ou igual a versão que você está desevolvendo o
pacote.

```
License: What license is it under?
```
A licença é fundamental se você pretende compartilhar o seu
pacote. Algumas opções comuns são: `CC0` (nenhum tipo de restrição),
`MIT` (prevê atribuição mas é bastante permissiva), e `GPL-3` (a mais
utilizada, requer que qualquer trabalho derivado do seu seja distribuido
com a mesma licença). Para mais opções e detalhes sobre licenças de
software livre, consulte [choosealicense.com][].

```
LazyData: true
```
Essa opção somente é importante se você pretende distribuir algum
conjunto de dados com o seu pacote (arquivos `.rda` no diretório
`data/`). Com a opção acima, os dados só serão carregados se realmente
forem chamados (com a função `data()`), e não carregados na
inicialização do pacote. Isso garante mais agilidade para carregar o
pacote e economiza memória caso os dados não sejam utilizados
(especialmente se as bases de dadpos forem gandes).

Outros campos do arquivo `DESCRIPTION` que serão necessários caso seu
pacote possua dependências:

* `Imports:` uma lista, separada por vígulas, dos pacotes dos quais o
  seu pacote precisa para funcionar. Estes são os pacotes que o seu
  depende, portanto eles também serão instalados (se já não estiverem),
  quando o seu for instalado. Colocar um pacote nesse campo garante que
  o pacote estará **instalado**, mas não que ele será carregado toda que
  vez que o seu pacote for carregado. Para utilizar funções de outros
  pacotes corretamente é necessário especifições da forma
  `pacote::funcao()` ou então utilizar o arquivo `NAMESPACE` conforme
  veremos abaixo.
* `Suggests:` os pacotes listados aqui não serão instalados junto com o
  seu. Eles podem ser usados, mas não são necessários. Por exemplo, você
  pode usar um pacote apenas para usar alguma base de dados ou apenas
  uma função. Use esse campo apenas se o seu pacote puder funcionar
  mesmo sem os pacotes especificados.

Para podermos utilizar esse arquivo para de fato gerarmos um pacote de
exemplo ao final deste tutorial, vamos modificar alguns campos e
utilizar o seguinte arquivo `DESCRIPTION`:

```
Package: meupacote
Title: Um Pacote de Exemplo
Version: 0.0-1
Authors@R: person("Fernando", "Mayer", email = "fernando.mayer@example.com", role = c("aut", "cre"))
Description: Este pacote serve apenas de tutorial. Mais informacoes
	     podem ser encontradas no texto do github.
Depends: R (>= 3.2.0)
License: GPL-3
LazyData: true
```

## `R/`: Funções

O diretório `R/` irá conter apenas as funções (arquivos `.R`) do seu
pacote. As funções podem estar em vários arquivos `.R` separados (um
para cada função) ou em um (ou alguns) arquivo único. A escolha é mais
uma questão de preferência pessoal, mas como veremos mais adiante,
utilizar arquivos separados para as funções torna o processo de
documentação um pouco mais ágil, além de facilitar a manutenção do
pacote com o tempo.

Para exemplificar, vamos criar uma função simples para fazer a soma de
dois números, e colocá-la dentro do diretório `R/` com o nome `soma.R`


```r
soma <- function(x, y){
    x + y
}
```

Com a função pronta, possivelmente iremos testá-la, e para isso vamos
utilizar a função `load_all()` do pacote `devtools`. Portanto, de dentro
de uma seção do R:


```r
load_all()
```

```
## Loading meupacote
```

irá carregar todas as funções que estiverem dentro do diretório `R/`,
tornado-as disponíveis para uso. Note que seria o mesmo resultado se
utilizassemos a função `source("soma.R")` para carregar a função, no
entanto, se tivermos várias funções, e/ou estivermos testando alterações
em muitas delas, a função `load_all()` é bem mais conveniente. Basta
fazer as alterações nas funções `.R`, carregá-las com `load_all()`e
testar novamente. Esse processo geralmente se repete muitas vezes
durante o desenvolvimento de um pacote.

## `man/`: Documentação

Você deve ter notado que o diretório `man/` não é criado da mesma forma
que os demais quando utilizamos a função `create()` acima. Isso porque
esse diretório depende das funções que serão criadas dentro do diretório
`R/`. No entanto, ele é também é obrigatório para podermos criar um
pacote mínimo.

Como mencionado anteriormente, a documentação de funções do R segue um
formato muito parecido com o LaTeX (mas com alguns comandos
próprios). Cada função criada dentro do diretório `R/`, independente de
estar em um arquivo separado ou único (com várias funções), deve
**obrigatoriamente** ter um arquivo correspondente dentro do diretório
`man/`, com a extensão `.Rd`. No caso da nossa função de exemplo acima,
que está em um arquivo chamado `soma.R`, precisaremos então de um
arquivo `soma.Rd` dentro do `man/`.

Existem duas formas de documentar uma função com os arquivos `.Rd`: uma
é da maneira tradicional, escrevendo manualmente a documentação
utilizando a linguagem específica e colocando os campos necessários. Os
detalhes de como fazer isso manualmente estão em
[Writing R documentation files][]. Outra forma de escrever a
documentação de uma função é utilizando o pacote `roxygen2`, que utiliza
algumas tags simples e permite que você escreva a documentação dentro do
próprio arquivo `.R`. Dessa forma fica muito mais simples alterar ou
atualizar a documentação de uma função, pois tudo se concentra dentro de
um único arquivo.

Neste texto vamos utilizar o pacote `roxygen2` para gerar a documentação
das funções. O primeiro passo é escrever a documentação dentro do
arquivo `.R`. A documentação usando o `roxygen2` segue o seguinte
formato:

* Toda documentação começa com um comentário especial, do tipo `#'`
  (note o `'` depois do `#`).
* Os campos de documentação são criados a parir de tags que iniciam com
  `@`, colocados logo após um comentário especial `#'`.
* Toda a documentação deve ficar diretamente acima do início da função.

Usando como exemplo a função `soma()` criada acima dentro do arquivo
`soma.R`, podemos documentá-la com o `roxygen2` da seguinte forma:


```r
#' @title Faz a Soma de Dois Numeros
#' @name soma
#'
#' @description Uma (incrivel) funcao que pega dois numeros e faz a
#'     soma. Utilize este campo para descrever melhor o proposito de
#'     sua funcao e o que ela e capaz de fazer.
#'
#' @param x Um numero
#' @param y Outro numero
#'
#' @details Utilize este campo para escrever detalhes mais tecnicos da
#'     sua funcao (se necessario), ou para detalhar melhor como
#'     utilizar determinados argumentos.
#'
#' @return A soma dos numeros \code{x} e \code{y}.
#'
#' @author Fernando Mayer
#'
#' @seealso \code{\link[base]{sum}}, \code{\link[base]{+}}
#'
#' @examples
#' soma(2, 2)
#'
#' x <- 3
#' y <- 4
#' soma(x = x, y = y)
#'
#' @export
soma <- function(x, y){
    x + y
}
```

Para gerar a documentação agora basta utilizar a função `document()` do
pacote `devtools`:


```r
document()
```

```
## Updating meupacote documentation
## Loading meupacote
```

> Observação: o comando `document()` do pacote `devtools` é de fato um
> "wraper" para a função `roxygenise()` do pacote `roxygen2`.

O resultado da chamada dessa função é:

* Criar o diretório `man/` se ele ainda não existir, ou se for a
  primeira vez que estiver criando a doscumentação com a função
  `document()`.
* Gerar os arquivos `.Rd` dentro de `man/` (se ainda não existirem)
  correspondentes às funções no diretório `.R`.
* Se os arquivos `.Rd` já existirem, a chamada da função `document()`
  irá apenas atualizar apenas os arquivos que forem modificados.

No nosso exemplo, a chamada da função `document()` criou o diretório
`man/` e gerou o arquivo `soma.Rd` com o seguinte conteúdo





## `NAMESPACE`: Organização



[John M. Chambers]: http://statweb.stanford.edu/~jmc4/
[choosealicense.com]: http://choosealicense.com
[Writing R documentation files]: [http://cran.r-project.org/doc/manuals/r-release/R-exts.html#Writing-R-documentation-files]
