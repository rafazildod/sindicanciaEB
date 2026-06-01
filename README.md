# Sindicância EB em LaTeX

Modelos em LaTeX para elaboração de documentos de sindicância no âmbito do Exército Brasileiro, estruturados a partir dos anexos oficiais da **EB10-IG-09.001**.

Este projeto usa o LaTeX como motor de formatação para gerar documentos padronizados em PDF, preservando uma estrutura modular: dados em arquivos separados, modelos por anexo e uma classe central (`sindicancia.cls`) com a configuração visual do projeto.

A ideia é simples, o que já é uma afronta à burocracia: você preenche os arquivos em `dados/`, escolhe no `main.tex` quais documentos serão gerados e compila com LuaLaTeX.

---

## Situação atual do projeto

O projeto já contém modelos para os anexos **C a Y**, exceto os anexos **A, B, Z e AA**, que foram deliberadamente excluídos do escopo.

Os modelos foram organizados para permitir:

- geração de uma sindicância completa de teste;
- ativação/desativação de documentos pelo `main.tex`;
- reutilização de dados comuns da sindicância;
- inclusão de PDFs externos por juntada;
- uso de cabeçalho institucional com brasão;
- carimbo `Fl. ____` nas páginas dos autos, exceto na capa;
- padronização em A4, Times 12 e margens de 2,5 cm.

---

## Estrutura de pastas

```text
sindicanciaEB/
├── main.tex
├── sindicancia.cls
├── bases/
│   ├── anexo_c_capa.docx
│   ├── ...
│   └── anexo_y_diex_remessa.docx
├── dados/
│   ├── dados-sindicancia.tex
│   ├── dados-anexo-c-capa.tex
│   ├── ...
│   └── dados-anexo-y-diex-remessa.tex
├── documentos/
│   └── docjuntada1.pdf
├── figs/
│   └── Coat.pdf
└── modelos/
    ├── capa.tex
    ├── ...
    └── diex-remessa.tex
```

### `sindicancia.cls`

Classe LaTeX central do projeto. Define:

- papel A4;
- margens de 2,5 cm;
- fonte Times New Roman, com fallback para Liberation Serif;
- cabeçalho institucional;
- caixa `Fl. ____`;
- macros de dados comuns;
- comandos de validação;
- comandos de assinatura;
- comandos específicos por anexo.

### `main.tex`

Arquivo principal de compilação.

No estado atual, o `main.tex` é um **main de teste completo**, com todos os anexos implementados descomentados. Ele serve para validar se o projeto inteiro compila.

Para uma sindicância real, comente os blocos que não serão usados.

### `dados/`

Contém os arquivos com os dados variáveis de cada peça.

O arquivo mais importante é:

```text
dados/dados-sindicancia.tex
```

Ele concentra os dados gerais reutilizados por vários modelos:

- data;
- cidade;
- OM;
- NUP;
- portaria;
- objeto;
- autoridade instauradora;
- sindicante;
- sindicado.

Os demais arquivos seguem o padrão:

```text
dados-anexo-<letra>-<nome>.tex
```

Exemplos:

```text
dados-anexo-c-capa.tex
dados-anexo-i-notificacao-previa1.tex
dados-anexo-q-inquiricao-sindicado1.tex
```

### `modelos/`

Contém os modelos LaTeX de cada documento.

Em regra, você não deve editar estes arquivos em uma sindicância comum. Edite os arquivos em `dados/`.

### `documentos/`

Pasta destinada aos PDFs externos juntados aos autos.

O modelo de juntada usa este padrão:

```text
documentos/docjuntada1.pdf
documentos/docjuntada2.pdf
documentos/docjuntada3.pdf
```

O número do arquivo deve corresponder ao número informado no arquivo de dados da juntada.

### `figs/`

Contém o brasão usado no cabeçalho.

O arquivo esperado é:

```text
figs/Coat.pdf
```

### `bases/`

Contém os anexos oficiais usados como referência textual. Esta pasta serve como lastro normativo para comparação e manutenção dos modelos.

---

## Requisitos

### Obrigatórios

- TeX Live 2025 ou superior, preferencialmente TeX Live 2026;
- LuaLaTeX;
- fonte Times New Roman instalada, especialmente no Windows.

### Recomendados

- Windows 11 com PowerShell;
- VS Code ou TeXstudio;
- Git;
- GitHub CLI (`gh`), se for publicar no GitHub pela linha de comando.

---

## Como compilar

Na raiz do projeto, execute:

```powershell
lualatex .\main.tex
lualatex .\main.tex
```

Duas compilações são recomendadas porque o `hyperref` pode precisar atualizar bookmarks e referências internas. Sim, o LaTeX pede confirmação duas vezes como se fosse repartição pública.

O PDF será gerado como:

```text
main.pdf
```

---

## Como usar em uma sindicância real

### 1. Edite os dados gerais

Abra:

```text
dados/dados-sindicancia.tex
```

Preencha:

