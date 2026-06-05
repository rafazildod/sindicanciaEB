# Sindicância EB em LaTeX

Modelos em LaTeX para elaboração de documentos de sindicância no âmbito do Exército Brasileiro, estruturados a partir dos anexos oficiais da **EB10-IG-09.001**.

O projeto usa LaTeX como motor de formatação para gerar PDFs padronizados. Os dados ficam em arquivos separados, os modelos ficam em `modelos/`, e a classe central `sindicancia.cls` concentra a configuração visual e a API de preenchimento.

---

## Situação atual do projeto

O projeto contém modelos para os anexos **C a Y**, exceto os anexos **A, B, Z e AA**, que estão fora do escopo atual.

Também há modelos auxiliares para:

- DIEx genérico;
- Ofício genérico;
- termo de consentimento para acesso a prontuário;
- solicitação de prorrogação de prazo.

O `main.tex` é o arquivo de uso real: por padrão, todos os documentos específicos ficam comentados. Para validar a compilação de todos os modelos implementados, use `tests/all-models.tex`.

---

## Estrutura de pastas

```text
sindicanciaEB/
├── main.tex
├── sindicancia.cls
├── .gitattributes
├── .gitignore
├── bases/
│   ├── anexo_c_capa.docx
│   ├── ...
│   ├── anexo_y_diex_remessa.docx
│   └── port_2394-c_ex_ig_elb_sind_eb10-ig-09.001.pdf
├── dados/
│   ├── dados-sindicancia.tex
│   ├── controle-expedientes.tex
│   ├── dados-anexo-c-capa.tex
│   ├── ...
│   ├── dados-anexo-y-diex-remessa.tex
│   ├── dados-diex1.tex
│   ├── dados-oficio1.tex
│   └── dados-solicitacao-prorrogacao.tex
├── documentos/
│   └── docjuntada1.pdf   # PDF fictício de exemplo
├── figs/
│   └── Coat.pdf
├── modelos/
│   ├── capa.tex
│   ├── ...
│   ├── diex-remessa.tex
│   └── solicitacao-prorrogacao.tex
└── tests/
    └── all-models.tex
```

---

## Requisitos

- LuaLaTeX ou XeLaTeX;
- TeX Live recente;
- fonte Times New Roman instalada, quando disponível.

A classe usa `fontspec`, portanto **não compile com pdfLaTeX**. Se Times New Roman não estiver instalada, a classe tenta usar Liberation Serif.

---

## Como usar em uma sindicância real

### 1. Edite os dados gerais

Abra:

```text
dados/dados-sindicancia.tex
```

Preencha os dados comuns da sindicância, como data, cidade, OM, NUP, portaria, objeto, autoridade instauradora, sindicante, sindicado e escrivão.

### 2. Edite o arquivo de dados do documento desejado

Cada peça tem um arquivo em `dados/`. Exemplos:

```text
dados/dados-anexo-q-inquiricao-sindicado1.tex
dados/dados-anexo-p-inquiricao-testemunha1.tex
dados/dados-anexo-e-l-juntada1.tex
dados/dados-solicitacao-prorrogacao.tex
```

### 3. Ative o documento no `main.tex`

Cada bloco segue este padrão:

```latex
\input{dados/dados-anexo-q-inquiricao-sindicado1.tex}
\GerarDocumento{termo-inquiricao-sindicado}
```

Descomente sempre o par inteiro: o arquivo de dados e o modelo.

### 4. Compile

Na raiz do projeto:

```powershell
lualatex .\main.tex
lualatex .\main.tex
```

Ou, em shells Unix-like:

```bash
lualatex main.tex
lualatex main.tex
```

O PDF será gerado como `main.pdf`.

---

## Como validar todos os modelos

O arquivo `main.tex` pode gerar zero páginas se todos os blocos estiverem comentados. Para teste de regressão, compile:

```bash
latexmk -lualatex -halt-on-error -interaction=nonstopmode -outdir=build tests/all-models.tex
```

Esse teste carrega todos os modelos implementados com os dados de exemplo do repositório.

---

## Base normativa e prazos

A pasta `bases/` contém os modelos oficiais em DOCX e também a portaria das Instruções Gerais:

```text
bases/port_2394-c_ex_ig_elb_sind_eb10-ig-09.001.pdf
```

Pelo texto da EB10-IG-09.001, a autoridade instauradora fixa o prazo inicial de **trinta dias corridos** para conclusão da sindicância, com possibilidade de prorrogação por **vinte dias**, mediante solicitação fundamentada do sindicante e a critério da autoridade nomeante. A própria norma também prevê que, na contagem dos prazos, exclui-se o dia do início e inclui-se o do vencimento, e que os prazos se iniciam e vencem em dia de expediente na OM.

