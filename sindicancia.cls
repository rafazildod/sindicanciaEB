% ============================================================
% sindicancia.cls
% Classe para elaboração de documentos de Sindicância no EB
% Baseado em: EB10-IG-09.001 (2ª Ed, 2024)
% Autor original: Rafael dos Santos Dantas
% Refatoração assistida: versão 1.12
% ============================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sindicancia}[2026/06/05 v2.4 Sindicancias EB - build validado]

% ============================================================
% 1. OPÇÕES DA CLASSE
% ============================================================
\newif\ifsind@sumario
\newif\ifsind@ordinario
\sind@ordinariotrue

\DeclareOption{sumario}{\sind@sumariotrue\sind@ordinariofalse}
\DeclareOption{ordinario}{\sind@ordinariotrue\sind@sumariofalse}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

% API pública para opções da classe.
\newcommand{\getTipoSindicancia}{%
  \ifsind@sumario sumária\else ordinária\fi
}

% ============================================================
% 2. CLASSE BASE
% ============================================================
\LoadClass[12pt,a4paper]{article}
\makeatletter

% ============================================================
% 3. PACOTES ESSENCIAIS
% ============================================================
\RequirePackage{iftex}

\ifPDFTeX
  \ClassError{sindicancia}
    {Compile este documento com LuaLaTeX ou XeLaTeX}
    {Esta classe usa fontspec e nao e compativel com pdfLaTeX.}
\fi

\RequirePackage{fontspec}
\RequirePackage[brazilian]{babel}
\RequirePackage[
  a4paper,
  margin=2.5cm
]{geometry}
\RequirePackage{microtype}
\RequirePackage{graphicx}
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{setspace}
\RequirePackage{ragged2e}
\RequirePackage{tabularx}
\RequirePackage{array}
\RequirePackage{pdfpages}
\@ifundefined{NewDocumentCommand}{\RequirePackage{xparse}}{}
\RequirePackage{etoolbox}

% Carregar hyperref por último reduz conflitos com layout e âncoras.
\RequirePackage[hidelinks]{hyperref}

% ============================================================
% 4. CONFIGURAÇÕES GLOBAIS DE FORMATAÇÃO
% ============================================================
% Compilar preferencialmente com LuaLaTeX ou XeLaTeX.
% No Windows, Times New Roman deve ser encontrada. Se não for,
% usa TeX Gyre Termes como substituta métrica aproximada.
\IfFontExistsTF{Times New Roman}{%
  \setmainfont{Times New Roman}%
}{%
  \setmainfont{Liberation Serif}%
}


\setstretch{1.15}
\justifying
\setlength{\parindent}{1.25cm}
\setlength{\parskip}{0pt}
\pagestyle{empty}

% Títulos simples, sem alteração de tamanho.
\titleformat{\section}
  {\normalfont\normalsize\bfseries}
  {\thesection.}
  {0.6em}
  {}

\titleformat{\subsection}
  {\normalfont\normalsize\bfseries}
  {\thesubsection.}
  {0.6em}
  {}

% ============================================================
% 5. LISTAS
% ============================================================
\setlist[enumerate]{
  label=\arabic*.,
  leftmargin=0.5cm,
  itemindent=0cm,
  labelsep=0.3cm,
  itemsep=0pt,
  topsep=0pt,
  parsep=0pt
}

\setlist[itemize]{
  leftmargin=0.5cm,
  itemsep=0pt,
  topsep=0pt,
  parsep=0pt
}

% ============================================================
% 6. CAIXA "Fl. ____" GLOBAL
% ============================================================
\newif\ifsind@mostrarflbox
\sind@mostrarflboxtrue

% Usada para evitar caixa duplicada em páginas importadas por pdfpages.
% Nessas páginas, a caixa é aplicada diretamente pelo picturecommand do \incluirDocumento.
\newif\ifsind@paginaimportada
\sind@paginaimportadafalse

\newcommand{\MostrarCaixaFolha}{\sind@mostrarflboxtrue}
\newcommand{\OcultarCaixaFolha}{\sind@mostrarflboxfalse}

% Caixa com dimensão externa controlada: 2 cm x 1.5 cm, sem TikZ.
\newcommand{\flbox}{%
  \begingroup
  \setlength{\unitlength}{1cm}%
  \begin{picture}(2,1.5)
    \linethickness{0.4pt}%
    \put(0,0){%
      \framebox(2,1.5)[l]{%
        \hspace{2pt}\footnotesize Fl.\,\rule{1cm}{0.4pt}%
      }%
    }%
  \end{picture}%
  \endgroup
}

% Desenho da caixa em páginas normais geradas pelo LaTeX.
\newcommand{\sind@desenharflbox}{%
  \ifsind@mostrarflbox
    \put(\strip@pt\dimexpr\paperwidth-4.5cm\relax,\strip@pt\dimexpr\paperheight-2.5cm\relax){\flbox}%
  \fi
}

% Desenho da caixa em páginas importadas por pdfpages.
% pdfpages coloca o PDF importado sobre o pagecommand, então aqui usamos picturecommand.
\newcommand{\sind@desenharflboxpdfpages}{%
  \ifsind@mostrarflbox
    \put(\strip@pt\dimexpr\paperwidth-4.5cm\relax,\strip@pt\dimexpr\paperheight-2.5cm\relax){\flbox}%
  \fi
}

% Caixa posicionada dentro da margem superior, alinhada pela margem direita.
% Ajuste fino: xshift controla distância da borda direita; yshift controla distância do topo.
\newcommand{\sind@shipoutflbox}{%
  \ifsind@paginaimportada
    % Página importada: a caixa será aplicada por \incluirDocumento via picturecommand.
  \else
    \sind@desenharflbox
  \fi
}
\AddToHook{shipout/foreground}{\sind@shipoutflbox}

