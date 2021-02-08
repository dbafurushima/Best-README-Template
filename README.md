<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="images/logo_novo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">ATK - Oracle Database</h3>

  <p align="center">
    Oracle Database : Automation Toolkit
    <br />
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Tópicos relevantes</summary>
  <ol>
    <li>
      <a href="#about-the-project">Sobre o projeto</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
<!-- 
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
 -->
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

![Product Name Screen Shot][product-screenshot]

O ATK (Automation Toolkit) foi desenvolvido com propósito de facilitar as tarefas que envolve REFRESH DATABASE, comumente utilizado para atualização de bases de dados não produtivas. Das quais são utilizadas para esteiras de desenvolvimentos das aplicações que utilizam o Oracle Database como seu SGBD.

Detalhes relevantes sobre a solução :
* Script desenvolvido em BASH SH
* Mecanismo utilizado para operação de refresh : DUPLICATE ACTIVE DATABASE
* Para execução desta automação, recomenda-se o uso de uma ferramenta CI/CD, a ferramenta utilizada neste documento trata-se do Jenkins.

Termos e terminologias utilizadas:
* SOURCE DATABASE: Banco de dados de ORIGEM
* TARGET DATABASE: Banco de dados de DESTINO


### Ferramentas Base Para Uso

* [Oracle Database](https://www.oracle.com/br/database/)
* [Jenkins](https://www.jenkins.io/)
* [Shell Script](https://www.gnu.org/software/bash/)



<!-- GETTING STARTED -->
## Getting Started

O assunto REFRESH DATABASE a depender do cenário a qual está contido, pode várias sua complexidade, do qual envolve alguns fatores, tais como : 
* Tamanho do Banco de Dados
* Calibre/capacidade do ambiente computacional que hospeda o sistema de banco de dados.
* RTO (Recovery Time Objective) de execução do processo fim a fim.

É importante que o utilizador, entenda o mecanismo desta solução e apure se há a necessidade de ajustes, haja visto a infinidade de cenários que ronda esse tema.



### Prerequisites


+  Pré-requisitos para utilização:

   Certificar que há comunicação entre SOURCE DATABASE e TARGET DATABASE, para os protocolos SSH e SQLNET, comumente alojado nas portas 22 e 1521, respectivamente.

   - Possibilidade de cenário 1) SOURCE DATABASE e TARGET DATABASE habitam em diferentes infraestruturas de computação.
		> * Para esta conjuntura, é obrigatório que os serviços de SSH e SQLNET (comumente alojado nas portas 22 e 1521, respectivamente) de SOURCE DATABASE e TARGET DATABASE, tenham liberação no firewall (caso houver bloqueio).

    ![Product Name Screen Shot][SOURCE_TARGET_DIFF]




		
   - Possibilidade de cenário 2) SOURCE DATABASE e TARGET DATABASE habitam na mesma infraestrutura computacional.
		> * Para esta conjuntura, certificar que há espaço suficiente no FILESYSTEM ou ASM para a duplicação do banco de dados em questão. 
           <br />
		> * (Opcional) Sugere-se que o DISKGROUP (DG) ou Filesystem sejam segregados para database produtivo e database não produtivo.
		
    ![Product Name Screen Shot][SOURCE_TARGET_EQ] 
		
		




		

	

### Installation

A instalação do ATK - Oracle Database - REFRESH DATABASE passa por um processo semiautomatizado, é necessário o analista parametrizar os valores referente ao ambiente da qual está trabalhando. 
<br />
Portanto informações tais como ASM DISKGROUP, FRA (Fast Recovery Area), Redo Size e outros pontos relevantes do arquivo de configuração do DUPLICATE ACTIVE DATABASE, é obrigatório fazer sua primeira alimentação, temática da qual será dissecado neste tópico de instalação.
<br />
É importante ressaltar que qualquer mudança de estrutura na infraestrutura (mesmo que essa pratica não seja comum no dia a dia), é necessário o ajuste deste arquivo, exemplo, mudança de host do ambiente Oracle RAC.
<br />


* Parametrização dos apontamentos entre SOURCE e TARGET (utilizar o instalador atk_install.sh)

1. Utilizando-se do usuario UNIX oracle, defina o local (path filesystem) a qual os script "ATK - Oracle Database" irão residir.

   ```sh
   mkdir -p /backup/tivit/atk
   cd /backup/tivit/atk
   ```
* Chamaremos esse local de ATK_HOME

   
2. Clone o repositorio
   ```sh
   git clone https://github.com/XXXXXXXX/XXXXXX.git
   ```
   
3. Execute o script atk_install.sh 
   ```sh
   /backup/tivit/atk/atk_install.sh
   ```
> Veja um exemplo de execução do script atk_install.sh

* Parte 1) Informações sobre o ambiente SOURCE DATABASE.
    ![Product Name Screen Shot][atk_install_sh_parte_1] 

* Parte 2) Informações sobre o ambiente TARGET DATABASE.
    ![Product Name Screen Shot][atk_install_sh_parte_2] 

* Parte 3) Informações sobre usuario e senha SYSDBA.
    ![Product Name Screen Shot][atk_install_sh_parte_3] 

* Parte 4) Parametrização - ENV + TNS
    ![Product Name Screen Shot][atk_install_sh_parte_4] 

