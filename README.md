# 🍅 Tomatix

Sistema de **monitoramento de luminosidade em estufas agrícolas de tomate-cereja**.

O projeto utiliza sensores para coletar dados de luminosidade e disponibiliza essas informações em uma **dashboard web**, permitindo acompanhar o ambiente de cultivo e apoiar decisões baseadas em dados.

## 🎯 Objetivo

Monitorar, armazenar e apresentar dados de luminosidade ao longo do tempo, identificando períodos de baixa ou alta luminosidade e comparando as medições com referências adequadas ao cultivo.

## 🔄 Fluxo

```text
Estufa
   ↓
Sensor de luminosidade
   ↓
Arduino
   ↓
Backend / API
   ↓
Banco de dados
   ↓
Dashboard
   ↓
Informações para o produtor
```