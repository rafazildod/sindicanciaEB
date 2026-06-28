# Conformidade com a EB10-IG-09.001

Este documento descreve como o projeto representa as situações identificadas na Portaria C Ex nº 2.394/2024 e nas EB10-IG-09.001 (2ª edição, 2024). Ele é um mapa técnico de aplicabilidade, não um parecer jurídico.

## Regime atendido

A versão atual aceita portarias publicadas a partir de 1º de janeiro de 2025. A classe rejeita datas anteriores para impedir o uso involuntário do novo conjunto de regras em procedimentos submetidos ao regime precedente.

## Estado formal da sindicância

O estado possui seis dimensões:

| Dimensão | Valores ou registro |
|---|---|
| Rito | `sumario` ou `ordinario` |
| Natureza | `investigatoria` ou `processual` |
| Parte principal | `nenhuma`, `interessado` ou `sindicado` |
| Classificação | `ostensiva` ou `sigilosa` |
| Regime temporal | publicação e recebimento da portaria |
| Histórico | data, tipo, estado anterior, estado novo e fundamento |

Uma apuração pode começar sem sindicado. Nessa fase, use natureza investigatória e parte principal `nenhuma` ou `interessado`. Os documentos de contraditório ficam bloqueados.

Se surgirem elementos de responsabilidade individual, preencha o sindicado e execute `\converterParaProcessual{data}{fundamento}`. A transição fica registrada e libera as peças processuais.

No rito sumário, a mudança para o ordinário pode ser registrada tecnicamente com `\converterRitoParaOrdinario{data}{fundamento}`. O Anexo AA correspondente é de competência da Seção de Apoio Jurídico e permanece no projeto apenas como referência.

## Aplicabilidade das peças

| Grupo | Condição principal |
|---|---|
| Anexos A, B, Z e AA | Referência da Seção de Apoio Jurídico; não são elaborados pelo sindicante |
| Capa, abertura, juntada, despacho, testemunhas, acareação, relatório, encerramento e remessa | Podem ser usados sem sindicado, conforme os fatos e o rito |
| Notificações I, J e K | Natureza processual e sindicado identificado |
| Comparecimento e inquirição de sindicado | Natureza processual e sindicado identificado |
| Vista para alegações finais | Natureza processual e sindicado identificado |
| Consentimento médico do sindicado | Natureza processual e titular identificado; conferir a base legal concreta |
| Anexo B | Somente quando a instauração decorrer de denúncia anônima nas condições normativas |
| Anexo AA | Somente após mudança registrada do rito sumário para o ordinário |
| Relatório complementar | Somente quando houver determinação de diligências complementares |

## Foliação

A caixa `Fl. ____` é sempre manual. Ela não aparece na capa, inicia no termo de abertura e deixa de aparecer a partir do DIEx de remessa. Os anexos de competência da Seção de Apoio Jurídico também ficam fora dessa numeração do sindicante.

## Regras automatizadas

O projeto verifica:

- data específica e chave cronológica de cada ato;
- compatibilidade do documento com o estado processual;
- fundamento e autoridade da classificação sigilosa;
- limite declarado de testemunhas por parte;
- modalidade presencial, videoconferência, telepresencial ou carta precatória;
- referência à regulamentação do ato remoto;
- horário, duração, pausa ou continuação da inquirição;
- responsável legal de sindicado menor;
- duas testemunhas para assinatura a rogo;
- fatos específicos, forma de ciência e antecedência declarada das notificações;
- finalidade e prioridade dos expedientes;
- quesitos da defesa e notificação na carta precatória processual;
- antecedência mínima declarada de 48 horas para prorrogação;
- total real de folhas informado na remessa, sem numeração automática pelo LaTeX;
- publicação, notificados e prazo recursal na solução.

## Controles que dependem de conferência humana

O LaTeX não consegue confirmar sozinho:

- veracidade, suficiência e pertinência das provas;
- dias de expediente, feriados e suspensões de prazo;
- entrega real, identidade de quem recebeu e validade da ciência;
- fundamento jurídico concreto do sigilo ou do tratamento de dados;
- vigência e redação atual de normas externas;
- competência da autoridade e regularidade material da decisão;
- correspondência entre o número de folhas informado e os autos físicos ou digitais.

## Participantes, recursos e normas externas

Registre pessoas com `\registrarParticipante{id}{papel}{nome}{qualificacao}{vinculo}{observacoes}`. O identificador permite que um futuro formulário reutilize a mesma pessoa em diferentes atos sem confundir seu papel processual.

Recursos efetivamente interpostos podem ser anotados com `\registrarRecurso{tipo}{data}{recorrente}{situacao}`. Não registre recurso apenas porque ele é cabível; o cadastro representa ocorrências reais.

Prazos concretos são cadastrados com `\registrarPrazo{ato}{inicio}{vencimento}{criterio}{situacao}`. O registro não calcula feriados nem substitui a conferência dos marcos.

Use `\registrarDependenciaNormativa{norma}{tema}{observacao}` para manter explícitas as regras externas incidentes. O arquivo geral traz lembretes sobre processo penal militar, acesso à informação, proteção de dados e atos remotos. Substitua descrições genéricas pela identificação exata do ato vigente no caso concreto.

## Flexibilidade dos modelos

Os modos `padrao`, `adaptado` e `personalizado` alteram o corpo do documento pelo arquivo de dados. Eles evitam cópias divergentes em `modelos/`, mas não dispensam a conferência de que o texto adaptado preserva os elementos obrigatórios do ato.

## Evidência de teste

A matriz em `tests/` compila cenários positivos com e sem sindicado, conversões, ambos os ritos, sigilo, modalidades especiais de inquirição e flexibilidade textual. Testes negativos devem falhar quando uma regra objetiva é violada. O fluxo de integração contínua executa essa matriz a cada alteração publicada.
