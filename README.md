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
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

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

Pré-requisitos para utilização: 
* Certificar que ha comunicação entre SOURCE DATABASE e TARGET DATABASE, para os protocolos SSH e SQLNET, comumente alojado nas portas 22 e 1521, respectivamente.
** assssssssss

+  Pré-requisitos para utilização:
   - Certificar que ha comunicação entre SOURCE DATABASE e TARGET DATABASE, para os protocolos SSH e SQLNET, comumente alojado nas portas 22 e 1521, respectivamente.
     - Possibilidade de cenario 1) SOURCE DATABASE e TARGET DATABASE habitam em diferentes infraestruturas de computação.
	 diqwdjiowdjqiowdjqwodjqwdjioqw
     - Possibilidade de cenario 2) SOURCE DATABASE e TARGET DATABASE habitam em diferentes infraestruturas de computação.
	 dwqodjqwiodjqwodjqwdjioqwdjioqwdjioqw

Em cenários onde SOURCE DATABASE e TARGET DATABASE, estejam em máquinas/infraestruturas diferentes, certificar que há liberação entre as portas do serviço SSH e SQLNET 22 (SSH) e 1521 (SQLNET).




* Parametrização dos apontamentos entre SOURCE e TARGET (utilizar o instalador atk_install.sh)



This is an example of how to list things you need to use the software and how to install them.
* npm
  ```sh
  npm install npm@latest -g
  ```

### Installation

1. Get a free API Key at [https://example.com](https://example.com)
2. Clone the repo
   ```sh
   git clone https://github.com/your_username_/Project-Name.git
   ```
3. Install NPM packages
   ```sh
   npm install
   ```
4. Enter your API in `config.js`
   ```JS
   const API_KEY = 'ENTER YOUR API';
   ```



<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_



<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a list of proposed features (and known issues).



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.



<!-- CONTACT -->
## Contact

Your Name - [@your_twitter](https://twitter.com/your_username) - email@example.com

Project Link: [https://github.com/your_username/repo_name](https://github.com/your_username/repo_name)



<!-- ACKNOWLEDGEMENTS -->
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
[product-screenshot]: images/screenshot.png
