# Gerenciamento de pacotes no R

# Introdução




Atualmente existem milhares de pacotes (*packages*) extras disponíveis
para os mais variados fins, ajudando a completar ainda mais o R. Todos os
pacotes oficiais do são disponibilizados através do CRAN (*Comprehensive R
Archieve Network*), e muitos outros (“não-oficiais”) são
disponibilizados de outras formas (*e.g.* GitHub ou site do autor).

A seguir segue uma descrição das três peças fundamentais que compõem os
pacotes do R. É importante que o usuário saiba a diferença entre
*package* e *library*:

-   **Library (*biblioteca*)**: um diretório que contém sub-diretórios
    de pacotes instalados.

-   **Package (*pacotes*)**: uma coleção de *funções* do R com uma
    documentação associada. Os pacotes são carregados através da função
    `library()` ou `require()`.

-   **Repositories (*repositórios*)**: são endereços que indicam onde
    estão os pacotes disponíveis através do CRAN. O repositório
    principal é [http://cran.r-project.org](). No entanto, existem
    diversos espelhos (*“mirrors”*) em todo o mundo que também contém os
    mesmos arquivos. Uma lista de espelhos está disponível em
    [http://cran.r-project.org/mirrors]()

O R provê uma série de funções que auxiliam no gerenciamento de seus
pacotes. No entanto, cabe ao usuário saber como utilizar estas funções
para que o sistema esteja sempre organizado e atualizado. Este documento
contém algumas explicações que tem como objetivo ajudar os usuários a
instalar e gerenciar pacotes.

# Instalando pacotes

A maneira mais simples de instalar um pacote do CRAN no R é através da
função `install.packages()`. Por exemplo, se queremos instalar o pacote
`foo` poderíamos fazer simplesmente:


```r
install.packages("foo", dependencies = TRUE)
```

O argumento `dependencies = TRUE` serve para que o programa instale
automaticamente todos os outros pacotes dos quais `foo` depende. No
entanto, note que em uma instalação padrão do R, apenas o usuário root
terá privilégios para a instalação de pacotes, já que a biblioteca
padrão (onde são instalados os pacotes) fica em `R_HOME/library`, onde
`R_HOME` representa o diretório de instalação padrão do R (geralmente em
`/usr/local/lib64/R`, que somente o root tem permissão de escrita).

> NOTA: para conferir seu R_HOME use o comando

```r
R.home()
```

```
## [1] "/usr/local/lib64/R"
```

Para resolver esse problema o usuário comum tem duas opções: (**a**) iniciar
o R como root, ou (**b**) criar uma biblioteca particular em uma pasta onde
ele tem acesso e instalar os pacotes neste diretório. A primeira opção
aparentemente é mais simples, embora (como em todos os casos) nunca é
recomendado utilizar programas como root. Além disso, o usuário comum
nunca terá acesso como root (em condições adequadas). A segunda opção
pode ser mais trabalhosa na primeira vez que se cria uma biblioteca
particular. No entanto, além de não haver a necessidade de iniciar o
programa como root, existem outros benefícios com esta prática a longo
prazo. Dessa forma, será apresentado a seguir um mecanismo de
gerenciamento de pacotes baseado na segunda opção: uma maneira simples
de criar uma biblioteca particular para o usuário comum.

Os benefícios deste método vão além daquele mencionado anteriormente.
Suponha que o usuário optou por instalar pacotes através do login como
root. Dessa forma todos os pacotes instalados estão na biblioteca padrão
do R. A próxima vez que o programa for reinstalado (*e.g.* por motivos de
atualização) todos os pacotes serão perdidos, e o usuário será obrigado
a reinstalá-los novamente. Utilizando a opção (**b**), o R pode ser
reinstalado sem preocupações com isso, pois todos os pacotes instaldos
pelo usuário continuarão em sua biblioteca particular, o que é uma
grande vantagem quando muitos pacotes são utilizados.

## Criando uma biblioteca particular

Para criar sua biblioteca particular, o usuário deve escolher um diretório
no sistema onde ele tenha permissão de escrita. A maneira mais fácil é
utilizar sua própria pasta `$HOME` (*e.g.* `/home/fpmayer/` ou
`~/`). Portanto, criamos então um diretório com um nome qualquer para
esta tarefa. Neste exemplo, vamos utilizar o diretório `library`
dentro de um diretório chamado `R`, ou seja,
`~/R/library`. Note que estes diretórios devem ser
criados previamente.

Nesse momento, nosso desejo é de que o R instale os pacotes neste
diretório. No entanto, ele não sabe que esse diretório foi criado e
serve para esse fim. Devemos portanto indicar ao R que essa pasta servirá
como uma biblioteca. Para isso devemos ajustar a variável de ambiente
`R_LIBS`, que informa ao programa, durante sua inicialização, onde estão
os diretórios que servem como bibliotecas. A maneira mais fácil de fazer
isso é criando o arquivo `.Renviron` na pasta `$HOME` (nesse caso
`/home/fpmayer`). Note que esse será um arquivo oculto nesta pasta.
Esse arquivo é utilizado para ajustar *apenas* variáveis de ambiente do
R de uma forma global. Ou seja, não importa onde o R seja iniciado, ele
irá “ler” este arquivo na sua inicialização. Sendo assim, dentro deste
arquivo devemos escrever a seguinte linha:


```r
R_LIBS=~/R/library
```

Mais de uma biblioteca pode ser especificada utilizando-se
ponto-e-vírgula (se você quiser utilizar mais de uma biblioteca
particular), e outras variáveis de ambiente também podem ser
especificadas aqui (o que foge do contexto deste documento). Note que
mesmo especificando um novo diretório, a biblioteca padrão do
R (`R_HOME/library`) não será substituída, apenas ficará como segunda
opção, já que nela estão os pacotes básicos (`base` e `recommended`) que
compõem a instalação padrão do programa.

Durante o processo de inicialização do R, as bibliotecas especificadas em
`R_LIBS` (com a biblioteca principal sempre incluída) são identificadas
através da função `.libPaths()`. Depois de iniciar o programa você pode
conferir quais são as bibliotecas disponíveis (que o R identificou)
utilizando esta função sem argumentos. Se estiver tudo certo, o
resultado desta função deve ser


```r
.libPaths()
```

```
## [1] "/home/fpmayer/R/library"    "/usr/local/lib64/R/library"
```

Nesse momento, seu sistema estará pronto para receber pacotes do CRAN e
instalá-los em uma biblioteca particular.

## Selecionando um repositório

Antes de começarmos com a instalação de novos pacotes na biblioteca
particular, vamos selecionar um repositório do CRAN onde os pacotes serão
procurados. Na verdade esta etapa é dispensável, pois quando se utiliza
a função `install.packages()` para instalar um pacote, uma pequena
interface gráfica em Tcl/Tk se abre com todos os espelhos do
CRAN disponíveis. Basta selecionar um deles e a função se encarrega do
resto.

No entanto, como tudo no R pode ser facilitado, podemos escolher um
repositório que sempre iremos utilizar para instalar os pacotes e evitar
que a interface em Tcl/Tk se abra toda vez que isso for necessário. Aqui
também existem duas maneiras de se fazer isso. A primeira é especificar
o repositório na própria função `install.packages()` através do
argumento `repos`, por exemplo,


```r
install.packages("foo", dependencies = TRUE,
                 repos = "http://cran-r.c3sl.ufpr.br")
```

No entanto essa não é uma solução muito prática, pois teremos que fazer
isso toda vez que um pacote for instalado.

Outra maneira de fazer o mesmo procedimento é através da criação de um
arquivo que contém comandos que serão carregados sempre que o R for
iniciado. Este arquivo deve se chamar `.Rprofile` e funciona da mesma
forma que o `.Renviron` utilizado anteriormente para ajustar variáveis
de ambiente. No entanto, este novo arquivo deve conter apenas códigos do
R que devem ser carregados na inicialização (*e.g.* o usuário pode
desejar sempre carregar o mesmo pacote). É importante fazer esta
distinção: `.Renviron` é utilizado apenas para variáveis ambientais,
enquanto que `.Rprofile` pode conter apenas comandos do R.

Através deste arquivo, portanto, podemos especificar um repositório que
sempre será utilizado quando a função `install.packages()` (ou qualquer
outra que se utilize dos repositórios) for utilizada. Sendo assim, crie
o arquivo `.Rprofile` em sua pasta `$HOME` (*e.g.* `~/.Rprofile`) e
entre com o seguinte comando dentro desse arquivo:


```r
options(repos = "http://cran-r.c3sl.ufpr.br")
```

Note que o endereço do repositório não precisa necessariamente ser o
mesmo mostrado aqui. O usuário pode utilizar qualquer endereço de
repositórios do CRAN que podem ser consultados em
<http://cran.r-project.org/mirrors.html>.

Dessa forma, toda vez que o R for inicializado, esta opção será
automaticamente ajustada. Da próxima vez que o usuário for instalar um
pacote não haverá mais a interface em Tcl/Tk, pois os pacotes serão
procurados diretamente neste repositório especificado. Uma forma de
conferir se este processo deu certo é fazendo


```r
getOption("repos")
```

```
## [1] "http://cran-r.c3sl.ufpr.br"
```

e conferir se o repositório é o mesmo daquele do arquivo `.Rprofile`.

Note que, da mesma forma que o arquivo `.Renviron`, todo o conteúdo do
`.Rprofile` presente na pasta `$HOME` é usado para definir opções
globais para o R. Não importa em qual diretório o programa for iniciado,
estas opções sempre serão reconhecidas.

O arquivo `.Rprofile` é muito útil também para outros fins. Qualquer
opção do R que o usuário queira que seja configurada sempre que o
progarama for inicializado pode ser ajustada da forma demonstrada aqui.
Para saber as opções disponíveis veja `?options`. Outra utilidade é que
pacotes que sempre são utilizados pelo usuário podem ser carregados na
inicialização com a especificação de `library(foo)` dentro deste
arquivo. No entanto, se um determinado pacote é utilizado apenas em um
projeto, um outro arquivo `.Rprofile` pode ser criado apenas dentro do
diretório deste projeto especificando os pacotes utilizados
“localmente”.

## Instalando pacotes na biblioteca particular

Existem duas maneiras de instalar pacotes no R. A primeira é utilizando a
função `install.packages()` de dentro do programa, como mencionado no
início desta seção. Outra forma é utilizando o comando `R CMD INSTALL`
no próprio *shell* (linha de comando). Esta segunda opção funciona
apenas quando o usuário já possui o arquivo fonte do pacote e quer
apenas instalá-lo.

### Utilizando a função `install.packages()`

Através desta função, inicialmente é feito o *download* do pacote
especificado e depois ele é instalado automaticamente. Vamos usar como
exemplo a instalação do pacote `mvtnorm`, utilizado para calcular
medidas das distribuições normal e t multivariadas. Para instalar o
pacote, podemos fazer


```r
install.packages("mvtnorm", dependencies = TRUE, 
                 lib = "~/R/library")
```

Note que o argumento `lib` é utilizado para especificar a biblioteca
onde o pacote será instalado. No entanto, como este diretório é o
primeiro na lista de bibliotecas (conforme o `.libPaths()`), ele se
torna o padrão e não precisa ser especificado. Portanto, apenas


```r
install.packages("mvtnorm", dependencies = TRUE)
```

```
## Installing package into '/home/fpmayer/R/library'
## (as 'lib' is unspecified)
```

irá baixar o pacote `mvtnorm` do repositório já especificado anteriormente e
instalá-lo na biblioteca `~/R/library`.

Para instalar mais de um pacote ao mesmo tempo na mesma biblioteca, a
função `c()` pode ser utilizada para especificar uma sequência de
pacotes. Por exemplo, para instalar os pacotes `nnet` e `tweedie`
podemos fazer


```r
install.packages(c("nnet", "tweedie"), dependencies = TRUE)
```

```
## Installing packages into '/home/fpmayer/R/library'
## (as 'lib' is unspecified)
```

Note que os pacotes `stabledist` e `statmod` também foram instalados,
conforme a mensagem acima. Isso ocorreu porque estes dois pacotes são
dependências do `tweedie`, e como usamos o argumento `dependencies =
TRUE`, eles foram selecionados e instalados automaticamente.

### Utilizando o comando `R CMD INSTALL`

Quando o usuário já possui o arquivo fonte (com a extensão `.tar.gz`) do
pacote a ser instalado não é necessário utilizar a função
`install.packages()`. Nesse caso o comando externo `R CMD INSTALL` pode
ser utilizado apenas para instalar pacotes. Portanto, para instalar o
pacote `foo.tar.gz` podemos utilizar diretamente em um terminal


```sh
R CMD INSTALL -l ~/R/library foo.tar.gz
```

É importante que esse comando seja executado no diretório onde se
encontra o arquivo `foo.tar.gz`. A opção `-l` seguida do caminho para a
biblioteca (`~/R/library`) serve para especificar onde o
pacote deve ser instalado. Ao contrário da função `install.packages()`,
aqui é necessário especificar sua biblioteca particular, pois o arquivo
`.Renviron` (onde especificamos a variável `R_LIBS`) não é lido pelo
`R CMD`.

Com este comando também podemos instalar mais de um pacote ao mesmo
tempo. Se todos os arquivos-fonte (`.tar.gz`) dos pacotes `foo`, `bar` e
`baz` estão no mesmo diretório, podemos instalá-los especificando seus
nomes separados por um espaço,


```sh
R CMD INSTALL -l ~/R/library foo.tar.gz bar.tar.gz baz.tar.gz
```

Instalar pacotes do CRAN através do `R CMD INSTALL` não é muito comum,
pois a função `install.packages()` faz todo o processo
automaticamente. O `R CMD INSTALL` é mais utilizado para pacotes
disponibilizados por outros meios, que não o repositório do CRAN.

# Gerenciando pacotes instalados

Após a instalação de diversos pacotes diferentes, em algum momento o
usuário sentirá a necessidade de gerenciá-los. Esse gerenciamento
significa observar quais pacotes estão instalados e em quais
bibliotecas. Eventualmente também é necessário atualizar os pacotes para
versões mais novas.

No R, esse gerenciamento de pacotes pode ser feito por uma única função:
`packageStatus()`. De acordo com `?packageStatus()`, esta função

> "Resume informações sobre pacotes instalados e pacotes disponíveis
> em vários repositórios..."

A seguir segue uma saída da chamada desta função.


```r
packageStatus()
```

```
## Number of installed packages:
##                             
##                              ok upgrade unavailable
##   /home/fpmayer/R/library     5       0           0
##   /usr/local/lib64/R/library 29       0           0
## 
## Number of available packages (each package counted only once):
##                                         
##                                          installed not installed
##   http://cran-r.c3sl.ufpr.br/src/contrib        19          6887
```

A primeira parte do resultado desta função
(`Number of installed packages`) mostra as bibliotecas disponíveis e o
número de pacotes em cada uma. O número de pacotes é separado entre
aqueles que estão atualizados (`ok`), os que podem ser atualizados para
versões mais novas (`upgrade`), e os indisponíveis (`unavailable`). A
segunda parte do resultado (`Number of available packages`) mostra o
número de pacotes disponíveis (instalados e não instalados) no
repositório padrão (definido anteriormente na seção
[Selecionando um repositório](#selecionando-um-repositório)).

Note que no resultado acima, temos 5 pacotes instalados em
`~/R/library`, que são os 3 selecionados anteriormente: `mvtnorm`,
`nnet`, e `tweedie`, e mais as duas dependências do `tweedie`, que foram
instalados automaticamente: `stabledist` e `statmod`. O importante é
saber que as dependências, mesmo sendo selecionadas automaticamente,
também são instaladas na sua biblioteca pessoal.

Como demonstrado acima, este comando pode ser muito útil quando o usuário
deseja saber quantos pacotes estão na sua biblioteca. No entanto, muitas
vezes é necessário saber também quais são estes pacotes. Para isso está
disponível também um método da função `summary()` para a função
`packageStatus()`. Portanto,


```r
summary(packageStatus())
```

```
## 
## Installed packages:
## -------------------
## 
## *** Library /home/fpmayer/R/library
## $ok
## [1] "mvtnorm"    "nnet"       "stabledist" "statmod"    "tweedie"   
## 
## $upgrade
## NULL
## 
## $unavailable
## NULL
## 
## 
## *** Library /usr/local/lib64/R/library
## $ok
##  [1] "base"       "boot"       "class"      "cluster"    "codetools" 
##  [6] "compiler"   "datasets"   "foreign"    "graphics"   "grDevices" 
## [11] "grid"       "KernSmooth" "lattice"    "MASS"       "Matrix"    
## [16] "methods"    "mgcv"       "nlme"       "nnet"       "parallel"  
## [21] "rpart"      "spatial"    "splines"    "stats"      "stats4"    
## [26] "survival"   "tcltk"      "tools"      "utils"     
## 
## $upgrade
## NULL
## 
## $unavailable
## NULL
## 
## 
## 
## Available packages:
## -------------------
## (each package appears only once)
## 
## *** Repository http://cran-r.c3sl.ufpr.br/src/contrib
## $installed
##  [1] "boot"       "class"      "cluster"    "codetools"  "foreign"   
##  [6] "KernSmooth" "lattice"    "MASS"       "Matrix"     "mgcv"      
## [11] "mvtnorm"    "nlme"       "nnet"       "rpart"      "spatial"   
## [16] "stabledist" "statmod"    "survival"   "tweedie"   
## 
## $`not installed`
##    [1] "A3"                          "abbyyR"                     
##    [3] "abc"                         "abc.data"                   
##    [5] "ABCanalysis"                 "abcdeFBA"                   
##    [7] "ABCoptim"                    "abctools"                   
##    [9] "abd"                         "abf2"                       
##   [11] "abind"                       "abn"                        
## 
## 
## [[CONTINUA...]]
```

apresenta um resulatdo mais completo (note que aqui o resultado foi
editado para mostrar a parte inicial da saída, uma vez que todos os mais
de 6000 pacotes do R são listados). A primeira parte deste resultado
(`Installed packages`) apresenta agora não só o número, mas também quais
são os pacotes instalados nas bibliotecas disponíveis. Além disso, elas
também estão separadas entre aquelas atualizadas (`ok`), as que podem
ser atualizadas (`upgrade`), e as indisponíveis (`unavailable`). A
segunda parte do resultado (`Available packages`) agora apresenta quais
são todos os pacotes instalados pelo repositório padrão, além de todos
os outros disponíveis (não instalados).

## Atualizando pacotes

Como visto nos resultados do comando `packageStatus()` acima, pode-se
notar quando existem pacotes instalados, tanto na biblioteca particular
quanto na biblioteca padrão do R, que podem ser atualizados para versões
mais recentes. Manter os pacotes atualizados é sempre recomendado pelos
desenvolvedores do R pois *bugs* estão sempre sendo corrigidos e os
pacotes estão sendo aprimorados.

No caso dos pacotes instalados na biblioteca padrão do R (que fazem parte
da instalação padrão do programa), inevitavelmente se torna necessário
que o usuário tenha acesso como root para realizar as atualizações. Já
na atualização de pacotes instalados na biblioteca particular isso
novamente não é necessário. Por isso a importância do comando
`packageStatus()`. Através dele o usuário sabe se precisa ou não iniciar
o R como root para fazer atualizações.

Seja qual for a biblioteca onde os pacotes que serão atualizados estão
instalados, o comando para essa tarefa é o mesmo, o que muda é apenas a
forma como o programa é iniciado (como root ou não). O comando
`update.packages()` compara as versões dos pacotes instalados com
aqueles disponíveis no repositório do CRAN e apresenta ao usuário, como
visto a seguir


```r
update.packages()
```

Se existirem pacotes a serem atualizados, cada um será apresentado com
uma pergunta sobre a atualização. O usuário deve responder para cada
pacote apresentado se ele deve ser atualizado (`y`) ou não (`N`), além
de poder cancelar a operação a qualquer momento (`c`). Ao final, os
pacotes marcados com `y` serão baixados dos repositórios e instalados
automaticamente.

Opcionalmente, se quiser atualizar todos os pacotes sem precisar
responder a todas as questões, use


```r
update.packages(ask = FALSE)
```

Ao final de um processo onde todos os pacotes são atualizados, a saída
do comando `packageStatus()` deve ser com 0 pacotes para `upgrade`


```r
packageStatus()
```

```
## Number of installed packages:
##                             
##                              ok upgrade unavailable
##   /home/fpmayer/R/library     5       0           0
##   /usr/local/lib64/R/library 29       0           0
## 
## Number of available packages (each package counted only once):
##                                         
##                                          installed not installed
##   http://cran-r.c3sl.ufpr.br/src/contrib        19          6887
```

# Removendo pacotes

A remoção de pacotes pode ser feita de forma semelhante àquela utilizada
para instalar pacotes. Da mesma forma que os comandos
`install.packages()` e `R CMD INSTALL` servem para instalar pacotes, os
comandos `remove.packages()` e `R CMD REMOVE` servem para removê-los.

Por exemplo, para remover o pacote `nnet`, de dentro de uma sessão do
podemos fazer


```r
remove.packages("nnet")
```

Alternativamente, o argumento `lib` pode ser utilizado para especificar
a biblioteca onde o pacote está instalado (ver a sessão
[Utilizando a função `install.packages()`](#utilizando-a-função-installpackages)). Neste
caso, como não estamos especificando, assumimos que o pacote está na
biblioteca padrão (a primeira do comando `.libPaths()`), ou seja,
`~/R/library`. Note que se o pacote em questão estiver em uma biblioteca
que não seja essa (*e.g.* `R_HOME/library`) será necessário o acesso
como root. Para remover mais de um pacote utilize a função `c()`, da
mesma forma que em `install.packages()`.

Pacotes também podem ser removidos com o comando `R CMD REMOVE` de um
*shell* do Linux. Para remover o pacote `nnet` da biblioteca particular
criada anteriormente, faça


```sh
R CMD REMOVE -l ~/R/library foo
```

Note que neste caso é necessário especificar o argumento `-l` com o
caminho para a biblioteca. Se esta não for sua biblioteca particular,
será necessário executar esse comando como root. Para desinstalar mais
de um pacote especifique o nome dos mesmos separados por um espaço.

# Bibliografia recomendada

A principal fonte de informação para esse assunto é o capítulo 6 do
manual **R Installation and Administration**, disponível em
[http://cran.r-project.org/doc/manuals/R-admin.pdf]().

No entanto, existem alguns artigos publicados no periódico **R news**
que tratam este assunto de forma um pouco mais abrangente (nos quais
este documento foi baseado):

* Ligges, U. 2003. R Help Desk: Package Management. **R
  news**. Vol. 3/3. Disponível em:
  [http://cran.r-project.org/doc/Rnews/Rnews_2003-3.pdf]().
* Ripley, B. D. 2005. Packages and their Management in R 2.1.0. **R
  news**. Vol. 5/1. Disponível em:
  [http://cran.r-project.org/doc/Rnews/Rnews_2005-1.pdf]().