Por isso, no projeto, a data geral de `dados/dados-sindicancia.tex` deve representar a **data efetiva de abertura/início dos trabalhos**, normalmente ligada ao recebimento da portaria pelo sindicante e à lavratura do termo de abertura. A data da portaria continua existindo como dado documental, mas não deve ser usada como fallback automático para a data das peças.

Para o controle de prazo em caso real, confira sempre:

- a data de recebimento/ciência da portaria pelo sindicante;
- o primeiro dia de expediente aplicável na OM;
- a data do termo de abertura;
- eventuais publicações em BI relativas a prorrogação;
- o calendário de expediente da OM.

O projeto auxilia na padronização documental, mas não substitui a conferência jurídica/administrativa da contagem de prazo.

---

## Versionamento do projeto

O repositório já inclui:

```text
.gitattributes
.gitignore
```

`.gitattributes` normaliza arquivos de texto com LF, reduzindo diffs falsos por diferença de final de linha. `.gitignore` evita versionar arquivos temporários de LaTeX, PDFs finais gerados e PDFs reais em `documentos/`.

Fluxo recomendado:

```bash
git status
latexmk -lualatex -halt-on-error -interaction=nonstopmode -outdir=build tests/all-models.tex
git add README.md main.tex sindicancia.cls dados modelos documentos tests .gitattributes .gitignore
git commit -m "Atualiza modelos de sindicancia"
git push
```

Para registrar somente novos expedientes emitidos:

```bash
git add dados/controle-expedientes.tex
git commit -m "Registra expedientes emitidos"
```

Não versionar em repositório público:

```text
main.pdf
build/
*.aux
*.log
documentos/*.pdf reais
PDFs finais assinados
dados reais de sindicância
```

---


## Datas dos documentos

A data/local informada em `dados/dados-sindicancia.tex` é a **data de abertura dos trabalhos**, isto é, a data usada como marco prático do início da sindicância. Ela não precisa ser igual à data da portaria. Essa escolha segue a lógica da seção “Base normativa e prazos”: a data da portaria é apenas documental; o marco prático do trabalho é o recebimento/abertura.

No arquivo geral, preencha:

```latex
\dia{00}
\mes{mês}
\ano{2026}
\cidade{CIDADE/UF}
```

Também existem aliases equivalentes, caso você prefira deixar explícito que se trata da abertura:

```latex
\aberturaDia{00}
\aberturaMes{mês}
\aberturaAno{2026}
\aberturaCidade{CIDADE/UF}
```

Cada arquivo específico em `dados/dados-*.tex` possui seu próprio comando de data:

```latex
\dataDocumento{}{}{}{}
```

Deixe os quatro campos em branco para herdar a data/local da abertura. Para informar uma data própria para aquela peça, preencha:

```latex
\dataDocumento{05}{junho}{2026}{CIDADE/UF}
```

Os modelos que imprimem `\localData`, `\getDia`, `\getMes`, `\getAno` ou `\getCidade` usam a data própria do documento quando ela existir. Quando ela estiver vazia, usam a data de abertura.

Nos termos em formato de ata, como inquirição e acareação, o campo textual específico continua aceitando texto livre:

```latex
\inquiricaoSindicadoDataAta{quatro dias do mês de junho do ano de dois mil e vinte e seis}
```

Se esse campo ficar vazio, o modelo monta a data por extenso a partir de `\dataDocumento`; se `\dataDocumento` também estiver vazio, usa a data de abertura.

---

## Controle manual e versionável de DIEx e Ofícios

O arquivo abaixo concentra o controle manual dos expedientes:

```text
dados/controle-expedientes.tex
```

Nele você informa os próximos números:

```latex
\proximoDiex{005}
\proximoOficio{002}
```

Em um arquivo de dados de DIEx ou Ofício, deixe o número vazio para usar o próximo número do controle:

```latex
\diexNumero{}   % usa \proximoDiex
\oficioNumero{} % usa \proximoOficio
```

Depois de emitir ou assinar o expediente, atualize manualmente o histórico e avance o próximo número:

```latex
\registroDiex{005}{05 de junho de 2026}{assunto do DIEx expedido}
\proximoDiex{006}

\registroOficio{002}{06 de junho de 2026}{assunto do Ofício expedido}
\proximoOficio{003}
```

O LaTeX **não grava nem incrementa esse controle automaticamente**. Isso é intencional: recompilar um PDF nunca deve consumir número de DIEx ou Ofício. O arquivo funciona como uma base manual, rastreável e versionável no Git.

Sugestão de uso no Git:

```bash
git add dados/controle-expedientes.tex
git commit -m "Registra expedientes emitidos"
```

Para sindicâncias reais, use repositório privado. Em repositório público, substitua dados reais por placeholders antes de publicar.

---

## DIEx final de remessa

O DIEx final de remessa não recebe a caixa `Fl. ____`, seguindo a mesma regra da capa.

O assunto desse documento fica propositalmente assim:

```text
sindicância com ______ folhas
```