```latex
\dia{31}
\mes{maio}
\ano{2026}
\cidade{Petrolina/PE}

\om{72º Batalhão de Infantaria de Caatinga}
\nup{64108.000000/2026-00}

\portaria{Portaria nº 000 -- Seç Ap Ass Jurd/72º BI Caat, de 00 de mês de 2026, do Comandante do 72º Batalhão de Infantaria de Caatinga}

\objeto{apurar os fatos constantes da portaria instauradora e seus anexos}

\sindicanteNome{NOME DO SINDICANTE}
\sindicantePosto{POSTO/GRADUAÇÃO}

\sindicadoNome{NOME DO SINDICADO}
\sindicadoPosto{POSTO/GRADUAÇÃO}
```

### 2. Edite os dados de cada anexo

Cada documento tem seu próprio arquivo em `dados/`.

Exemplo para uma inquirição de sindicado:

```text
dados/dados-anexo-q-inquiricao-sindicado1.tex
```

Exemplo para testemunha:

```text
dados/dados-anexo-p-inquiricao-testemunha1.tex
```

Exemplo para juntada:

```text
dados/dados-anexo-e-l-juntada1.tex
```

### 3. Ative ou desative os documentos no `main.tex`

Cada documento costuma aparecer como um bloco:

```latex
\input{dados/dados-anexo-q-inquiricao-sindicado1.tex}
\GerarDocumento{termo-inquiricao-sindicado}
```

Para remover o documento da compilação, comente as duas linhas:

```latex
% \input{dados/dados-anexo-q-inquiricao-sindicado1.tex}
% \GerarDocumento{termo-inquiricao-sindicado}
```

### 4. Coloque os PDFs de juntada em `documentos/`

Se a juntada estiver configurada como:

```latex
\juntadaNumero{1}
```

o arquivo esperado será:

```text
documentos/docjuntada1.pdf
```

Para uma segunda juntada:

```latex
\juntadaNumero{2}
```

o arquivo esperado será:

```text
documentos/docjuntada2.pdf
```

### 5. Compile

```powershell
lualatex .\main.tex
lualatex .\main.tex
```

---

## Mapa de anexos implementados

| Anexo | Documento | Modelo | Dados |
|---|---|---|---|
| C | Capa dos autos | `modelos/capa.tex` | `dados/dados-anexo-c-capa.tex` |
| D | Termo de abertura | `modelos/termo-abertura.tex` | `dados/dados-anexo-d-termo-abertura.tex` |
| E/L | Juntada | `modelos/juntada.tex` | `dados/dados-anexo-e-l-juntada1.tex` |
| F | Designação de escrivão | `modelos/designacao-escrivao.tex` | `dados/dados-anexo-f-designacao-escrivao.tex` |
| G | Compromisso de escrivão | `modelos/compromisso-escrivao.tex` | `dados/dados-anexo-g-compromisso-escrivao.tex` |
| H | Despacho | `modelos/despacho.tex` | `dados/dados-anexo-h-despacho1.tex` |
| I | Notificação prévia | `modelos/notificacao-previa.tex` | `dados/dados-anexo-i-notificacao-previa1.tex` |
| J | Notificação de novo sindicado | `modelos/notificacao-novo-sindicado.tex` | `dados/dados-anexo-j-notificacao-novo-sindicado.tex` |
| K | Notificação de diligências complementares | `modelos/notificacao-diligencias-complementares.tex` | `dados/dados-anexo-k-notificacao-diligencias-complementares.tex` |
| M | Comparecimento de sindicado | `modelos/comparecimento-sindicado.tex` | `dados/dados-anexo-m-comparecimento-sindicado.tex` |
| N | Comparecimento de testemunha | `modelos/comparecimento-testemunha.tex` | `dados/dados-anexo-n-comparecimento-testemunha.tex` |
| O | Carta precatória | `modelos/carta-precatoria.tex` | `dados/dados-anexo-o-carta-precatoria1.tex` |
| P | Termo de inquirição de testemunha | `modelos/termo-inquiricao-testemunha.tex` | `dados/dados-anexo-p-inquiricao-testemunha1.tex` |
| Q | Termo de inquirição de sindicado | `modelos/termo-inquiricao-sindicado.tex` | `dados/dados-anexo-q-inquiricao-sindicado1.tex` |
| R | Substituição de sindicante | `modelos/substituicao-sindicante.tex` | `dados/dados-anexo-r-substituicao-sindicante.tex` |
| S | Termo de acareação | `modelos/acareacao.tex` | `dados/dados-anexo-s-acareacao.tex` |
| T | Termo de encerramento de instrução | `modelos/termo-encerramento-instrucao.tex` | `dados/dados-anexo-t-encerramento-instrucao.tex` |
| U | Vista para alegações finais | `modelos/vista-alegacoes-finais.tex` | `dados/dados-anexo-u-vista-alegacoes-finais.tex` |
| V | Certidão | `modelos/certidao.tex` | `dados/dados-anexo-v-certidao.tex` |
| W | Relatório | `modelos/relatorio.tex` | `dados/dados-anexo-w-relatorio.tex` |
| X | Termo de encerramento | `modelos/termo-encerramento.tex` | `dados/dados-anexo-x-termo-encerramento.tex` |
| Y | DIEx de remessa | `modelos/diex-remessa.tex` | `dados/dados-anexo-y-diex-remessa.tex` |