% ============================================================
% 7. CABEÇALHO INSTITUCIONAL
% ============================================================
\gdef\@arquivoBrasao{figs/Coat.pdf}
\newcommand{\arquivoBrasao}[1]{\gdef\@arquivoBrasao{#1}}

\newcommand{\cabecalhoInstitucional}{%
  \begin{center}
    \includegraphics[height=2cm]{\@arquivoBrasao}\\[0.2cm]
    \textbf{MINISTÉRIO DA DEFESA}\\
    \textbf{EXÉRCITO BRASILEIRO}\\
    \textbf{CMNE -- 7ª RM / 7ª DE -- 10ª BDA INF MTZ}\\
    \textbf{72º BATALHÃO DE INFANTARIA DE CAATINGA}\\
    \textbf{(35º Batalhão de Infantaria / 1968)}\\
    \textbf{``BATALHÃO GENERAL VICTORINO CARNEIRO MONTEIRO''}
  \end{center}%
}

% Compatibilidade com modelos antigos.
\newcommand{\anexocabecalho}{\cabecalhoInstitucional\vspace{3em}}

% ============================================================
% 8. SISTEMA DE MÚLTIPLAS DATAS
% ============================================================
\newcommand{\newDateSlot}[1]{%
  \expandafter\gdef\csname #1@dia\endcsname{}%
  \expandafter\gdef\csname #1@mes\endcsname{}%
  \expandafter\gdef\csname #1@ano\endcsname{}%
  \expandafter\gdef\csname #1@cidade\endcsname{}%
}

\newDateSlot{dataii}
\newDateSlot{dataiii}
\newDateSlot{dataPortaria}
\newDateSlot{dataFato}
\newDateSlot{dataNotificacao}
\newDateSlot{dataInquiricaoSlot}
\newDateSlot{dataRemessa}

\newcommand{\criarData}[1]{\newDateSlot{#1}}
\newcommand{\setDataDia}[2]{\expandafter\gdef\csname #1@dia\endcsname{#2}}
\newcommand{\setDataMes}[2]{\expandafter\gdef\csname #1@mes\endcsname{#2}}
\newcommand{\setDataAno}[2]{\expandafter\gdef\csname #1@ano\endcsname{#2}}
\newcommand{\setDataCidade}[2]{\expandafter\gdef\csname #1@cidade\endcsname{#2}}

\newcommand{\getDataDia}[1]{\csname #1@dia\endcsname}
\newcommand{\getDataMes}[1]{\csname #1@mes\endcsname}
\newcommand{\getDataAno}[1]{\csname #1@ano\endcsname}
\newcommand{\getDataCidade}[1]{\csname #1@cidade\endcsname}

\newcommand{\dataExtensoX}[1]{%
  \getDataDia{#1}\ de \getDataMes{#1}\ de \getDataAno{#1}%
}

% \sind@ifempty é definido adiante; aqui só fica registrado para uso após o carregamento da classe.
\newcommand{\localDataX}[1]{%
  \ifcsempty{#1@cidade}%
    {\dataExtensoX{#1}}%
    {\getDataCidade{#1}, \dataExtensoX{#1}}%
}

% ============================================================
% 9. VARIÁVEIS GERAIS DA SINDICÂNCIA
% ============================================================
\newcommand{\dia}[1]{\gdef\@dia{#1}}
\newcommand{\mes}[1]{\gdef\@mes{#1}}
\newcommand{\ano}[1]{\gdef\@ano{#1}}
\newcommand{\cidade}[1]{\gdef\@cidade{#1}}
\newcommand{\om}[1]{\gdef\@om{#1}}
\newcommand{\omSuperior}[1]{\gdef\@omSuperior{#1}}
\newcommand{\portaria}[1]{\gdef\@portaria{#1}}
\newcommand{\nup}[1]{\gdef\@nup{#1}}
\newcommand{\objeto}[1]{\gdef\@objeto{#1}}
\newcommand{\prazo}[1]{\gdef\@prazo{#1}}

\gdef\@dia{}
\gdef\@mes{}
\gdef\@ano{}
\gdef\@cidade{}
\gdef\@om{}
\gdef\@omSuperior{}
\gdef\@portaria{}
\gdef\@nup{}
\gdef\@objeto{}
\gdef\@prazo{}

% ============================================================
% 10. DADOS DOS ENVOLVIDOS E PARTES
% ============================================================
% Autoridade instauradora / nomeante
\newcommand{\autoridadeNome}[1]{\gdef\@autoridadeNome{#1}}
\newcommand{\autoridadePosto}[1]{\gdef\@autoridadePosto{#1}}
\newcommand{\autoridadeFuncao}[1]{\gdef\@autoridadeFuncao{#1}}
\gdef\@autoridadeNome{}\gdef\@autoridadePosto{}\gdef\@autoridadeFuncao{}

% Sindicante
\newcommand{\sindicanteNome}[1]{\gdef\@sindicanteNome{#1}}
\newcommand{\sindicantePosto}[1]{\gdef\@sindicantePosto{#1}}
\newcommand{\sindicanteOM}[1]{\gdef\@sindicanteOM{#1}}
\gdef\@sindicanteNome{}\gdef\@sindicantePosto{}\gdef\@sindicanteOM{}

% Sindicado
\newcommand{\sindicadoNome}[1]{\gdef\@sindicadoNome{#1}}
\newcommand{\sindicadoPosto}[1]{\gdef\@sindicadoPosto{#1}}
\newcommand{\sindicadoSU}[1]{\gdef\@sindicadoSU{#1}}
\newcommand{\sindicadoOM}[1]{\gdef\@sindicadoOM{#1}}
\newcommand{\sindicadoIdentidade}[1]{\gdef\@sindicadoIdentidade{#1}}
\newcommand{\sindicadoNascimento}[1]{\gdef\@sindicadoNascimento{#1}}
\newcommand{\sindicadoNaturalidade}[1]{\gdef\@sindicadoNaturalidade{#1}}
\newcommand{\sindicadoEstadoCivil}[1]{\gdef\@sindicadoEstadoCivil{#1}}
\newcommand{\sindicadoFiliacao}[1]{\gdef\@sindicadoFiliacao{#1}}
\newcommand{\sindicadoResidencia}[1]{\gdef\@sindicadoResidencia{#1}}
\newcommand{\sindicadoCelular}[1]{\gdef\@sindicadoCelular{#1}}
\newcommand{\sindicadoCPF}[1]{\gdef\@sindicadoCPF{#1}}
\gdef\@sindicadoNome{}\gdef\@sindicadoPosto{}\gdef\@sindicadoSU{}\gdef\@sindicadoOM{}
\gdef\@sindicadoIdentidade{}\gdef\@sindicadoNascimento{}\gdef\@sindicadoNaturalidade{}
\gdef\@sindicadoEstadoCivil{}\gdef\@sindicadoFiliacao{}\gdef\@sindicadoResidencia{}
\gdef\@sindicadoCelular{}\gdef\@sindicadoCPF{}

% Denunciante / ofendido
\newcommand{\denuncianteNome}[1]{\gdef\@denuncianteNome{#1}}
\newcommand{\denunciantePosto}[1]{\gdef\@denunciantePosto{#1}}
\newcommand{\denuncianteOM}[1]{\gdef\@denuncianteOM{#1}}
\gdef\@denuncianteNome{}\gdef\@denunciantePosto{}\gdef\@denuncianteOM{}

% Testemunha principal
\newcommand{\testemunhaNome}[1]{\gdef\@testemunhaNome{#1}}
\newcommand{\testemunhaPosto}[1]{\gdef\@testemunhaPosto{#1}}
\newcommand{\testemunhaOM}[1]{\gdef\@testemunhaOM{#1}}
\newcommand{\testemunhaProfissao}[1]{\gdef\@testemunhaProfissao{#1}}
\newcommand{\testemunhaIdentidade}[1]{\gdef\@testemunhaIdentidade{#1}}
\newcommand{\testemunhaNascimento}[1]{\gdef\@testemunhaNascimento{#1}}
\newcommand{\testemunhaNaturalidade}[1]{\gdef\@testemunhaNaturalidade{#1}}
\newcommand{\testemunhaEstadoCivil}[1]{\gdef\@testemunhaEstadoCivil{#1}}
\newcommand{\testemunhaResidencia}[1]{\gdef\@testemunhaResidencia{#1}}
\newcommand{\testemunhaFiliacao}[1]{\gdef\@testemunhaFiliacao{#1}}
\newcommand{\testemunhaCelular}[1]{\gdef\@testemunhaCelular{#1}}
\newcommand{\testemunhaCPF}[1]{\gdef\@testemunhaCPF{#1}}
\gdef\@testemunhaNome{}\gdef\@testemunhaPosto{}\gdef\@testemunhaOM{}
\gdef\@testemunhaProfissao{}\gdef\@testemunhaIdentidade{}\gdef\@testemunhaNascimento{}
\gdef\@testemunhaNaturalidade{}\gdef\@testemunhaEstadoCivil{}\gdef\@testemunhaResidencia{}
\gdef\@testemunhaFiliacao{}\gdef\@testemunhaCelular{}\gdef\@testemunhaCPF{}

% Testemunhas A e B, para acareação
\newcommand{\testemunhaANome}[1]{\gdef\@testemunhaANome{#1}}
\newcommand{\testemunhaAPosto}[1]{\gdef\@testemunhaAPosto{#1}}
\newcommand{\testemunhaBNome}[1]{\gdef\@testemunhaBNome{#1}}
\newcommand{\testemunhaBPosto}[1]{\gdef\@testemunhaBPosto{#1}}
\gdef\@testemunhaANome{}\gdef\@testemunhaAPosto{}
\gdef\@testemunhaBNome{}\gdef\@testemunhaBPosto{}

% Testemunhas da inquirição
\newcommand{\testemunhaInquiricaoNome}[1]{\gdef\@testemunhaInquiricaoNome{#1}}
\newcommand{\testemunhaInquiricaoPosto}[1]{\gdef\@testemunhaInquiricaoPosto{#1}}
\newcommand{\testemunhaInquiricaoBNome}[1]{\gdef\@testemunhaInquiricaoBNome{#1}}
\newcommand{\testemunhaInquiricaoBPosto}[1]{\gdef\@testemunhaInquiricaoBPosto{#1}}
\gdef\@testemunhaInquiricaoNome{}\gdef\@testemunhaInquiricaoPosto{}
\gdef\@testemunhaInquiricaoBNome{}\gdef\@testemunhaInquiricaoBPosto{}

% Advogados
\newcommand{\advogadoNome}[1]{\gdef\@advogadoNome{#1}}
\newcommand{\advogadoOAB}[1]{\gdef\@advogadoOAB{#1}}
\newcommand{\advogadoDenuncianteNome}[1]{\gdef\@advogadoDenuncianteNome{#1}}
\newcommand{\advogadoDenuncianteOAB}[1]{\gdef\@advogadoDenuncianteOAB{#1}}
\gdef\@advogadoNome{}\gdef\@advogadoOAB{}
\gdef\@advogadoDenuncianteNome{}\gdef\@advogadoDenuncianteOAB{}

% Peritos
\newcommand{\peritoNome}[1]{\gdef\@peritoNome{#1}}
\newcommand{\peritoPosto}[1]{\gdef\@peritoPosto{#1}}
\newcommand{\peritoFuncao}[1]{\gdef\@peritoFuncao{#1}}
\newcommand{\peritoEspecialidade}[1]{\gdef\@peritoEspecialidade{#1}}
\newcommand{\peritoBNome}[1]{\gdef\@peritoBNome{#1}}
\newcommand{\peritoBPosto}[1]{\gdef\@peritoBPosto{#1}}
\gdef\@peritoNome{}\gdef\@peritoPosto{}\gdef\@peritoFuncao{}\gdef\@peritoEspecialidade{}
\gdef\@peritoBNome{}\gdef\@peritoBPosto{}

% Escrivão, substituto, interessado e comandante imediato
\newcommand{\escrivaoNome}[1]{\gdef\@escrivaoNome{#1}}
\newcommand{\escrivaoPosto}[1]{\gdef\@escrivaoPosto{#1}}
\newcommand{\substitutoNome}[1]{\gdef\@substitutoNome{#1}}
\newcommand{\substitutoPosto}[1]{\gdef\@substitutoPosto{#1}}
\newcommand{\interessadoNome}[1]{\gdef\@interessadoNome{#1}}
\newcommand{\interessadoPosto}[1]{\gdef\@interessadoPosto{#1}}
\newcommand{\comandanteNome}[1]{\gdef\@comandanteNome{#1}}
\newcommand{\comandantePosto}[1]{\gdef\@comandantePosto{#1}}
\newcommand{\comandanteOM}[1]{\gdef\@comandanteOM{#1}}
\gdef\@escrivaoNome{}\gdef\@escrivaoPosto{}
\gdef\@substitutoNome{}\gdef\@substitutoPosto{}
\gdef\@interessadoNome{}\gdef\@interessadoPosto{}
\gdef\@comandanteNome{}\gdef\@comandantePosto{}\gdef\@comandanteOM{}

% Dados complementares específicos
\newcommand{\localInquiricao}[1]{\gdef\@localInquiricao{#1}}
\newcommand{\dataInquiricao}[1]{\gdef\@dataInquiricao{#1}}
\newcommand{\horaInquiricao}[1]{\gdef\@horaInquiricao{#1}}
\gdef\@localInquiricao{}\gdef\@dataInquiricao{}\gdef\@horaInquiricao{}

% ============================================================
% 11. GETTERS PÚBLICOS
% ============================================================
\newcommand{\getDia}{\@dia}
\newcommand{\getMes}{\@mes}
\newcommand{\getAno}{\@ano}
\newcommand{\getCidade}{\@cidade}
\newcommand{\getOm}{\@om}
\newcommand{\getOmSuperior}{\@omSuperior}
\newcommand{\getPortaria}{\@portaria}
\newcommand{\getNup}{\@nup}
\newcommand{\getObjeto}{\@objeto}
\newcommand{\getPrazo}{\@prazo}

\newcommand{\getAutoridadeNome}{\@autoridadeNome}
\newcommand{\getAutoridadePosto}{\@autoridadePosto}
\newcommand{\getAutoridadeFuncao}{\@autoridadeFuncao}

\newcommand{\getSindicanteNome}{\@sindicanteNome}
\newcommand{\getSindicantePosto}{\@sindicantePosto}
\newcommand{\getSindicanteOM}{\@sindicanteOM}

\newcommand{\getSindicadoNome}{\@sindicadoNome}
\newcommand{\getSindicadoPosto}{\@sindicadoPosto}
\newcommand{\getSindicadoSU}{\@sindicadoSU}
\newcommand{\getSindicadoOM}{\@sindicadoOM}
\newcommand{\getSindicadoIdentidade}{\@sindicadoIdentidade}
\newcommand{\getSindicadoNascimento}{\@sindicadoNascimento}
\newcommand{\getSindicadoNaturalidade}{\@sindicadoNaturalidade}
\newcommand{\getSindicadoEstadoCivil}{\@sindicadoEstadoCivil}
\newcommand{\getSindicadoFiliacao}{\@sindicadoFiliacao}
\newcommand{\getSindicadoResidencia}{\@sindicadoResidencia}
\newcommand{\getSindicadoCelular}{\@sindicadoCelular}
\newcommand{\getSindicadoCPF}{\@sindicadoCPF}

\newcommand{\getDenuncianteNome}{\@denuncianteNome}
\newcommand{\getDenunciantePosto}{\@denunciantePosto}
\newcommand{\getDenuncianteOM}{\@denuncianteOM}

\newcommand{\getTestemunhaNome}{\@testemunhaNome}
\newcommand{\getTestemunhaPosto}{\@testemunhaPosto}
\newcommand{\getTestemunhaOM}{\@testemunhaOM}
\newcommand{\getTestemunhaProfissao}{\@testemunhaProfissao}
\newcommand{\getTestemunhaIdentidade}{\@testemunhaIdentidade}
\newcommand{\getTestemunhaNascimento}{\@testemunhaNascimento}
\newcommand{\getTestemunhaNaturalidade}{\@testemunhaNaturalidade}
\newcommand{\getTestemunhaEstadoCivil}{\@testemunhaEstadoCivil}
\newcommand{\getTestemunhaResidencia}{\@testemunhaResidencia}
\newcommand{\getTestemunhaFiliacao}{\@testemunhaFiliacao}
\newcommand{\getTestemunhaCelular}{\@testemunhaCelular}
\newcommand{\getTestemunhaCPF}{\@testemunhaCPF}

\newcommand{\getTestemunhaANome}{\@testemunhaANome}
\newcommand{\getTestemunhaAPosto}{\@testemunhaAPosto}
\newcommand{\getTestemunhaBNome}{\@testemunhaBNome}
\newcommand{\getTestemunhaBPosto}{\@testemunhaBPosto}

\newcommand{\getTestemunhaInquiricaoNome}{\@testemunhaInquiricaoNome}
\newcommand{\getTestemunhaInquiricaoPosto}{\@testemunhaInquiricaoPosto}
\newcommand{\getTestemunhaInquiricaoBNome}{\@testemunhaInquiricaoBNome}
\newcommand{\getTestemunhaInquiricaoBPosto}{\@testemunhaInquiricaoBPosto}

\newcommand{\getAdvogadoNome}{\@advogadoNome}
\newcommand{\getAdvogadoOAB}{\@advogadoOAB}
\newcommand{\getAdvogadoDenuncianteNome}{\@advogadoDenuncianteNome}
\newcommand{\getAdvogadoDenuncianteOAB}{\@advogadoDenuncianteOAB}

\newcommand{\getPeritoNome}{\@peritoNome}
\newcommand{\getPeritoPosto}{\@peritoPosto}
\newcommand{\getPeritoFuncao}{\@peritoFuncao}
\newcommand{\getPeritoEspecialidade}{\@peritoEspecialidade}
\newcommand{\getPeritoBNome}{\@peritoBNome}
\newcommand{\getPeritoBPosto}{\@peritoBPosto}

\newcommand{\getEscrivaoNome}{\@escrivaoNome}
\newcommand{\getEscrivaoPosto}{\@escrivaoPosto}
\newcommand{\getSubstitutoNome}{\@substitutoNome}
\newcommand{\getSubstitutoPosto}{\@substitutoPosto}
\newcommand{\getInteressadoNome}{\@interessadoNome}
\newcommand{\getInteressadoPosto}{\@interessadoPosto}
\newcommand{\getComandanteNome}{\@comandanteNome}
\newcommand{\getComandantePosto}{\@comandantePosto}
\newcommand{\getComandanteOM}{\@comandanteOM}
\newcommand{\getLocalInquiricao}{\@localInquiricao}
\newcommand{\getDataInquiricao}{\@dataInquiricao}
\newcommand{\getHoraInquiricao}{\@horaInquiricao}

% ============================================================
% 12. DATAS PRINCIPAIS
% ============================================================
\newcommand{\dataExtenso}{%
  \@dia\ de \@mes\ de \@ano%
}

\newcommand{\localData}{%
  \@cidade, \dataExtenso%
}

% ============================================================
% 13. VALIDAÇÃO E CONDICIONAIS
% ============================================================
% Teste interno de vazio com expansão controlada.
% Expande apenas o primeiro token, suficiente para \@campos antigos,
% sem forçar expansão completa de conteúdo frágil.
\newcommand{\sind@ifempty}[3]{%
  \expandafter\ifblank\expandafter{#1}{#2}{#3}%
}

% Gerador simples de setter/getter para novos campos da classe.
\newcommand{\sind@newfield}[3]{%
  \expandafter\gdef\csname @#1\endcsname{#3}%
  \expandafter\newcommand\csname #1\endcsname[1]{%
    \expandafter\gdef\csname @#1\endcsname{##1}%
  }%
  \expandafter\newcommand\csname get#2\endcsname{%
    \csname @#1\endcsname
  }%
}

\newcommand{\CampoObrigatorio}[2]{%
  \ifcsundef{@#1}{%
    \ClassError{sindicancia}{Campo obrigatorio inexistente: #1}{O campo #1 nao foi definido na classe.}%
  }{%
    \ifcsempty{@#1}{%
      \ClassError{sindicancia}{Campo obrigatorio ausente: #2}{Preencha o campo usando o comando adequado antes de gerar este documento.}%
    }{}%
  }%
}

\newcommand{\SeCampoPreenchido}[2]{%
  \ifcsundef{@#1}{}{%
    \ifcsempty{@#1}{}{#2}%
  }%
}

\newcommand{\SeCampoVazio}[2]{%
  \ifcsundef{@#1}{#2}{%
    \ifcsempty{@#1}{#2}{}%
  }%
}

% Compatibilidade com modelos antigos que usavam \exibirSe{\@campo}{...}
\newcommand{\exibirSe}[2]{%
  \sind@ifempty{#1}{}{#2}%
}

\newcommand{\ValidarCamposBasicos}{%
  \CampoObrigatorio{dia}{dia da data principal}%
  \CampoObrigatorio{mes}{mes da data principal}%
  \CampoObrigatorio{ano}{ano da data principal}%
  \CampoObrigatorio{cidade}{cidade}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
}

% ============================================================
% 14. ASSINATURAS
% ============================================================
\newcommand{\assinaturaPessoa}[3]{%
  \vspace{2.5cm}
  \begin{center}
    \textbf{#1} -- #2\\
    #3
  \end{center}%
}

\newcommand{\assinaturaSindicante}{%
  \assinaturaPessoa{\@sindicanteNome}{\@sindicantePosto}{Sindicante}%
}
\newcommand{\assinaturaSindicado}{%
  \assinaturaPessoa{\@sindicadoNome}{\@sindicadoPosto}{Sindicado}%
}
\newcommand{\assinaturaDenunciante}{%
  \assinaturaPessoa{\@denuncianteNome}{\@denunciantePosto}{Denunciante}%
}
\newcommand{\assinaturaTestemunha}{%
  \assinaturaPessoa{\@testemunhaNome}{\@testemunhaPosto}{Testemunha}%
}
\newcommand{\assinaturaTestemunhaA}{%
  \assinaturaPessoa{\@testemunhaANome}{\@testemunhaAPosto}{Testemunha A}%
}
\newcommand{\assinaturaTestemunhaB}{%
  \assinaturaPessoa{\@testemunhaBNome}{\@testemunhaBPosto}{Testemunha B}%
}
\newcommand{\assinaturaTestemunhaInquiricao}{%
  \assinaturaPessoa{\@testemunhaInquiricaoNome}{\@testemunhaInquiricaoPosto}{Testemunha da Inquirição}%
}
\newcommand{\assinaturaTestemunhaInquiricaoB}{%
  \assinaturaPessoa{\@testemunhaInquiricaoBNome}{\@testemunhaInquiricaoBPosto}{Testemunha da Inquirição}%
}
\newcommand{\assinaturaAdvogado}{%
  \vspace{2.5cm}
  \begin{center}
    \textbf{\@advogadoNome}\\
    \@advogadoOAB
  \end{center}%
}
\newcommand{\assinaturaAdvogadoDenunciante}{%
  \vspace{2.5cm}
  \begin{center}
    \textbf{\@advogadoDenuncianteNome}\\
    \@advogadoDenuncianteOAB
  \end{center}%
}
\newcommand{\assinaturaPerito}{%
  \assinaturaPessoa{\@peritoNome}{\@peritoPosto}{\@peritoFuncao}%
}
\newcommand{\assinaturaEscrivao}{%
  \assinaturaPessoa{\@escrivaoNome}{\@escrivaoPosto}{Escrivão}%
}
\newcommand{\assinaturaSubstituto}{%
  \assinaturaPessoa{\@substitutoNome}{\@substitutoPosto}{Sindicante Substituto}%
}
\newcommand{\assinaturaAutoridade}{%
  \assinaturaPessoa{\@autoridadeNome}{\@autoridadePosto}{\@autoridadeFuncao}%
}

% ============================================================
% 15. DOCUMENTOS E COMUNICAÇÕES
% ============================================================
% A numeração aqui não tenta adivinhar zeros à esquerda. Se quiser 05, informe 05.
\NewDocumentCommand{\diex}{m o}{%
  \noindent\textbf{DIEx nº} #1%
  \IfValueT{#2}{ -- #2}\\
  \textbf{EB:} \@nup
}

\NewDocumentCommand{\oficio}{m o}{%
  \noindent\textbf{OFÍCIO Nº} #1%
  \IfValueT{#2}{ -- #2}\\
  \textbf{NUP:} \@nup
}

\newcommand{\incluirDocumento}[2][]{%
  \begingroup
  \sind@paginaimportadatrue
  \includepdf[
    pages=-,
    pagecommand={\thispagestyle{empty}},
    picturecommand={\sind@desenharflboxpdfpages},
    #1
  ]{#2}%
  \endgroup
}

% Seleciona modelos por nome, procurando primeiro em modelos/ e depois em anexos/.
\newcommand{\GerarDocumento}[1]{%
  \InputIfFileExists{modelos/#1.tex}{}{%
    \InputIfFileExists{anexos/#1.tex}{}{%
      \ClassError{sindicancia}{Modelo '#1' nao encontrado}{Crie modelos/#1.tex ou anexos/#1.tex.}%
    }%
  }%
}

% ============================================================
% 16. COMANDOS AUXILIARES
% ============================================================
\newcommand{\rulefill}{\leavevmode\leaders\hrule height 0.4pt\hfill\kern\z@}

\newcommand{\ateste}{%
  \vspace*{\fill}%
  \noindent\fbox{%
    \begin{minipage}[t][3cm][t]{0.6\textwidth}
      \footnotesize
      \centering
      \textbf{ATESTE DE RECEBIMENTO}

      \vspace{0.4em}

      Recebi, em \rule{1.2cm}{0.4pt} de \rule{2.5cm}{0.4pt} de \rule{1.2cm}{0.4pt},
      o presente documento, do qual tomei ciência.

      \vspace{1.0em}

      Nome: \rulefill

      \vspace{0.5em}

      Ass: \rulefill
    \end{minipage}%
  }%
  \vspace*{\fill}%
}


% Macros para perguntas e respostas em termos de inquirição.
% Padrão atual: texto corrido, em aspecto de ata, sem parágrafos internos.
% Use \PergResp{teve conhecimento dos fatos}{sim, teve conhecimento} para gerar
% "Perguntado se teve conhecimento dos fatos, respondeu que sim...;".
\newcommand{\PergResp}[2]{%
  \textbf{Perguntado se} #1, \textbf{respondeu que} #2;\space
}

% Para perguntas abertas, como "como o fato aconteceu".
\newcommand{\PergRespAberta}[2]{%
  \textbf{Perguntado} #1, \textbf{respondeu que} #2;\space
}

% Versão com aspas, mantida para compatibilidade.
\newcommand{\PergRespAspas}[2]{%
  \textbf{Perguntado se} ``#1'', \textbf{respondeu que} ``#2'';\space
}

% Alias antigo, preservado.
\newcommand{\prgr}[2]{\PergRespAspas{#1}{#2}}

% Para compor relato corrido no padrão "Declarou que...".
\newcommand{\DeclarouQue}[1]{%
  \textbf{Declarou que} #1;\space
}

% Para inserir texto corrido livre dentro da ata.
\newcommand{\AtaTexto}[1]{#1\space}

% ============================================================
% 17. COMPATIBILIDADE COM ESTILOS ANTIGOS
% ============================================================
% Os modelos antigos podem conter \pagestyle{anexos} ou \pagestyle{nada}.
% Como agora não há paginação e a caixa é global, esses estilos ficam vazios.
\let\ps@anexos\ps@empty
\let\ps@nada\ps@empty

% ============================================================
% 18. DADOS ESPECÍFICOS DE JUNTADA
% ============================================================
\newcommand{\sind@limparJuntada}{%
  \gdef\@juntadaNumero{}%
  \gdef\@juntadaArquivo{}%
  \gdef\@juntadaItens{}%
}
\newcommand{\novaJuntada}{\sind@limparJuntada}

\newcommand{\juntadaNumero}[1]{%
  \gdef\@juntadaNumero{#1}%
  \gdef\@juntadaArquivo{documentos/docjuntada#1.pdf}%
}

\newcommand{\juntadaArquivo}[1]{%
  \gdef\@juntadaArquivo{#1}%
}

\newcommand{\juntadaItens}[1]{%
  \gdef\@juntadaItens{#1}%
}

\sind@limparJuntada

\newcommand{\getJuntadaNumero}{\@juntadaNumero}
\newcommand{\getJuntadaArquivo}{\@juntadaArquivo}
\newcommand{\getJuntadaItens}{\@juntadaItens}

\newcommand{\CampoObrigatorioRaw}[2]{%
  \ifcsundef{@#1}{%
    \ClassError{sindicancia}{Campo obrigatorio inexistente: #1}{O campo #1 nao foi definido na classe.}%
  }{%
    \expandafter\ifx\csname @#1\endcsname\@empty
      \ClassError{sindicancia}{Campo obrigatorio ausente: #2}{Preencha o campo antes de gerar este documento.}%
    \fi
  }%
}

\newcommand{\ValidarJuntada}{%
  \CampoObrigatorio{dia}{dia da juntada}%
  \CampoObrigatorio{mes}{mes da juntada}%
  \CampoObrigatorio{ano}{ano da juntada}%
  \CampoObrigatorio{cidade}{cidade da juntada}%
  \CampoObrigatorio{om}{organizacao militar}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorioRaw{juntadaNumero}{numero da juntada}%
  \CampoObrigatorioRaw{juntadaArquivo}{arquivo PDF da juntada}%
  \CampoObrigatorioRaw{juntadaItens}{lista de documentos da juntada}%
}

% ============================================================
% 19. DADOS ESPECÍFICOS DE DESPACHO
% ============================================================
% Cada despacho é produzido pelo sindicante, sem PDF anexado.
% Para vários despachos, use dados-despacho1.tex, dados-despacho2.tex etc.,
% sempre redefinindo os campos antes de chamar \GerarDocumento{despacho}.
\newcommand{\sind@limparDespacho}{%
  \gdef\@despachoNumero{}%
  \gdef\@despachoTexto{}%
  \gdef\@despachoLocalData{}%
}
\newcommand{\novoDespacho}{\sind@limparDespacho}

\newcommand{\despachoNumero}[1]{\gdef\@despachoNumero{#1}}
\newcommand{\despachoTexto}[1]{\gdef\@despachoTexto{#1}}
\newcommand{\despachoLocalData}[1]{\gdef\@despachoLocalData{#1}}

\sind@limparDespacho

\newcommand{\getDespachoNumero}{\@despachoNumero}
\newcommand{\getDespachoTexto}{\@despachoTexto}
\newcommand{\getDespachoLocalData}{\@despachoLocalData}

\newcommand{\ValidarDespacho}{%
  \CampoObrigatorio{dia}{dia do despacho}%
  \CampoObrigatorio{mes}{mes do despacho}%
  \CampoObrigatorio{ano}{ano do despacho}%
  \CampoObrigatorio{cidade}{cidade do despacho}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorioRaw{despachoNumero}{numero do despacho}%
  \CampoObrigatorioRaw{despachoTexto}{texto do despacho}%
}



% ============================================================
% 20. DADOS ESPECÍFICOS DE NOTIFICAÇÃO PRÉVIA
% ============================================================
% A notificação prévia é documento produzido pelo sindicante para dar ciência
% ao sindicado sobre a sindicância, sobre sua inquirição e, se for o caso,
% sobre oitivas de denunciante/ofendido e testemunhas.
\newcommand{\sind@limparNotificacaoPrevia}{%
  \gdef\@notificacaoNumero{}%
  \gdef\@notificacaoLocalData{}%
  \gdef\@notificacaoLocalVista{}%
  \gdef\@notificacaoAnexos{}%
  \gdef\@notificacaoTestemunhas{}%
  \gdef\@notificacaoTextoComplementar{}%
}
\newcommand{\novaNotificacaoPrevia}{\sind@limparNotificacaoPrevia}

\newcommand{\notificacaoNumero}[1]{\gdef\@notificacaoNumero{#1}}
\newcommand{\notificacaoLocalData}[1]{\gdef\@notificacaoLocalData{#1}}
\newcommand{\notificacaoLocalVista}[1]{\gdef\@notificacaoLocalVista{#1}}
\newcommand{\notificacaoAnexos}[1]{\gdef\@notificacaoAnexos{#1}}
\newcommand{\notificacaoTestemunhas}[1]{\gdef\@notificacaoTestemunhas{#1}}
\newcommand{\notificacaoTextoComplementar}[1]{\gdef\@notificacaoTextoComplementar{#1}}

\sind@limparNotificacaoPrevia

\newcommand{\getNotificacaoNumero}{\@notificacaoNumero}
\newcommand{\getNotificacaoLocalData}{\@notificacaoLocalData}
\newcommand{\getNotificacaoLocalVista}{\@notificacaoLocalVista}
\newcommand{\getNotificacaoAnexos}{\@notificacaoAnexos}
\newcommand{\getNotificacaoTestemunhas}{\@notificacaoTestemunhas}
\newcommand{\getNotificacaoTextoComplementar}{\@notificacaoTextoComplementar}

\newcommand{\ValidarNotificacaoPrevia}{%
  \CampoObrigatorio{dia}{dia da notificação}%
  \CampoObrigatorio{mes}{mes da notificação}%
  \CampoObrigatorio{ano}{ano da notificação}%
  \CampoObrigatorio{cidade}{cidade da notificação}%
  \CampoObrigatorio{om}{organização militar}%
  \CampoObrigatorio{nup}{NUP da sindicância}%
  \CampoObrigatorio{portaria}{portaria instauradora}%
  \CampoObrigatorio{objeto}{objeto da sindicância}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorio{sindicadoNome}{nome do sindicado}%
  \CampoObrigatorio{sindicadoPosto}{posto/graduação do sindicado}%
  \CampoObrigatorioRaw{notificacaoLocalVista}{local de vista dos autos}%
  \CampoObrigatorio{dataInquiricao}{data da inquirição do sindicado}%
  \CampoObrigatorio{horaInquiricao}{hora da inquirição do sindicado}%
  \CampoObrigatorioRaw{notificacaoNumero}{número da notificação/DIEx}%
  \CampoObrigatorioRaw{notificacaoAnexos}{anexos da notificação}%
}




% ============================================================
% 21. DADOS ESPECÍFICOS DE DIEx
% ============================================================
% Padrão de uso: dados/dados-diex1.tex, dados/dados-diex2.tex etc.
% Documento produzido pelo sindicante para comunicação interna, salvo
% orientação específica diversa da OM.
\newcommand{\sind@limparDiex}{%
  \gdef\@diexNumero{}%
  \gdef\@diexOrigem{Sindicante}%
  \gdef\@diexRemetente{}%
  \gdef\@diexDestinatario{}%
  \gdef\@diexAssunto{}%
  \gdef\@diexReferencia{}%
  \gdef\@diexAnexos{}%
  \gdef\@diexTexto{}%
  \gdef\@diexLocalData{}%
  \gdef\@diexFecho{Atenciosamente,}%
}
\newcommand{\novoDiex}{\sind@limparDiex}

\newcommand{\diexNumero}[1]{\gdef\@diexNumero{#1}}
\newcommand{\diexOrigem}[1]{\gdef\@diexOrigem{#1}}
\newcommand{\diexRemetente}[1]{\gdef\@diexRemetente{#1}}
\newcommand{\diexDestinatario}[1]{\gdef\@diexDestinatario{#1}}
\newcommand{\diexAssunto}[1]{\gdef\@diexAssunto{#1}}
\newcommand{\diexReferencia}[1]{\gdef\@diexReferencia{#1}}
\newcommand{\diexAnexos}[1]{\gdef\@diexAnexos{#1}}
\newcommand{\diexTexto}[1]{\gdef\@diexTexto{#1}}
\newcommand{\diexLocalData}[1]{\gdef\@diexLocalData{#1}}
\newcommand{\diexFecho}[1]{\gdef\@diexFecho{#1}}

\sind@limparDiex

\newcommand{\getDiexNumero}{\@diexNumero}
\newcommand{\getDiexOrigem}{\@diexOrigem}
\newcommand{\getDiexRemetente}{\@diexRemetente}
\newcommand{\getDiexDestinatario}{\@diexDestinatario}
\newcommand{\getDiexAssunto}{\@diexAssunto}
\newcommand{\getDiexReferencia}{\@diexReferencia}
\newcommand{\getDiexAnexos}{\@diexAnexos}
\newcommand{\getDiexTexto}{\@diexTexto}
\newcommand{\getDiexLocalData}{\@diexLocalData}
\newcommand{\getDiexFecho}{\@diexFecho}

\newcommand{\ValidarDiex}{%
  \CampoObrigatorio{dia}{dia do DIEx}%
  \CampoObrigatorio{mes}{mes do DIEx}%
  \CampoObrigatorio{ano}{ano do DIEx}%
  \CampoObrigatorio{cidade}{cidade do DIEx}%
  \CampoObrigatorio{nup}{NUP/EB do DIEx}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorioRaw{diexNumero}{número do DIEx}%
  \CampoObrigatorioRaw{diexRemetente}{remetente do DIEx}%
  \CampoObrigatorioRaw{diexDestinatario}{destinatário do DIEx}%
  \CampoObrigatorioRaw{diexAssunto}{assunto do DIEx}%
  \CampoObrigatorioRaw{diexTexto}{texto do DIEx}%
}

% ============================================================
% 22. DADOS ESPECÍFICOS DE OFÍCIO
% ============================================================
% Padrão de uso: dados/dados-oficio1.tex, dados/dados-oficio2.tex etc.
% Documento produzido pelo sindicante para comunicação externa, salvo
% orientação específica diversa da OM.
\newcommand{\sind@limparOficio}{%
  \gdef\@oficioNumero{}%
  \gdef\@oficioOrigem{Sindicante}%
  \gdef\@oficioRemetente{}%
  \gdef\@oficioDestinatario{}%
  \gdef\@oficioCargoDestinatario{}%
  \gdef\@oficioEnderecoDestinatario{}%
  \gdef\@oficioAssunto{}%
  \gdef\@oficioReferencia{}%
  \gdef\@oficioAnexos{}%
  \gdef\@oficioVocativo{Senhor,}%
  \gdef\@oficioTexto{}%
  \gdef\@oficioLocalData{}%
  \gdef\@oficioFecho{Atenciosamente,}%
}
\newcommand{\novoOficio}{\sind@limparOficio}

\newcommand{\oficioNumero}[1]{\gdef\@oficioNumero{#1}}
\newcommand{\oficioOrigem}[1]{\gdef\@oficioOrigem{#1}}
\newcommand{\oficioRemetente}[1]{\gdef\@oficioRemetente{#1}}
\newcommand{\oficioDestinatario}[1]{\gdef\@oficioDestinatario{#1}}
\newcommand{\oficioCargoDestinatario}[1]{\gdef\@oficioCargoDestinatario{#1}}
\newcommand{\oficioEnderecoDestinatario}[1]{\gdef\@oficioEnderecoDestinatario{#1}}
\newcommand{\oficioAssunto}[1]{\gdef\@oficioAssunto{#1}}
\newcommand{\oficioReferencia}[1]{\gdef\@oficioReferencia{#1}}
\newcommand{\oficioAnexos}[1]{\gdef\@oficioAnexos{#1}}
\newcommand{\oficioVocativo}[1]{\gdef\@oficioVocativo{#1}}
\newcommand{\oficioTexto}[1]{\gdef\@oficioTexto{#1}}
\newcommand{\oficioLocalData}[1]{\gdef\@oficioLocalData{#1}}
\newcommand{\oficioFecho}[1]{\gdef\@oficioFecho{#1}}

\sind@limparOficio

\newcommand{\getOficioNumero}{\@oficioNumero}
\newcommand{\getOficioOrigem}{\@oficioOrigem}
\newcommand{\getOficioRemetente}{\@oficioRemetente}
\newcommand{\getOficioDestinatario}{\@oficioDestinatario}
\newcommand{\getOficioCargoDestinatario}{\@oficioCargoDestinatario}
\newcommand{\getOficioEnderecoDestinatario}{\@oficioEnderecoDestinatario}
\newcommand{\getOficioAssunto}{\@oficioAssunto}
\newcommand{\getOficioReferencia}{\@oficioReferencia}
\newcommand{\getOficioAnexos}{\@oficioAnexos}
\newcommand{\getOficioVocativo}{\@oficioVocativo}
\newcommand{\getOficioTexto}{\@oficioTexto}
\newcommand{\getOficioLocalData}{\@oficioLocalData}
\newcommand{\getOficioFecho}{\@oficioFecho}

\newcommand{\ValidarOficio}{%
  \CampoObrigatorio{dia}{dia do Ofício}%
  \CampoObrigatorio{mes}{mes do Ofício}%
  \CampoObrigatorio{ano}{ano do Ofício}%
  \CampoObrigatorio{cidade}{cidade do Ofício}%
  \CampoObrigatorio{nup}{NUP/EB do Ofício}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorioRaw{oficioNumero}{número do Ofício}%
  \CampoObrigatorioRaw{oficioRemetente}{remetente do Ofício}%
  \CampoObrigatorioRaw{oficioDestinatario}{destinatário do Ofício}%
  \CampoObrigatorioRaw{oficioAssunto}{assunto do Ofício}%
  \CampoObrigatorioRaw{oficioTexto}{texto do Ofício}%
}



% ============================================================
% 23. DADOS ESPECÍFICOS DE TERMO DE INQUIRIÇÃO DE SINDICADO
% ============================================================
% Padrão de uso: dados/dados-inquiricao-sindicado1.tex,
% dados/dados-inquiricao-sindicado2.tex etc.
% O conteúdo das perguntas deve usar preferencialmente \PergResp{...}{...}
% e \PergRespAberta{...}{...}. O modelo produz texto corrido, em aspecto de ata.
\newcommand{\sind@limparInqSindicado}{%
  \gdef\@inqSindicadoNumero{}%
  \gdef\@inqSindicadoDataAta{}%
  \gdef\@inqSindicadoDocumentoBase{}%
  \gdef\@inqSindicadoFls{}%
  \gdef\@inqSindicadoPerguntaConhecimento{tem conhecimento sobre os fatos constantes da}%%
  \gdef\@inqSindicadoRespostaConhecimento{sim, tem conhecimento}%%
  \gdef\@inqSindicadoRelato{}%
  \gdef\@inqSindicadoPerguntas{}%
  \gdef\@inqSindicadoAlgoMais{não}%%
  \gdef\@inqSindicadoPrazoDefesa{três dias úteis}%%
}
\newcommand{\novaInquiricaoSindicado}{\sind@limparInqSindicado}

\newcommand{\inquiricaoSindicadoNumero}[1]{\gdef\@inqSindicadoNumero{#1}}
\newcommand{\inquiricaoSindicadoDataAta}[1]{\gdef\@inqSindicadoDataAta{#1}}
\newcommand{\inquiricaoSindicadoDocumentoBase}[1]{\gdef\@inqSindicadoDocumentoBase{#1}}
\newcommand{\inquiricaoSindicadoFls}[1]{\gdef\@inqSindicadoFls{#1}}
\newcommand{\inquiricaoSindicadoPerguntaConhecimento}[1]{\gdef\@inqSindicadoPerguntaConhecimento{#1}}
\newcommand{\inquiricaoSindicadoRespostaConhecimento}[1]{\gdef\@inqSindicadoRespostaConhecimento{#1}}
\newcommand{\inquiricaoSindicadoRelato}[1]{\gdef\@inqSindicadoRelato{#1}}
\newcommand{\inquiricaoSindicadoPerguntas}[1]{\gdef\@inqSindicadoPerguntas{#1}}
\newcommand{\inquiricaoSindicadoAlgoMais}[1]{\gdef\@inqSindicadoAlgoMais{#1}}
\newcommand{\inquiricaoSindicadoPrazoDefesa}[1]{\gdef\@inqSindicadoPrazoDefesa{#1}}

% Horários reais do ato de inquirição.
\newcommand{\horaInicioInquiricao}[1]{\gdef\@horaInicioInquiricao{#1}}
\newcommand{\horaFimInquiricao}[1]{\gdef\@horaFimInquiricao{#1}}
\gdef\@horaInicioInquiricao{}
\gdef\@horaFimInquiricao{}

\sind@limparInqSindicado

\newcommand{\getInqSindicadoNumero}{\@inqSindicadoNumero}
\newcommand{\getInqSindicadoDataAta}{\@inqSindicadoDataAta}
\newcommand{\getInqSindicadoDocumentoBase}{\@inqSindicadoDocumentoBase}
\newcommand{\getInqSindicadoFls}{\@inqSindicadoFls}
\newcommand{\getInqSindicadoPerguntaConhecimento}{\@inqSindicadoPerguntaConhecimento}
\newcommand{\getInqSindicadoRespostaConhecimento}{\@inqSindicadoRespostaConhecimento}
\newcommand{\getInqSindicadoRelato}{\@inqSindicadoRelato}
\newcommand{\getInqSindicadoPerguntas}{\@inqSindicadoPerguntas}
\newcommand{\getInqSindicadoAlgoMais}{\@inqSindicadoAlgoMais}
\newcommand{\getInqSindicadoPrazoDefesa}{\@inqSindicadoPrazoDefesa}
\newcommand{\getHoraInicioInquiricao}{\@horaInicioInquiricao}
\newcommand{\getHoraFimInquiricao}{\@horaFimInquiricao}

\newcommand{\ValidarInquiricaoSindicado}{%
  \CampoObrigatorio{cidade}{cidade da inquirição do sindicado}%
  \CampoObrigatorio{om}{organização militar}%
  \CampoObrigatorio{nup}{NUP da sindicância}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorio{sindicadoNome}{nome do sindicado}%
  \CampoObrigatorio{sindicadoPosto}{posto/graduação do sindicado}%
  \CampoObrigatorio{sindicadoNascimento}{data de nascimento do sindicado}%
  \CampoObrigatorio{sindicadoNaturalidade}{naturalidade do sindicado}%
  \CampoObrigatorio{sindicadoEstadoCivil}{estado civil do sindicado}%
  \CampoObrigatorio{sindicadoFiliacao}{filiação do sindicado}%
  \CampoObrigatorio{sindicadoResidencia}{residência do sindicado}%
  \CampoObrigatorio{sindicadoIdentidade}{identidade do sindicado}%
  \CampoObrigatorio{sindicadoCPF}{CPF do sindicado}%
  \CampoObrigatorio{localInquiricao}{local da inquirição}%
  \CampoObrigatorio{testemunhaInquiricaoNome}{nome da testemunha da inquirição}%
  \CampoObrigatorioRaw{inqSindicadoNumero}{número da inquirição do sindicado}%
  \CampoObrigatorioRaw{inqSindicadoDataAta}{data por extenso da ata de inquirição}%
  \CampoObrigatorioRaw{horaInicioInquiricao}{hora de início da inquirição}%
  \CampoObrigatorioRaw{horaFimInquiricao}{hora de término da inquirição}%
  \CampoObrigatorioRaw{inqSindicadoPerguntas}{perguntas e respostas da inquirição}%
}


% ============================================================
% 24. DADOS ESPECÍFICOS DE TERMO DE INQUIRIÇÃO DE TESTEMUNHA
% ============================================================
% Padrão de uso: dados/dados-inquiricao-testemunha1.tex,
% dados/dados-inquiricao-testemunha2.tex etc.
% O conteúdo das perguntas deve usar preferencialmente \PergResp{...}{...}
% e \PergRespAberta{...}{...}. O modelo produz texto corrido, em aspecto de ata.
\newcommand{\sind@limparInqTestemunha}{%
  \gdef\@inqTestemunhaNumero{}%
  \gdef\@inqTestemunhaDataAta{}%
  \gdef\@inqTestemunhaDocumentoBase{}%
  \gdef\@inqTestemunhaFls{}%
  \gdef\@inqTestemunhaCompromisso{prestou o compromisso de dizer a verdade sobre o que souber e lhe for perguntado}%%
  \gdef\@inqTestemunhaPerguntaConhecimento{tem conhecimento sobre os fatos constantes da}%%
  \gdef\@inqTestemunhaRespostaConhecimento{sim, tem conhecimento}%%
  \gdef\@inqTestemunhaRelato{}%
  \gdef\@inqTestemunhaPerguntas{}%
  \gdef\@inqTestemunhaAlgoMais{não}%%
}
\newcommand{\novaInquiricaoTestemunha}{\sind@limparInqTestemunha}

\newcommand{\inquiricaoTestemunhaNumero}[1]{\gdef\@inqTestemunhaNumero{#1}}
\newcommand{\inquiricaoTestemunhaDataAta}[1]{\gdef\@inqTestemunhaDataAta{#1}}
\newcommand{\inquiricaoTestemunhaDocumentoBase}[1]{\gdef\@inqTestemunhaDocumentoBase{#1}}
\newcommand{\inquiricaoTestemunhaFls}[1]{\gdef\@inqTestemunhaFls{#1}}
\newcommand{\inquiricaoTestemunhaCompromisso}[1]{\gdef\@inqTestemunhaCompromisso{#1}}
\newcommand{\inquiricaoTestemunhaPerguntaConhecimento}[1]{\gdef\@inqTestemunhaPerguntaConhecimento{#1}}
\newcommand{\inquiricaoTestemunhaRespostaConhecimento}[1]{\gdef\@inqTestemunhaRespostaConhecimento{#1}}
\newcommand{\inquiricaoTestemunhaRelato}[1]{\gdef\@inqTestemunhaRelato{#1}}
\newcommand{\inquiricaoTestemunhaPerguntas}[1]{\gdef\@inqTestemunhaPerguntas{#1}}
\newcommand{\inquiricaoTestemunhaAlgoMais}[1]{\gdef\@inqTestemunhaAlgoMais{#1}}

\sind@limparInqTestemunha

\newcommand{\getInqTestemunhaNumero}{\@inqTestemunhaNumero}
\newcommand{\getInqTestemunhaDataAta}{\@inqTestemunhaDataAta}
\newcommand{\getInqTestemunhaDocumentoBase}{\@inqTestemunhaDocumentoBase}
\newcommand{\getInqTestemunhaFls}{\@inqTestemunhaFls}
\newcommand{\getInqTestemunhaCompromisso}{\@inqTestemunhaCompromisso}
\newcommand{\getInqTestemunhaPerguntaConhecimento}{\@inqTestemunhaPerguntaConhecimento}
\newcommand{\getInqTestemunhaRespostaConhecimento}{\@inqTestemunhaRespostaConhecimento}
\newcommand{\getInqTestemunhaRelato}{\@inqTestemunhaRelato}
\newcommand{\getInqTestemunhaPerguntas}{\@inqTestemunhaPerguntas}
\newcommand{\getInqTestemunhaAlgoMais}{\@inqTestemunhaAlgoMais}

\newcommand{\ValidarInquiricaoTestemunha}{%
  \CampoObrigatorio{cidade}{cidade da inquirição da testemunha}%
  \CampoObrigatorio{om}{organização militar}%
  \CampoObrigatorio{nup}{NUP da sindicância}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorio{testemunhaNome}{nome da testemunha}%
  \CampoObrigatorio{testemunhaPosto}{posto/graduação ou qualificação da testemunha}%
  \CampoObrigatorio{localInquiricao}{local da inquirição}%
  \CampoObrigatorio{testemunhaInquiricaoNome}{nome da testemunha da inquirição}%
  \CampoObrigatorioRaw{inqTestemunhaNumero}{número da inquirição da testemunha}%
  \CampoObrigatorioRaw{inqTestemunhaDataAta}{data por extenso da ata de inquirição}%
  \CampoObrigatorioRaw{horaInicioInquiricao}{hora de início da inquirição}%
  \CampoObrigatorioRaw{horaFimInquiricao}{hora de término da inquirição}%
  \CampoObrigatorioRaw{inqTestemunhaPerguntas}{perguntas e respostas da inquirição}%
}




% ============================================================
% 25. DADOS ESPECÍFICOS DE CARTA PRECATÓRIA
% ============================================================
% Padrão de uso: dados/dados-carta-precatoria1.tex,
% dados/dados-carta-precatoria2.tex etc.
% A carta precatória deve ser inserida após o despacho que determinou sua expedição.
\newcommand{\sind@limparCartaPrecatoria}{%
  \gdef\@cartaPrecatoriaNumero{}%
  \gdef\@cartaPrecatoriaOrigem{}%
  \gdef\@cartaPrecatoriaRemetente{}%
  \gdef\@cartaPrecatoriaAutoridadeDeprecada{}%
  \gdef\@cartaPrecatoriaOMDeprecada{}%
  \gdef\@cartaPrecatoriaEndereco{}%
  \gdef\@cartaPrecatoriaAssunto{Inquirição por carta precatória}%
  \gdef\@cartaPrecatoriaReferencia{}%
  \gdef\@cartaPrecatoriaAnexos{}%
  \gdef\@cartaPrecatoriaVocativo{Senhor Comandante,}%
  \gdef\@cartaPrecatoriaFinalidade{}%
  \gdef\@cartaPrecatoriaPessoaOuvida{}%
  \gdef\@cartaPrecatoriaQualificacaoPessoa{}%
  \gdef\@cartaPrecatoriaPrazo{10 (dez) dias}%
  \gdef\@cartaPrecatoriaQuesitos{}%
  \gdef\@cartaPrecatoriaTextoComplementar{}%
  \gdef\@cartaPrecatoriaLocalData{}%
  \gdef\@cartaPrecatoriaFecho{Respeitosamente,}%
}
\newcommand{\novaCartaPrecatoria}{\sind@limparCartaPrecatoria}

\newcommand{\cartaPrecatoriaNumero}[1]{\gdef\@cartaPrecatoriaNumero{#1}}
\newcommand{\cartaPrecatoriaOrigem}[1]{\gdef\@cartaPrecatoriaOrigem{#1}}
\newcommand{\cartaPrecatoriaRemetente}[1]{\gdef\@cartaPrecatoriaRemetente{#1}}
\newcommand{\cartaPrecatoriaAutoridadeDeprecada}[1]{\gdef\@cartaPrecatoriaAutoridadeDeprecada{#1}}
\newcommand{\cartaPrecatoriaOMDeprecada}[1]{\gdef\@cartaPrecatoriaOMDeprecada{#1}}
\newcommand{\cartaPrecatoriaEndereco}[1]{\gdef\@cartaPrecatoriaEndereco{#1}}
\newcommand{\cartaPrecatoriaAssunto}[1]{\gdef\@cartaPrecatoriaAssunto{#1}}
\newcommand{\cartaPrecatoriaReferencia}[1]{\gdef\@cartaPrecatoriaReferencia{#1}}
\newcommand{\cartaPrecatoriaAnexos}[1]{\gdef\@cartaPrecatoriaAnexos{#1}}
\newcommand{\cartaPrecatoriaVocativo}[1]{\gdef\@cartaPrecatoriaVocativo{#1}}
\newcommand{\cartaPrecatoriaFinalidade}[1]{\gdef\@cartaPrecatoriaFinalidade{#1}}
\newcommand{\cartaPrecatoriaPessoaOuvida}[1]{\gdef\@cartaPrecatoriaPessoaOuvida{#1}}
\newcommand{\cartaPrecatoriaQualificacaoPessoa}[1]{\gdef\@cartaPrecatoriaQualificacaoPessoa{#1}}
\newcommand{\cartaPrecatoriaPrazo}[1]{\gdef\@cartaPrecatoriaPrazo{#1}}
\newcommand{\cartaPrecatoriaQuesitos}[1]{\gdef\@cartaPrecatoriaQuesitos{#1}}
\newcommand{\cartaPrecatoriaTextoComplementar}[1]{\gdef\@cartaPrecatoriaTextoComplementar{#1}}
\newcommand{\cartaPrecatoriaLocalData}[1]{\gdef\@cartaPrecatoriaLocalData{#1}}
\newcommand{\cartaPrecatoriaFecho}[1]{\gdef\@cartaPrecatoriaFecho{#1}}

\sind@limparCartaPrecatoria

\newcommand{\getCartaPrecatoriaNumero}{\@cartaPrecatoriaNumero}
\newcommand{\getCartaPrecatoriaOrigem}{\@cartaPrecatoriaOrigem}
\newcommand{\getCartaPrecatoriaRemetente}{\@cartaPrecatoriaRemetente}
\newcommand{\getCartaPrecatoriaAutoridadeDeprecada}{\@cartaPrecatoriaAutoridadeDeprecada}
\newcommand{\getCartaPrecatoriaOMDeprecada}{\@cartaPrecatoriaOMDeprecada}
\newcommand{\getCartaPrecatoriaEndereco}{\@cartaPrecatoriaEndereco}
\newcommand{\getCartaPrecatoriaAssunto}{\@cartaPrecatoriaAssunto}
\newcommand{\getCartaPrecatoriaReferencia}{\@cartaPrecatoriaReferencia}
\newcommand{\getCartaPrecatoriaAnexos}{\@cartaPrecatoriaAnexos}
\newcommand{\getCartaPrecatoriaVocativo}{\@cartaPrecatoriaVocativo}
\newcommand{\getCartaPrecatoriaFinalidade}{\@cartaPrecatoriaFinalidade}
\newcommand{\getCartaPrecatoriaPessoaOuvida}{\@cartaPrecatoriaPessoaOuvida}
\newcommand{\getCartaPrecatoriaQualificacaoPessoa}{\@cartaPrecatoriaQualificacaoPessoa}
\newcommand{\getCartaPrecatoriaPrazo}{\@cartaPrecatoriaPrazo}
\newcommand{\getCartaPrecatoriaQuesitos}{\@cartaPrecatoriaQuesitos}
\newcommand{\getCartaPrecatoriaTextoComplementar}{\@cartaPrecatoriaTextoComplementar}
\newcommand{\getCartaPrecatoriaLocalData}{\@cartaPrecatoriaLocalData}
\newcommand{\getCartaPrecatoriaFecho}{\@cartaPrecatoriaFecho}

\newcommand{\ValidarCartaPrecatoria}{%
  \CampoObrigatorio{dia}{dia da carta precatória}%
  \CampoObrigatorio{mes}{mês da carta precatória}%
  \CampoObrigatorio{ano}{ano da carta precatória}%
  \CampoObrigatorio{cidade}{cidade da carta precatória}%
  \CampoObrigatorio{nup}{NUP/EB da carta precatória}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorioRaw{cartaPrecatoriaNumero}{número da carta precatória}%
  \CampoObrigatorioRaw{cartaPrecatoriaAutoridadeDeprecada}{autoridade deprecada}%
  \CampoObrigatorioRaw{cartaPrecatoriaOMDeprecada}{OM/órgão deprecado}%
  \CampoObrigatorioRaw{cartaPrecatoriaAssunto}{assunto da carta precatória}%
  \CampoObrigatorioRaw{cartaPrecatoriaFinalidade}{finalidade da carta precatória}%
  \CampoObrigatorioRaw{cartaPrecatoriaPessoaOuvida}{pessoa a ser ouvida}%
  \CampoObrigatorioRaw{cartaPrecatoriaQuesitos}{quesitos da carta precatória}%
}




% ============================================================
% 26. DADOS ESPECÍFICOS DE VISTA AO SINDICADO PARA ALEGAÇÕES FINAIS
% ============================================================
% Padrão de uso: dados/dados-vista-alegacoes-finais.tex.
% Este documento vem após o termo de encerramento da instrução.
\newcommand{\sind@limparVistaAlegacoes}{%
  \gdef\@vistaAlegacoesNumero{}%
  \gdef\@vistaAlegacoesLocal{}%
  \gdef\@vistaAlegacoesPrazo{5 (cinco) dias corridos}%
  \gdef\@vistaAlegacoesObjeto{apresentar, caso queira, suas alegações finais por escrito}%
  \gdef\@vistaAlegacoesTextoComplementar{}%
  \gdef\@vistaAlegacoesLocalData{}%
  \gdef\@vistaAlegacoesHora{}%
}
\newcommand{\novaVistaAlegacoes}{\sind@limparVistaAlegacoes}

\newcommand{\vistaAlegacoesNumero}[1]{\gdef\@vistaAlegacoesNumero{#1}}
\newcommand{\vistaAlegacoesLocal}[1]{\gdef\@vistaAlegacoesLocal{#1}}
\newcommand{\vistaAlegacoesPrazo}[1]{\gdef\@vistaAlegacoesPrazo{#1}}
\newcommand{\vistaAlegacoesObjeto}[1]{\gdef\@vistaAlegacoesObjeto{#1}}
\newcommand{\vistaAlegacoesTextoComplementar}[1]{\gdef\@vistaAlegacoesTextoComplementar{#1}}
\newcommand{\vistaAlegacoesLocalData}[1]{\gdef\@vistaAlegacoesLocalData{#1}}
\newcommand{\vistaAlegacoesHora}[1]{\gdef\@vistaAlegacoesHora{#1}}

\sind@limparVistaAlegacoes

\newcommand{\getVistaAlegacoesNumero}{\@vistaAlegacoesNumero}
\newcommand{\getVistaAlegacoesLocal}{\@vistaAlegacoesLocal}
\newcommand{\getVistaAlegacoesPrazo}{\@vistaAlegacoesPrazo}
\newcommand{\getVistaAlegacoesObjeto}{\@vistaAlegacoesObjeto}
\newcommand{\getVistaAlegacoesTextoComplementar}{\@vistaAlegacoesTextoComplementar}
\newcommand{\getVistaAlegacoesLocalData}{\@vistaAlegacoesLocalData}
\newcommand{\getVistaAlegacoesHora}{\@vistaAlegacoesHora}

\newcommand{\ValidarVistaAlegacoes}{%
  \CampoObrigatorio{dia}{dia da vista para alegações finais}%
  \CampoObrigatorio{mes}{mês da vista para alegações finais}%
  \CampoObrigatorio{ano}{ano da vista para alegações finais}%
  \CampoObrigatorio{cidade}{cidade da vista para alegações finais}%
  \CampoObrigatorio{om}{organização militar}%
  \CampoObrigatorio{nup}{NUP da sindicância}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorio{sindicadoNome}{nome do sindicado}%
  \CampoObrigatorio{sindicadoPosto}{posto/graduação do sindicado}%
  \CampoObrigatorioRaw{vistaAlegacoesNumero}{número da vista para alegações finais}%
  \CampoObrigatorioRaw{vistaAlegacoesLocal}{local da vista para alegações finais}%
  \CampoObrigatorioRaw{vistaAlegacoesPrazo}{prazo para alegações finais}%
}




% ============================================================
% 27. ANEXO M - COMPARECIMENTO DE SINDICADO
% ============================================================
\newcommand{\sind@limparComparecimentoSindicado}{%
  \gdef\@compSindNumero{}%
  \gdef\@compSindOrigem{Sindicante}%
  \gdef\@compSindLocalData{}%
  \gdef\@compSindComandante{}%
  \gdef\@compSindData{}%
  \gdef\@compSindHora{}%
  \gdef\@compSindLocal{}%
}
\newcommand{\novoComparecimentoSindicado}{\sind@limparComparecimentoSindicado}

\newcommand{\comparecimentoSindicadoNumero}[1]{\gdef\@compSindNumero{#1}}
\newcommand{\comparecimentoSindicadoOrigem}[1]{\gdef\@compSindOrigem{#1}}
\newcommand{\comparecimentoSindicadoLocalData}[1]{\gdef\@compSindLocalData{#1}}
\newcommand{\comparecimentoSindicadoComandante}[1]{\gdef\@compSindComandante{#1}}
\newcommand{\comparecimentoSindicadoData}[1]{\gdef\@compSindData{#1}}
\newcommand{\comparecimentoSindicadoHora}[1]{\gdef\@compSindHora{#1}}
\newcommand{\comparecimentoSindicadoLocal}[1]{\gdef\@compSindLocal{#1}}

\sind@limparComparecimentoSindicado

\newcommand{\getComparecimentoSindicadoNumero}{\@compSindNumero}
\newcommand{\getComparecimentoSindicadoOrigem}{\@compSindOrigem}
\newcommand{\getComparecimentoSindicadoLocalData}{\@compSindLocalData}
\newcommand{\getComparecimentoSindicadoComandante}{\@compSindComandante}
\newcommand{\getComparecimentoSindicadoData}{\@compSindData}
\newcommand{\getComparecimentoSindicadoHora}{\@compSindHora}
\newcommand{\getComparecimentoSindicadoLocal}{\@compSindLocal}

\newcommand{\ValidarComparecimentoSindicado}{%
  \CampoObrigatorio{nup}{NUP/EB do DIEx de comparecimento de sindicado}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorio{sindicadoNome}{nome do sindicado}%
  \CampoObrigatorio{sindicadoPosto}{posto/graduação do sindicado}%
  \CampoObrigatorioRaw{compSindNumero}{número do DIEx de comparecimento de sindicado}%
  \CampoObrigatorioRaw{compSindComandante}{comandante do sindicado}%
  \CampoObrigatorioRaw{compSindData}{data de comparecimento do sindicado}%
  \CampoObrigatorioRaw{compSindHora}{hora de comparecimento do sindicado}%
  \CampoObrigatorioRaw{compSindLocal}{local de comparecimento do sindicado}%
}

% ============================================================
% 28. ANEXO N - COMPARECIMENTO DE TESTEMUNHA
% ============================================================
\newcommand{\sind@limparComparecimentoTestemunha}{%
  \gdef\@compTestNumero{}%
  \gdef\@compTestOrigem{Sindicante}%
  \gdef\@compTestLocalData{}%
  \gdef\@compTestDestinatario{}%
  \gdef\@compTestData{}%
  \gdef\@compTestHora{}%
  \gdef\@compTestQuartel{}%
  \gdef\@compTestEndereco{}%
}
\newcommand{\novoComparecimentoTestemunha}{\sind@limparComparecimentoTestemunha}

\newcommand{\comparecimentoTestemunhaNumero}[1]{\gdef\@compTestNumero{#1}}
\newcommand{\comparecimentoTestemunhaOrigem}[1]{\gdef\@compTestOrigem{#1}}
\newcommand{\comparecimentoTestemunhaLocalData}[1]{\gdef\@compTestLocalData{#1}}
\newcommand{\comparecimentoTestemunhaDestinatario}[1]{\gdef\@compTestDestinatario{#1}}
\newcommand{\comparecimentoTestemunhaData}[1]{\gdef\@compTestData{#1}}
\newcommand{\comparecimentoTestemunhaHora}[1]{\gdef\@compTestHora{#1}}
\newcommand{\comparecimentoTestemunhaQuartel}[1]{\gdef\@compTestQuartel{#1}}
\newcommand{\comparecimentoTestemunhaEndereco}[1]{\gdef\@compTestEndereco{#1}}

\sind@limparComparecimentoTestemunha

\newcommand{\getComparecimentoTestemunhaNumero}{\@compTestNumero}
\newcommand{\getComparecimentoTestemunhaOrigem}{\@compTestOrigem}
\newcommand{\getComparecimentoTestemunhaLocalData}{\@compTestLocalData}
\newcommand{\getComparecimentoTestemunhaDestinatario}{\@compTestDestinatario}
\newcommand{\getComparecimentoTestemunhaData}{\@compTestData}
\newcommand{\getComparecimentoTestemunhaHora}{\@compTestHora}
\newcommand{\getComparecimentoTestemunhaQuartel}{\@compTestQuartel}
\newcommand{\getComparecimentoTestemunhaEndereco}{\@compTestEndereco}

\newcommand{\ValidarComparecimentoTestemunha}{%
  \CampoObrigatorio{nup}{NUP/EB do DIEx de comparecimento de testemunha}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorioRaw{compTestNumero}{número do DIEx de comparecimento de testemunha}%
  \CampoObrigatorioRaw{compTestDestinatario}{destinatário do comparecimento de testemunha}%
  \CampoObrigatorioRaw{compTestData}{data de comparecimento da testemunha}%
  \CampoObrigatorioRaw{compTestHora}{hora de comparecimento da testemunha}%
  \CampoObrigatorioRaw{compTestQuartel}{quartel/local de comparecimento da testemunha}%
  \CampoObrigatorioRaw{compTestEndereco}{endereço do local de comparecimento da testemunha}%
}

% ============================================================
% 29. ANEXO V - CERTIDÃO
% ============================================================
\newcommand{\sind@limparCertidao}{%
  \gdef\@certidaoDataTerminoPrazo{}%
  \gdef\@certidaoTipoDocumento{DIEx}%
  \gdef\@certidaoNumeroDocumento{}%
  \gdef\@certidaoDataDocumento{}%
  \gdef\@certidaoLocalData{}%
  \gdef\@certidaoTexto{}%
  \gdef\@certidaoCiencia{}%
}
\newcommand{\novaCertidao}{\sind@limparCertidao}

\newcommand{\certidaoDataTerminoPrazo}[1]{\gdef\@certidaoDataTerminoPrazo{#1}}
\newcommand{\certidaoTipoDocumento}[1]{\gdef\@certidaoTipoDocumento{#1}}
\newcommand{\certidaoNumeroDocumento}[1]{\gdef\@certidaoNumeroDocumento{#1}}
\newcommand{\certidaoDataDocumento}[1]{\gdef\@certidaoDataDocumento{#1}}
\newcommand{\certidaoLocalData}[1]{\gdef\@certidaoLocalData{#1}}
\newcommand{\certidaoTexto}[1]{\gdef\@certidaoTexto{#1}}
\newcommand{\certidaoCiencia}[1]{\gdef\@certidaoCiencia{#1}}

\sind@limparCertidao

\newcommand{\getCertidaoDataTerminoPrazo}{\@certidaoDataTerminoPrazo}
\newcommand{\getCertidaoTipoDocumento}{\@certidaoTipoDocumento}
\newcommand{\getCertidaoNumeroDocumento}{\@certidaoNumeroDocumento}
\newcommand{\getCertidaoDataDocumento}{\@certidaoDataDocumento}
\newcommand{\getCertidaoLocalData}{\@certidaoLocalData}
\newcommand{\getCertidaoTexto}{\@certidaoTexto}
\newcommand{\getCertidaoCiencia}{\@certidaoCiencia}

\newcommand{\ValidarCertidao}{%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorioRaw{certidaoTexto}{texto da certidão}%
}

% ============================================================
% 30. ANEXO W - RELATÓRIO
% ============================================================
\newcommand{\sind@limparRelatorio}{%
  \gdef\@relatorioIntroducao{}%
  \gdef\@relatorioDiligencias{}%
  \gdef\@relatorioParteExpositiva{}%
  \gdef\@relatorioParteConclusiva{}%
  \gdef\@relatorioLocalData{}%
}
\newcommand{\novoRelatorio}{\sind@limparRelatorio}

\newcommand{\relatorioIntroducao}[1]{\gdef\@relatorioIntroducao{#1}}
\newcommand{\relatorioDiligencias}[1]{\gdef\@relatorioDiligencias{#1}}
\newcommand{\relatorioParteExpositiva}[1]{\gdef\@relatorioParteExpositiva{#1}}
\newcommand{\relatorioParteConclusiva}[1]{\gdef\@relatorioParteConclusiva{#1}}
\newcommand{\relatorioLocalData}[1]{\gdef\@relatorioLocalData{#1}}

\sind@limparRelatorio

\newcommand{\getRelatorioIntroducao}{\@relatorioIntroducao}
\newcommand{\getRelatorioDiligencias}{\@relatorioDiligencias}
\newcommand{\getRelatorioParteExpositiva}{\@relatorioParteExpositiva}
\newcommand{\getRelatorioParteConclusiva}{\@relatorioParteConclusiva}
\newcommand{\getRelatorioLocalData}{\@relatorioLocalData}

\newcommand{\ValidarRelatorio}{%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorioRaw{relatorioIntroducao}{introdução do relatório}%
  \CampoObrigatorioRaw{relatorioDiligencias}{diligências realizadas no relatório}%
  \CampoObrigatorioRaw{relatorioParteExpositiva}{parte expositiva do relatório}%
  \CampoObrigatorioRaw{relatorioParteConclusiva}{parte conclusiva do relatório}%
}

% ============================================================
% 31. ANEXO X - TERMO DE ENCERRAMENTO
% ============================================================
\newcommand{\sind@limparTermoEncerramento}{%
  \gdef\@termoEncerramentoPortaria{}%
}
\newcommand{\novoTermoEncerramento}{\sind@limparTermoEncerramento}

\newcommand{\termoEncerramentoPortaria}[1]{\gdef\@termoEncerramentoPortaria{#1}}

\sind@limparTermoEncerramento

\newcommand{\getTermoEncerramentoPortaria}{\@termoEncerramentoPortaria}

\newcommand{\ValidarTermoEncerramento}{%
  \CampoObrigatorio{dia}{dia do termo de encerramento}%
  \CampoObrigatorio{mes}{mês do termo de encerramento}%
  \CampoObrigatorio{ano}{ano do termo de encerramento}%
  \CampoObrigatorio{cidade}{cidade do termo de encerramento}%
  \CampoObrigatorio{om}{organização militar}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
}

% ============================================================
% 32. ANEXO Y - DIEx DE REMESSA
% ============================================================
\newcommand{\sind@limparDiexRemessa}{%
  \gdef\@diexRemessaNumero{}%
  \gdef\@diexRemessaOrigem{Sindicante}%
  \gdef\@diexRemessaLocalData{}%
  \gdef\@diexRemessaDestinatario{}%
  \gdef\@diexRemessaFolhas{}%
  \gdef\@diexRemessaReferencia{}%
  \gdef\@diexRemessaTextoComplementar{}%
}
\newcommand{\novoDiexRemessa}{\sind@limparDiexRemessa}

\newcommand{\diexRemessaNumero}[1]{\gdef\@diexRemessaNumero{#1}}
\newcommand{\diexRemessaOrigem}[1]{\gdef\@diexRemessaOrigem{#1}}
\newcommand{\diexRemessaLocalData}[1]{\gdef\@diexRemessaLocalData{#1}}
\newcommand{\diexRemessaDestinatario}[1]{\gdef\@diexRemessaDestinatario{#1}}
\newcommand{\diexRemessaFolhas}[1]{\gdef\@diexRemessaFolhas{#1}}
\newcommand{\diexRemessaReferencia}[1]{\gdef\@diexRemessaReferencia{#1}}
\newcommand{\diexRemessaTextoComplementar}[1]{\gdef\@diexRemessaTextoComplementar{#1}}

\sind@limparDiexRemessa

\newcommand{\getDiexRemessaNumero}{\@diexRemessaNumero}
\newcommand{\getDiexRemessaOrigem}{\@diexRemessaOrigem}
\newcommand{\getDiexRemessaLocalData}{\@diexRemessaLocalData}
\newcommand{\getDiexRemessaDestinatario}{\@diexRemessaDestinatario}
\newcommand{\getDiexRemessaFolhas}{\@diexRemessaFolhas}
\newcommand{\getDiexRemessaReferencia}{\@diexRemessaReferencia}
\newcommand{\getDiexRemessaTextoComplementar}{\@diexRemessaTextoComplementar}

\newcommand{\ValidarDiexRemessa}{%
  \CampoObrigatorio{nup}{NUP/EB do DIEx de remessa}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorio{sindicadoNome}{nome do sindicado}%
  \CampoObrigatorio{sindicadoPosto}{posto/graduação do sindicado}%
  \CampoObrigatorioRaw{diexRemessaNumero}{número do DIEx de remessa}%
  \CampoObrigatorioRaw{diexRemessaDestinatario}{destinatário do DIEx de remessa}%
  \CampoObrigatorioRaw{diexRemessaFolhas}{quantidade de folhas da sindicância}%
}

% ============================================================
% 33. MODELO AUXILIAR - SOLICITAÇÃO DE PRORROGAÇÃO DE PRAZO
% ============================================================
\newcommand{\sind@limparProrrogacao}{%
  \gdef\@prorrogacaoNumero{}%
  \gdef\@prorrogacaoOrigem{Sindicante}%
  \gdef\@prorrogacaoLocalData{}%
  \gdef\@prorrogacaoDestinatario{}%
  \gdef\@prorrogacaoReferencia{}%
  \gdef\@prorrogacaoPrazo{}%
  \gdef\@prorrogacaoDataInicio{}%
  \gdef\@prorrogacaoFaseAndamento{}%
  \gdef\@prorrogacaoJustificativa{}%
}
\newcommand{\novaSolicitacaoProrrogacao}{\sind@limparProrrogacao}

\newcommand{\prorrogacaoNumero}[1]{\gdef\@prorrogacaoNumero{#1}}
\newcommand{\prorrogacaoOrigem}[1]{\gdef\@prorrogacaoOrigem{#1}}
\newcommand{\prorrogacaoLocalData}[1]{\gdef\@prorrogacaoLocalData{#1}}
\newcommand{\prorrogacaoDestinatario}[1]{\gdef\@prorrogacaoDestinatario{#1}}
\newcommand{\prorrogacaoReferencia}[1]{\gdef\@prorrogacaoReferencia{#1}}
\newcommand{\prorrogacaoPrazo}[1]{\gdef\@prorrogacaoPrazo{#1}}
\newcommand{\prorrogacaoDataInicio}[1]{\gdef\@prorrogacaoDataInicio{#1}}
\newcommand{\prorrogacaoFaseAndamento}[1]{\gdef\@prorrogacaoFaseAndamento{#1}}
\newcommand{\prorrogacaoJustificativa}[1]{\gdef\@prorrogacaoJustificativa{#1}}

\sind@limparProrrogacao

\newcommand{\getProrrogacaoNumero}{\@prorrogacaoNumero}
\newcommand{\getProrrogacaoOrigem}{\@prorrogacaoOrigem}
\newcommand{\getProrrogacaoLocalData}{\@prorrogacaoLocalData}
\newcommand{\getProrrogacaoDestinatario}{\@prorrogacaoDestinatario}
\newcommand{\getProrrogacaoReferencia}{\@prorrogacaoReferencia}
\newcommand{\getProrrogacaoPrazo}{\@prorrogacaoPrazo}
\newcommand{\getProrrogacaoDataInicio}{\@prorrogacaoDataInicio}
\newcommand{\getProrrogacaoFaseAndamento}{\@prorrogacaoFaseAndamento}
\newcommand{\getProrrogacaoJustificativa}{\@prorrogacaoJustificativa}

\newcommand{\ValidarSolicitacaoProrrogacao}{%
  \CampoObrigatorio{nup}{NUP/EB da solicitação de prorrogação}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorioRaw{prorrogacaoNumero}{número do DIEx de prorrogação}%
  \CampoObrigatorioRaw{prorrogacaoDestinatario}{destinatário da solicitação de prorrogação}%
  \CampoObrigatorioRaw{prorrogacaoReferencia}{referência da solicitação de prorrogação}%
  \CampoObrigatorioRaw{prorrogacaoPrazo}{prazo solicitado na prorrogação}%
  \CampoObrigatorioRaw{prorrogacaoDataInicio}{data inicial da prorrogação}%
  \CampoObrigatorioRaw{prorrogacaoFaseAndamento}{fase atual da sindicância}%
  \CampoObrigatorioRaw{prorrogacaoJustificativa}{justificativa da prorrogação}%
}




% ============================================================
% 34. ANEXO F - DESIGNAÇÃO DE ESCRIVÃO
% ============================================================
\newcommand{\sind@limparDesignacaoEscrivao}{%
  \gdef\@designacaoEscrivaoNumero{}%
  \gdef\@designacaoEscrivaoLocalData{}%
  \gdef\@designacaoEscrivaoPortaria{}%
}
\newcommand{\novaDesignacaoEscrivao}{\sind@limparDesignacaoEscrivao}

\newcommand{\designacaoEscrivaoNumero}[1]{\gdef\@designacaoEscrivaoNumero{#1}}
\newcommand{\designacaoEscrivaoLocalData}[1]{\gdef\@designacaoEscrivaoLocalData{#1}}
\newcommand{\designacaoEscrivaoPortaria}[1]{\gdef\@designacaoEscrivaoPortaria{#1}}

\sind@limparDesignacaoEscrivao

\newcommand{\getDesignacaoEscrivaoNumero}{\@designacaoEscrivaoNumero}
\newcommand{\getDesignacaoEscrivaoLocalData}{\@designacaoEscrivaoLocalData}
\newcommand{\getDesignacaoEscrivaoPortaria}{%
  \ifstrempty{\@designacaoEscrivaoPortaria}{\@portaria}{\@designacaoEscrivaoPortaria}%
}

\newcommand{\ValidarDesignacaoEscrivao}{%
  \CampoObrigatorio{escrivaoNome}{nome do escrivão designado}%
  \CampoObrigatorio{escrivaoPosto}{posto/graduação do escrivão designado}%
  \CampoObrigatorio{autoridadeNome}{nome da autoridade nomeante}%
  \CampoObrigatorio{autoridadePosto}{posto/graduação da autoridade nomeante}%
  \CampoObrigatorio{portaria}{portaria instauradora}%
}

% ============================================================
% 35. ANEXO G - COMPROMISSO DE ESCRIVÃO
% ============================================================
\newcommand{\sind@limparCompromissoEscrivao}{%
  \gdef\@compromissoEscrivaoLocalData{}%
}
\newcommand{\novoCompromissoEscrivao}{\sind@limparCompromissoEscrivao}

\newcommand{\compromissoEscrivaoLocalData}[1]{\gdef\@compromissoEscrivaoLocalData{#1}}

\sind@limparCompromissoEscrivao

\newcommand{\getCompromissoEscrivaoLocalData}{\@compromissoEscrivaoLocalData}

\newcommand{\ValidarCompromissoEscrivao}{%
  \CampoObrigatorio{dia}{dia do compromisso de escrivão}%
  \CampoObrigatorio{mes}{mês do compromisso de escrivão}%
  \CampoObrigatorio{ano}{ano do compromisso de escrivão}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorio{escrivaoNome}{nome do escrivão}%
  \CampoObrigatorio{escrivaoPosto}{posto/graduação do escrivão}%
  \CampoObrigatorio{autoridadeNome}{nome da autoridade nomeante}%
}

% ============================================================
% 36. ANEXO J - NOTIFICAÇÃO DE ENVOLVIDO QUE PASSA À CONDIÇÃO DE SINDICADO
% ============================================================
\newcommand{\sind@limparNotificacaoNovoSindicado}{%
  \gdef\@notNovoSindNumero{}%
  \gdef\@notNovoSindOrigem{Sindicante}%
  \gdef\@notNovoSindLocalData{}%
  \gdef\@notNovoSindDestinatario{}%
  \gdef\@notNovoSindAnexos{}%
  \gdef\@notNovoSindLocalVista{}%
  \gdef\@notNovoSindDataReinquiricao{}%
  \gdef\@notNovoSindHoraReinquiricao{}%
  \gdef\@notNovoSindLocalReinquiricao{}%
}
\newcommand{\novaNotificacaoNovoSindicado}{\sind@limparNotificacaoNovoSindicado}

\newcommand{\notificacaoNovoSindicadoNumero}[1]{\gdef\@notNovoSindNumero{#1}}
\newcommand{\notificacaoNovoSindicadoOrigem}[1]{\gdef\@notNovoSindOrigem{#1}}
\newcommand{\notificacaoNovoSindicadoLocalData}[1]{\gdef\@notNovoSindLocalData{#1}}
\newcommand{\notificacaoNovoSindicadoDestinatario}[1]{\gdef\@notNovoSindDestinatario{#1}}
\newcommand{\notificacaoNovoSindicadoAnexos}[1]{\gdef\@notNovoSindAnexos{#1}}
\newcommand{\notificacaoNovoSindicadoLocalVista}[1]{\gdef\@notNovoSindLocalVista{#1}}
\newcommand{\notificacaoNovoSindicadoDataReinquiricao}[1]{\gdef\@notNovoSindDataReinquiricao{#1}}
\newcommand{\notificacaoNovoSindicadoHoraReinquiricao}[1]{\gdef\@notNovoSindHoraReinquiricao{#1}}
\newcommand{\notificacaoNovoSindicadoLocalReinquiricao}[1]{\gdef\@notNovoSindLocalReinquiricao{#1}}

\sind@limparNotificacaoNovoSindicado

\newcommand{\getNotificacaoNovoSindicadoNumero}{\@notNovoSindNumero}
\newcommand{\getNotificacaoNovoSindicadoOrigem}{\@notNovoSindOrigem}
\newcommand{\getNotificacaoNovoSindicadoLocalData}{\@notNovoSindLocalData}
\newcommand{\getNotificacaoNovoSindicadoDestinatario}{\@notNovoSindDestinatario}
\newcommand{\getNotificacaoNovoSindicadoAnexos}{\@notNovoSindAnexos}
\newcommand{\getNotificacaoNovoSindicadoLocalVista}{\@notNovoSindLocalVista}
\newcommand{\getNotificacaoNovoSindicadoDataReinquiricao}{\@notNovoSindDataReinquiricao}
\newcommand{\getNotificacaoNovoSindicadoHoraReinquiricao}{\@notNovoSindHoraReinquiricao}
\newcommand{\getNotificacaoNovoSindicadoLocalReinquiricao}{\@notNovoSindLocalReinquiricao}

\newcommand{\ValidarNotificacaoNovoSindicado}{%
  \CampoObrigatorio{nup}{NUP/EB da notificação de novo sindicado}%
  \CampoObrigatorio{portaria}{portaria instauradora}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorio{sindicadoNome}{nome do novo sindicado}%
  \CampoObrigatorio{sindicadoPosto}{posto/graduação do novo sindicado}%
  \CampoObrigatorioRaw{notNovoSindNumero}{número do DIEx de notificação de novo sindicado}%
  \CampoObrigatorioRaw{notNovoSindDestinatario}{destinatário da notificação de novo sindicado}%
  \CampoObrigatorioRaw{notNovoSindLocalVista}{local de vista dos autos}%
}

% ============================================================
% 37. ANEXO K - NOTIFICAÇÃO DE DILIGÊNCIAS COMPLEMENTARES
% ============================================================
\newcommand{\sind@limparNotificacaoDiligencias}{%
  \gdef\@notDilNumero{}%
  \gdef\@notDilOrigem{Sindicante}%
  \gdef\@notDilLocalData{}%
  \gdef\@notDilDestinatario{}%
  \gdef\@notDilAutoridadeFuncao{}%
  \gdef\@notDilLocalVista{}%
  \gdef\@notDilDescricao{}%
  \gdef\@notDilTipoAudiencia{}%
  \gdef\@notDilDataAudiencia{}%
  \gdef\@notDilHoraAudiencia{}%
  \gdef\@notDilLocalAudiencia{}%
}
\newcommand{\novaNotificacaoDiligencias}{\sind@limparNotificacaoDiligencias}

\newcommand{\notificacaoDiligenciasNumero}[1]{\gdef\@notDilNumero{#1}}
\newcommand{\notificacaoDiligenciasOrigem}[1]{\gdef\@notDilOrigem{#1}}
\newcommand{\notificacaoDiligenciasLocalData}[1]{\gdef\@notDilLocalData{#1}}
\newcommand{\notificacaoDiligenciasDestinatario}[1]{\gdef\@notDilDestinatario{#1}}
\newcommand{\notificacaoDiligenciasAutoridadeFuncao}[1]{\gdef\@notDilAutoridadeFuncao{#1}}
\newcommand{\notificacaoDiligenciasLocalVista}[1]{\gdef\@notDilLocalVista{#1}}
\newcommand{\notificacaoDiligenciasDescricao}[1]{\gdef\@notDilDescricao{#1}}
\newcommand{\notificacaoDiligenciasTipoAudiencia}[1]{\gdef\@notDilTipoAudiencia{#1}}
\newcommand{\notificacaoDiligenciasDataAudiencia}[1]{\gdef\@notDilDataAudiencia{#1}}
\newcommand{\notificacaoDiligenciasHoraAudiencia}[1]{\gdef\@notDilHoraAudiencia{#1}}
\newcommand{\notificacaoDiligenciasLocalAudiencia}[1]{\gdef\@notDilLocalAudiencia{#1}}

\sind@limparNotificacaoDiligencias

\newcommand{\getNotificacaoDiligenciasNumero}{\@notDilNumero}
\newcommand{\getNotificacaoDiligenciasOrigem}{\@notDilOrigem}
\newcommand{\getNotificacaoDiligenciasLocalData}{\@notDilLocalData}
\newcommand{\getNotificacaoDiligenciasDestinatario}{\@notDilDestinatario}
\newcommand{\getNotificacaoDiligenciasAutoridadeFuncao}{%
  \ifstrempty{\@notDilAutoridadeFuncao}{\@autoridadeFuncao}{\@notDilAutoridadeFuncao}%
}
\newcommand{\getNotificacaoDiligenciasLocalVista}{\@notDilLocalVista}
\newcommand{\getNotificacaoDiligenciasDescricao}{\@notDilDescricao}
\newcommand{\getNotificacaoDiligenciasTipoAudiencia}{\@notDilTipoAudiencia}
\newcommand{\getNotificacaoDiligenciasDataAudiencia}{\@notDilDataAudiencia}
\newcommand{\getNotificacaoDiligenciasHoraAudiencia}{\@notDilHoraAudiencia}
\newcommand{\getNotificacaoDiligenciasLocalAudiencia}{\@notDilLocalAudiencia}

\newcommand{\ValidarNotificacaoDiligencias}{%
  \CampoObrigatorio{nup}{NUP/EB da notificação de diligências complementares}%
  \CampoObrigatorio{portaria}{portaria instauradora}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorio{sindicadoNome}{nome do sindicado}%
  \CampoObrigatorio{sindicadoPosto}{posto/graduação do sindicado}%
  \CampoObrigatorioRaw{notDilNumero}{número do DIEx de notificação de diligências complementares}%
  \CampoObrigatorioRaw{notDilDestinatario}{destinatário da notificação de diligências complementares}%
  \CampoObrigatorioRaw{notDilLocalVista}{local de vista dos autos}%
  \CampoObrigatorioRaw{notDilDescricao}{descrição ou referência das diligências complementares}%
}

% ============================================================
% 38. ANEXO R - SUBSTITUIÇÃO DE SINDICANTE
% ============================================================
\newcommand{\sind@limparSubstituicaoSindicante}{%
  \gdef\@substSindNumero{}%
  \gdef\@substSindOrigem{Sindicante}%
  \gdef\@substSindLocalData{}%
  \gdef\@substSindDestinatario{}%
  \gdef\@substSindRelatoSucinto{}%
  \gdef\@substSindFls{}%
  \gdef\@substSindMotivo{}%
}
\newcommand{\novaSubstituicaoSindicante}{\sind@limparSubstituicaoSindicante}

\newcommand{\substituicaoSindicanteNumero}[1]{\gdef\@substSindNumero{#1}}
\newcommand{\substituicaoSindicanteOrigem}[1]{\gdef\@substSindOrigem{#1}}
\newcommand{\substituicaoSindicanteLocalData}[1]{\gdef\@substSindLocalData{#1}}
\newcommand{\substituicaoSindicanteDestinatario}[1]{\gdef\@substSindDestinatario{#1}}
\newcommand{\substituicaoSindicanteRelatoSucinto}[1]{\gdef\@substSindRelatoSucinto{#1}}
\newcommand{\substituicaoSindicanteFls}[1]{\gdef\@substSindFls{#1}}
\newcommand{\substituicaoSindicanteMotivo}[1]{\gdef\@substSindMotivo{#1}}

\sind@limparSubstituicaoSindicante

\newcommand{\getSubstituicaoSindicanteNumero}{\@substSindNumero}
\newcommand{\getSubstituicaoSindicanteOrigem}{\@substSindOrigem}
\newcommand{\getSubstituicaoSindicanteLocalData}{\@substSindLocalData}
\newcommand{\getSubstituicaoSindicanteDestinatario}{\@substSindDestinatario}
\newcommand{\getSubstituicaoSindicanteRelatoSucinto}{\@substSindRelatoSucinto}
\newcommand{\getSubstituicaoSindicanteFls}{\@substSindFls}
\newcommand{\getSubstituicaoSindicanteMotivo}{\@substSindMotivo}

\newcommand{\ValidarSubstituicaoSindicante}{%
  \CampoObrigatorio{nup}{NUP/EB do DIEx de substituição de sindicante}%
  \CampoObrigatorio{portaria}{portaria instauradora}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorioRaw{substSindNumero}{número do DIEx de substituição de sindicante}%
  \CampoObrigatorioRaw{substSindDestinatario}{destinatário do DIEx de substituição de sindicante}%
  \CampoObrigatorioRaw{substSindRelatoSucinto}{relato sucinto da sindicância}%
  \CampoObrigatorioRaw{substSindFls}{folhas do documento que fundamenta a substituição}%
  \CampoObrigatorioRaw{substSindMotivo}{motivo da substituição}%
}

% ============================================================
% 39. ANEXO S - TERMO DE ACAREAÇÃO
% ============================================================
\newcommand{\sind@limparAcareacao}{%
  \gdef\@acareacaoDataAta{}%
  \gdef\@acareacaoLocal{}%
  \gdef\@acareacaoPontosDivergencia{}%
  \gdef\@acareacaoDeclaracaoA{}%
  \gdef\@acareacaoDeclaracaoB{}%
  \gdef\@acareacaoDeclaracaoSindicado{}%
}
\newcommand{\novaAcareacao}{\sind@limparAcareacao}

\newcommand{\acareacaoDataAta}[1]{\gdef\@acareacaoDataAta{#1}}
\newcommand{\acareacaoLocal}[1]{\gdef\@acareacaoLocal{#1}}
\newcommand{\acareacaoPontosDivergencia}[1]{\gdef\@acareacaoPontosDivergencia{#1}}
\newcommand{\acareacaoDeclaracaoA}[1]{\gdef\@acareacaoDeclaracaoA{#1}}
\newcommand{\acareacaoDeclaracaoB}[1]{\gdef\@acareacaoDeclaracaoB{#1}}
\newcommand{\acareacaoDeclaracaoSindicado}[1]{\gdef\@acareacaoDeclaracaoSindicado{#1}}

\sind@limparAcareacao

\newcommand{\getAcareacaoDataAta}{\@acareacaoDataAta}
\newcommand{\getAcareacaoLocal}{\@acareacaoLocal}
\newcommand{\getAcareacaoPontosDivergencia}{\@acareacaoPontosDivergencia}
\newcommand{\getAcareacaoDeclaracaoA}{\@acareacaoDeclaracaoA}
\newcommand{\getAcareacaoDeclaracaoB}{\@acareacaoDeclaracaoB}
\newcommand{\getAcareacaoDeclaracaoSindicado}{\@acareacaoDeclaracaoSindicado}

\newcommand{\ValidarAcareacao}{%
  \CampoObrigatorio{nup}{NUP da sindicância}%
  \CampoObrigatorio{cidade}{cidade da acareação}%
  \CampoObrigatorio{om}{organização militar}%
  \CampoObrigatorio{sindicanteNome}{nome do sindicante}%
  \CampoObrigatorio{sindicantePosto}{posto/graduação do sindicante}%
  \CampoObrigatorio{sindicadoNome}{nome do sindicado}%
  \CampoObrigatorio{testemunhaANome}{nome da testemunha A}%
  \CampoObrigatorio{testemunhaBNome}{nome da testemunha B}%
  \CampoObrigatorioRaw{acareacaoDataAta}{data da acareação por extenso}%
  \CampoObrigatorioRaw{acareacaoPontosDivergencia}{pontos de divergência}%
  \CampoObrigatorioRaw{acareacaoDeclaracaoA}{declaração da testemunha A}%
  \CampoObrigatorioRaw{acareacaoDeclaracaoB}{declaração da testemunha B}%
  \CampoObrigatorioRaw{acareacaoDeclaracaoSindicado}{declaração do sindicado}%
}


% ============================================================
% 33. AUXILIARES DE ASSINATURA E RECIBO
% ============================================================
\newcommand{\assinaturaCentral}[2]{%
  \vspace{2cm}%
  \begin{center}
    \rule{8cm}{0.4pt}\\
    #1\\
    #2
  \end{center}%
}

\newcommand{\reciboCienciaSindicado}{%
  \vspace{0.8cm}%
  \noindent Declaro que tenho ciência.\\[0.8em]
  \noindent Data: \rule{1.2cm}{0.4pt}/\rule{1.2cm}{0.4pt}/\rule{1.8cm}{0.4pt}
  \vspace{1.4cm}
  \begin{center}
    \rule{8cm}{0.4pt}\\
    \getSindicadoPosto\ \getSindicadoNome
  \end{center}%
}

\makeatother
\endinput
