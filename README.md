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
├── bases/
│   ├── anexo_c_capa.docx
│   ├── ...
│   └── anexo_y_diex_remessa.docx
├── dados/
│   ├── dados-sindicancia.tex
│   ├── dados-anexo-c-capa.tex
│   ├── ...
│   ├── dados-anexo-y-diex-remessa.tex
│   ├── dados-diex1.tex
│   ├── dados-oficio1.tex
│   └── dados-solicitacao-prorrogacao.tex
├── documentos/
│   └── docjuntada1.pdf
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

## Regra importante para arquivos de dados

Use os comandos públicos da classe. Não redefina getters.

Correto:

```latex
\certidaoLocalData{Petrolina/PE, 03 de junho de 2026}
\certidaoTexto{Texto da certidão...}
```

Evite:

```latex
\newcommand{\getCertidaoLocalData}{Petrolina/PE, 03 de junho de 2026}
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

---

## Juntadas

O modelo de juntada usa este padrão:

```latex
\juntadaNumero{1}
```

e procura automaticamente:

```text
documentos/docjuntada1.pdf
```

Para uma segunda juntada, use `\juntadaNumero{2}` e coloque o arquivo correspondente em:

```text
documentos/docjuntada2.pdf
```

No `main.tex`, o segundo exemplo permanece comentado porque o PDF `docjuntada2.pdf` não existe no repositório.

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
- remova PDFs reais de `documentos/` antes de publicar;
- não versione PDFs finais reais, `.aux`, `.log`, `.out` ou outros arquivos gerados;
- revise todos os PDFs antes da impressão ou assinatura.

---

## Notas de manutenção

- `.gitattributes` normaliza arquivos de texto com LF para evitar diffs falsos por CRLF/LF.
- `sindicancia.cls` removeu dependências desnecessárias e não usa mais TikZ para desenhar a caixa `Fl. ____`.
- `hyperref` é carregado depois dos pacotes de layout.
- A validação de certidão agora usa `\certidaoTexto{...}` e `\certidaoCiencia{...}` em vez de redefinir getters.