* Parte 5) Parametrização - Duplicate file
    ![Product Name Screen Shot][atk_install_sh_parte_5] 
   
<br />
<br />

> * Exemplo de um duplicate file (duplicate.rman)

   ```sh
run {
allocate channel SOURCE_chn_01 type disk;
allocate channel SOURCE_chn_02 type disk;
allocate channel SOURCE_chn_03 type disk;
allocate channel SOURCE_chn_04 type disk;
allocate channel SOURCE_chn_05 type disk;
allocate channel SOURCE_chn_06 type disk;
allocate channel SOURCE_chn_07 type disk;
allocate channel SOURCE_chn_08 type disk;
allocate channel SOURCE_chn_09 type disk;
allocate channel SOURCE_chn_10 type disk;
allocate channel TARGET_chn_01 type disk;
allocate channel TARGET_chn_02 type disk;
allocate channel TARGET_chn_03 type disk;
allocate channel TARGET_chn_04 type disk;
allocate channel TARGET_chn_05 type disk;
allocate channel TARGET_chn_06 type disk;
allocate channel TARGET_chn_07 type disk;
allocate channel TARGET_chn_08 type disk;
allocate channel TARGET_chn_09 type disk;
allocate channel TARGET_chn_10 type disk;
SET NEWNAME FOR DATABASE TO NEW ;
duplicate target database to issdes from active  database
SPFILE
  PARAMETER_VALUE_CONVERT 'ISSP','issdes','ISSPSTB','issdes'
  SET CONTROL_FILES='+DATAC1'
  SET DB_CREATE_FILE_DEST='+DATAC1'
  SET DB_RECOVERY_FILE_DEST_SIZE='500G'
  SET AUDIT_FILE_DEST='/u01/app/oracle/admin/issdes/adump'
  SET SGA_TARGET='25G'
  SET SGA_MAX_SIZE='25G'
  SET SHARED_POOL_SIZE='7G'
  SET DB_CACHE_SIZE='10G'
  SET CLUSTER_DATABASE='FALSE'
  SET DG_BROKER_CONFIG_FILE1=' '
  SET DG_BROKER_CONFIG_FILE2=' '
  SET UNDO_TABLESPACE='UNDOTBS1'
  SET DG_BROKER_START='FALSE'
  SET remote_listener=''
  SET service_names='ISSDES' 
  SET db_recovery_file_dest=''
  SET log_archive_dest_1='location=+DBFS_DG'
logfile
      GROUP 1  ('+RECOC1') SIZE 5G
     ,GROUP 2  ('+RECOC1') SIZE 5G
     ,GROUP 3  ('+RECOC1') SIZE 5G
     ,GROUP 4  ('+RECOC1') SIZE 5G
     ,GROUP 5  ('+RECOC1') SIZE 5G
     ,GROUP 6  ('+RECOC1') SIZE 5G
     ,GROUP 7  ('+RECOC1') SIZE 5G
     ,GROUP 8  ('+RECOC1') SIZE 5G
     ,GROUP 9  ('+RECOC1') SIZE 5G
     ,GROUP 10 ('+RECOC1') SIZE 5G;
}
   ```


<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_









<!-- ROADMAP -->
<!-- 
## Roadmap

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a list of proposed features (and known issues).
 -->


<!-- CONTRIBUTING -->
<!-- 
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
 -->


<!-- LICENSE -->
<!-- 
## License

Distributed under the MIT License. See `LICENSE` for more information.
 -->


<!-- CONTACT -->
<!-- 
## Contact

Your Name - [@your_twitter](https://twitter.com/your_username) - email@example.com

Project Link: [https://github.com/your_username/repo_name](https://github.com/your_username/repo_name)
 -->


<!-- ACKNOWLEDGEMENTS -->
<!-- 
## Acknowledgements
* [GitHub Emoji Cheat Sheet](https://www.webpagefx.com/tools/emoji-cheat-sheet)
* [Img Shields](https://shields.io)
* [Choose an Open Source License](https://choosealicense.com)
* [GitHub Pages](https://pages.github.com)
* [Animate.css](https://daneden.github.io/animate.css)
* [Loaders.css](https://connoratherton.com/loaders)
* [Slick Carousel](https://kenwheeler.github.io/slick)
* [Smooth Scroll](https://github.com/cferdinandi/smooth-scroll)
* [Sticky Kit](http://leafo.net/sticky-kit)
* [JVectorMap](http://jvectormap.com)
* [Font Awesome](https://fontawesome.com)
  -->




<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/othneildrew/Best-README-Template/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/othneildrew/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/othneildrew/Best-README-Template/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/othneildrew
[product-screenshot]: images/macro_refresh_database.png
[SOURCE_TARGET_DIFF]: images/SOURCE_TARGET_DIFERENTE_INFRA.png
[SOURCE_TARGET_EQ]: images/SOURCE_TARGET_MESMA_INFRA.png


[atk_install_sh_parte_1]: images/atk_install_sh_parte_1_source.png
[atk_install_sh_parte_2]: images/atk_install_sh_parte_2_target.png
[atk_install_sh_parte_3]: images/atk_install_sh_parte_3_password.png
[atk_install_sh_parte_4]: images/atk_install_sh_parte_4_parametrizacao.png
[atk_install_sh_parte_5]: images/atk_install_sh_parte_5_parametrizacao2.png