A quantidade de folhas deve ser preenchida manualmente no fechamento dos autos, pois o projeto não tenta controlar a paginação final efetiva da sindicância. Isso evita divergência entre o PDF de teste e os autos efetivamente montados, assinados, juntados ou impressos.

---

## Regra importante para arquivos de dados

Use os comandos públicos da classe. Não redefina getters.

Correto:

```latex
\certidaoDataTerminoPrazo{DIA DO TÉRMINO DO PRAZO}
\certidaoTipoDocumento{DIEx}
\certidaoNumeroDocumento{000}
\certidaoDataDocumento{00 de mês de 2026}
\certidaoLocalData{CIDADE/UF, 00 de mês de 2026}
```

Evite:

```latex
\newcommand{\getCertidaoLocalData}{CIDADE/UF, 00 de mês de 2026}
```

O padrão da classe é:

```latex
\campo{valor}      % setter usado nos dados
\getCampo          % getter usado internamente pelos modelos
```

Para documentos que podem se repetir, os arquivos de dados usam um reset explícito no início:

```latex
\novoDiex
\diexNumero{001}
```

Isso evita que campos opcionais de uma peça contaminem a próxima.

## Juntadas

Os documentos juntados aos autos devem ser digitalizados/escaneados e salvos em PDF dentro da pasta:

```text
documentos/
```

A nomenclatura padrão é controlada pela classe. Ao usar:

```latex
\juntadaNumero{1}
```

o projeto procura automaticamente:

```text
documentos/docjuntada1.pdf
```

Para uma segunda juntada, use:

```latex
\juntadaNumero{2}
```

e salve o PDF correspondente como:

```text
documentos/docjuntada2.pdf
```

O padrão esperado é, portanto:

```text
documentos/docjuntada<N>.pdf
```

em que `<N>` é o número informado em `\juntadaNumero{<N>}`.

Se precisar usar outro nome de arquivo, informe explicitamente:

```latex
\juntadaArquivo{documentos/nome-do-arquivo.pdf}
```

Recomendações práticas:

- escaneie cada conjunto de documentos já na ordem em que será juntado;
- gere um PDF único por juntada;
- confira se o PDF está legível antes de compilar;
- não coloque documentos reais em repositório público;
- mantenha apenas PDFs fictícios de exemplo quando for publicar o projeto.

`documentos/docjuntada1.pdf` é um PDF fictício de exemplo, sem dados reais. O `.gitignore` ignora PDFs reais em `documentos/`, exceto esse exemplo fictício.


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

| Documento | Modelo | Dados |
|---|---|---|
| DIEx genérico | `modelos/diex.tex` | `dados/dados-diex1.tex` |
| Ofício genérico | `modelos/oficio.tex` | `dados/dados-oficio1.tex` |
| Termo de consentimento para acesso a prontuário | `modelos/termo-consentimento-prontuario.tex` | `dados/dados-termo-consentimento-prontuario.tex` |
| Solicitação de prorrogação de prazo | `modelos/solicitacao-prorrogacao.tex` | `dados/dados-solicitacao-prorrogacao.tex` |

Use modelos auxiliares apenas quando não houver anexo específico aplicável.

---

## Macros úteis

### Perguntas e respostas

Nos termos de inquirição:

```latex
\PergResp{tinha conhecimento dos fatos}{sim, tomou conhecimento após ser notificado}
```

ou:

```latex
\PergRespAberta{como os fatos ocorreram}{relatou que...}
```

### Assinaturas

A classe contém comandos como:

```latex
\assinaturaSindicante
\assinaturaSindicado
\assinaturaTestemunha
\assinaturaAutoridade
```

Normalmente eles já são chamados pelos modelos.

---

## Segurança e sigilo

Não suba autos reais, nomes reais, documentos médicos, documentos pessoais, depoimentos ou qualquer dado sensível em repositório público.

Para uso real:

- mantenha o repositório privado;
- use dados fictícios em exemplos públicos;
- remova PDFs reais de `documentos/` antes de publicar; mantenha apenas PDFs fictícios de exemplo, como `documentos/docjuntada1.pdf`;
- não versione PDFs finais reais, `.aux`, `.log`, `.out` ou outros arquivos gerados;
- revise todos os PDFs antes da impressão ou assinatura.

---

## Notas de manutenção

- `.gitattributes` normaliza arquivos de texto com LF para evitar diffs falsos por CRLF/LF.
- `.gitignore` evita versionar saídas de compilação, PDFs finais e PDFs reais em `documentos/`.
- `sindicancia.cls` usa TikZ para desenhar a caixa `Fl. ____`, mantendo a capa e o DIEx final de remessa sem a caixa.
- `hyperref` é carregado depois dos pacotes de layout.
- O Anexo V segue o texto do modelo `bases/anexo_v_certidao.docx` e usa campos estruturados como `\certidaoDataTerminoPrazo{...}`, `\certidaoNumeroDocumento{...}` e `\certidaoDataDocumento{...}`.
