ethanon-space-shooter
=====================

Código base para o curso de introdução ao Ethanon Engine

Como rodar os exemplos
----------------------

### Windows

1. Abra o Ethanon Editor
2. Clique em **File** -> **New project...**
3. Escolha o arquivo *.ethproj* do projeto que você deseja rodar e substitua-o. Isso irá copiar todos os arquivos binários necessários no Windows, como *.exe*, sem alterar o código-fonte.
4. Abra o arquivo main.angelscript com SciTE ou Sublime Text
5. Tecle **F5** para rodar o exemplo ou execute *machine.exe* diretamente

### Mac OS X

1. Abra o terminal
2. Execute o comando:
   
   open -a machine.app --args dir=/Users/usuario/caminho-do-projeto/
   
   Não se esqueça da barra / antes de *Users*

ou

1. Certifique-se de que machine.app está na sua pasta */Applications*
2. Certifique-se de que você tem o plug-in do Sublime Text instalado
3. Abra *main.angescript* com o Sublime e tecle **Cmd + Shift + B** para rodar