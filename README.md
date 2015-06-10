# R-pacotes-rautu

Criação de pacotes para o R: uma rápida introdução

## Motivação

Como já dizia [John M. Chambers][] quando criou a linguagem S
(predecessora do R), o objetivo da linguagen é

> "... to turn ideas into software, quickly and faithfully."

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
então saber como transformar suas funções em um pacote. Isso pode ser
feito de duas formas:

* Tradicional: usando os comandos padrões do R para criação de pacotes,
como `R CMD build` e `R CMD check`.
* Moderna: usando o pacote `devtools` para criar e conferir o pacote
