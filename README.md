# Trilha Verde - Projeto final de SSC0620 - Engenharia de Software (2025)

## Integrantes:

Agnes Bressan (Interface, Planejamento de Projeto e Gerenciamento de Atividades)<br>
Carolina Elias (Interface, Planejamento de Projeto e Gerenciamento de Atividades)<br>
Christian Bernard (Interface, Planejamento de Projeto e Gerenciamento de Atividades)<br>
Rhayna Casado (BD, Planejamento de Projeto e Gerenciamento de Atividades)<br>
Leticia Crepaldi (QR Code, Planejamento de Projeto e Gerenciamento de Atividades)<br>
Rauany Secci (QR Code, BD, Planejamento de Projeto e Gerenciamento de Atividades)


## Sobre o projeto:

O projeto consiste em um aplicativo, disponível para plataformas móveis (Android) e web, voltado ao público infantil, sobre a Trilha de Árvores Úteis da ESALQ. O aplicativo permite que os usuários caminhem pela trilha e interajam com os QR Codes presentes nas árvores para responder perguntas sobre elas. Cada pergunta respondida aumenta a pontuação do usuário na trilha e gera uma conquista, que pode ser visualizada na aba de pontuação. Conforme o usuário caminha pela trilha e responde às perguntas, ele pode visualizar seu trajeto e as árvores que observou na tela principal.

## Algumas possibilidades para continuidade do projeto: 

Implementação de sistema de GPS em vez de um mapa interativo.<br>
Expansão para outras trilhas.<br>
Adição de novos conteúdos (mais perguntas, curiosidades, desafios) sobre as árvores.<br>
Melhorias na gamificação, como novos tipos de desafios ou recompensas.<br>
Aprimoramento da acessibilidade para usuários com necessidades especiais.<br>
Criar a função de administrador, com a possibilidade de alterar perguntas e adicionar e remover árvores da trilha pelo aplicativo.<br>
Expansão para dispositivos IOS.<br>

## Como rodar o projeto

Clone o repositorio:
``` bash
$ git clone https://github.com/AgnesBressan/Trilha-Verde.git
```
Com o [Flutter SDK](https://flutter.dev/docs/get-started/install) configurado, baixe as dependencias do projeto: 

``` bash
$ cd Trilha-Verde
$ flutter pub get
```

Conecte seu dispositivo android e identifique seu ID atraves do comando `flutter devices` e rode o aplicativo com `flutter run`:
``` bash 
$ flutter devices 
$ flutter run -d <id_dispositivo> 
``` 

Para rodar num emulador Android:
```bash
$ flutter emulators --launch Medium_Phone # exemplo 
$ flutter run
```
Para que o aplicativo seja executado em dispositivos móveis, é necessária a instalação de seu apk, que deve ser disponibilizado nos servidores da ESALQ ou extraído a partir desse projeto com o comando:

``` bash
flutter build apk --release
```
Isso assume que os ambientes de desenvolvimento Flutter SDK e Android SDK estão corretamente instalados e configurados.

Para compialar a versão web, que será hospedada em um servidor, use:

```
flutter build web
```

Isso gera uma  pasta com os arquivos necessários no repositório:

```
build/web/
```