Anexos fora do escopo atual:

```text
A, B, Z, AA
```

---

## Modelos auxiliares

Além dos modelos por anexo, existem dois modelos auxiliares:

| Documento | Modelo |
|---|---|
| DIEx genérico | `modelos/diex.tex` |
| Ofício genérico | `modelos/oficio.tex` |

Use estes apenas quando não houver anexo específico aplicável.

Se houver anexo oficial específico, use o modelo do anexo. O EB não premia improviso documental, infelizmente para a criatividade e felizmente para a sindicância.

---

## Macros úteis

### Perguntas e respostas

Nos termos de inquirição, use:

```latex
\PergResp{tinha conhecimento dos fatos}{sim, tomou conhecimento após ser notificado}
```

ou, para perguntas abertas:

```latex
\PergRespAberta{como os fatos ocorreram}{relatou que...}
```

Essas macros geram texto corrido no estilo de ata.

### Juntada

No arquivo de dados da juntada:

```latex
\juntadaNumero{1}

\juntadaItens{%
    \item Portaria nº ...
    \item DIEx nº ...
}
```

O PDF anexado será:

```text
documentos/docjuntada1.pdf
```

---

## Fluxo recomendado de uso

Uma sindicância ordinária simples costuma seguir esta sequência:

1. Anexo C: capa;
2. Anexo D: termo de abertura;
3. Anexo E/L: juntada da portaria e documentos iniciais;
4. Anexo I: notificação prévia;
5. Anexo H: despacho;
6. Anexo M/N/O, conforme necessário;
7. Anexo Q: inquirição do sindicado;
8. Anexo P: inquirição de testemunhas;
9. novas juntadas, se necessário;
10. Anexo T: termo de encerramento de instrução;
11. Anexo U: vista para alegações finais;
12. Anexo V: certidão, se não houver manifestação;
13. Anexo W: relatório;
14. Anexo X: termo de encerramento;
15. Anexo Y: DIEx de remessa.

Documentos eventuais:

- Anexo F/G: escrivão;
- Anexo J: envolvido que passa a sindicado;
- Anexo K: diligências complementares;
- Anexo R: substituição de sindicante;
- Anexo S: acareação.

---

## Cuidados com dados reais

Não suba autos reais, documentos pessoais, laudos, CPF, identidade, telefone, endereço ou PDFs de sindicância real para repositório público.

Para uso no GitHub, recomenda-se manter apenas:

- modelos;
- dados fictícios;
- documentos de exemplo sem dados reais;
- bases normativas públicas.

Se for trabalhar com uma sindicância real, use uma cópia local fora do repositório público.

---

## Arquivos que não devem ir para o GitHub

O projeto deve ignorar arquivos auxiliares de compilação, como:

```text
*.aux
*.log
*.out
*.toc
*.synctex.gz
*.fls
*.fdb_latexmk
main.pdf
```

Também é recomendável não versionar PDFs reais dentro de `documentos/`.

---

## Solução de problemas

### `LaTeX Error: File 'dados/dados-sindicancia.tex' not found`

O arquivo de dados gerais não existe. Crie ou restaure:

```text
dados/dados-sindicancia.tex
```

### `LaTeX Error: File 'documentos/docjuntada1.pdf' not found`

A juntada está ativa, mas o PDF correspondente não existe. Coloque o arquivo em:

```text
documentos/docjuntada1.pdf
```

ou comente o bloco da juntada no `main.tex`.

### Aviso `Rerun to get outlines right`

Compile novamente:

```powershell
lualatex .\main.tex
```

### A fonte Times New Roman não aparece

No Windows, use LuaLaTeX com a fonte Times New Roman instalada. Em Linux, a classe usa Liberation Serif como fallback.

### O PDF compilou, mas há avisos `Underfull \hbox`

Normalmente são avisos de espaçamento. Se o documento estiver visualmente aceitável, não impedem o uso.

---

## Comandos Git sugeridos

Para criar o primeiro commit local:

```powershell
git init
git add .
git commit -m "Versão inicial dos modelos de sindicância EB em LaTeX"
```

Para conectar a um repositório remoto já criado:

```powershell
git remote add origin https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git
git branch -M main
git push -u origin main
```

Se usar GitHub CLI:

```powershell
gh repo create sindicancia-eb --private --source . --remote origin --push
```

Use `--private` se houver qualquer risco de dados sensíveis. A internet não precisa de uma sindicância real para se entreter.

---

## Próximas etapas planejadas

1. Testar uma sindicância fake completa;
2. Separar `main.tex` de demonstração e `main-template.tex` para uso real;
3. Criar scripts de apoio para limpeza e compilação;
4. Criar camada futura em Python para preencher dados;
5. Criar interface gráfica simples usando o LaTeX como motor de geração de PDFs.

---

## Observação

Este projeto é uma ferramenta de apoio à elaboração documental. A conformidade final dos autos deve ser sempre conferida pelo sindicante e, quando necessário, pela assessoria jurídica competente.
