// importa os bibliotecas necessários
const serialport = require('serialport');
const express = require('express');
const mysql = require('mysql2');

// constantes para configurações
const SERIAL_BAUD_RATE = 9600;
const SERVIDOR_PORTA = 3300;

// habilita ou desabilita a inserção de dados no banco de dados
const HABILITAR_OPERACAO_INSERIR = true;

// função para comunicação serial
const serial = async (
    valoresReproducao,
    valoresVegetativa,
    valoresMudas
) => {

    // conexão com o banco de dados MySQL
    let poolBancoDados = mysql.createPool(
        {
            host: 'localhost',
            user: 'tomatix_insert',
            password: '3021048Na*',
            database: 'tomatix',
            port: 3307
        }
    ).promise();

    // lista as portas seriais disponíveis e procura pelo Arduino
    const portaCaminho = 'COM8'

    // configura a porta serial com o baud rate especificado
    const arduino = new serialport.SerialPort(
        {
            path: portaCaminho,
            baudRate: SERIAL_BAUD_RATE
        }
    );

    // evento quando a porta serial é aberta
    arduino.on('open', () => {
        console.log(`A leitura do arduino foi iniciada na porta ${portaCaminho} utilizando Baud Rate de ${SERIAL_BAUD_RATE}`);
    });

    // processa os dados recebidos do Arduino
    arduino.pipe(new serialport.ReadlineParser({ delimiter: '\r\n' })).on('data', async (data) => {
        console.log(data);
        const valores = data.split(';');
        const sensorAnalogico = parseFloat(valores[1]);

        const valorReproducao = sensorAnalogico;
        const valorVegetativa = sensorAnalogico -200;
        const valorMudas = sensorAnalogico -400;

        // armazena os valores dos sensores nos arrays correspondentes
        valoresReproducao.push(valorReproducao);
        valoresVegetativa.push(valorVegetativa);
        valoresMudas.push(valorMudas);

        // insere os dados no banco de dados (se habilitado)
        if (HABILITAR_OPERACAO_INSERIR) {

            // este insert irá inserir os dados na tabela "medida"
            await poolBancoDados.execute(
                'INSERT INTO LEITURA_LUMINOSIDADE (ppfd,fk_sensor) VALUES (?,1)',
                [valorMudas]
            );
            await poolBancoDados.execute(
                'INSERT INTO LEITURA_LUMINOSIDADE (ppfd,fk_sensor) VALUES (?,2)',
                [valorVegetativa]
            );
            await poolBancoDados.execute(
                'INSERT INTO LEITURA_LUMINOSIDADE (ppfd,fk_sensor) VALUES (?,3)',
                [valorReproducao]
            );
            console.log("valores inseridos no banco: ", sensorAnalogico);

        }

    });

    // evento para lidar com erros na comunicação serial
    arduino.on('error', (mensagem) => {
        console.error(`Erro no arduino (Mensagem: ${mensagem}`)
    });
}

// função para criar e configurar o servidor web
const servidor = (
    valoresReproducao,
    valoresVegetativa,
    valoresMudas
) => {
    const app = express();

    // configurações de requisição e resposta
    app.use((request, response, next) => {
        response.header('Access-Control-Allow-Origin', '*');
        response.header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');
        next();
    });

    // inicia o servidor na porta especificada
    app.listen(SERVIDOR_PORTA, () => {
        console.log(`API executada com sucesso na porta ${SERVIDOR_PORTA}`);
    });

    // define os endpoints da API para cada tipo de sensor
    app.get('/sensores/reproducao', (_, response) => {
        return response.json(valoresReproducao);
    });

     app.get('/sensores/vegetativa', (_, response) => {
        return response.json(valoresVegetativa);
    });

     app.get('/sensores/mudas', (_, response) => {
        return response.json(valoresMudas);
    });
}

// função principal assíncrona para iniciar a comunicação serial e o servidor web
(async () => {
    // arrays para armazenar os valores dos sensores
    const valoresReproducao = [];
    const valoresVegetativa = [];
    const valoresMudas = [];

    // inicia a comunicação serial
    await serial(
        valoresReproducao,
        valoresVegetativa,
        valoresMudas
    );

    // inicia o servidor web
    servidor(
        valoresReproducao,
        valoresVegetativa,
        valoresMudas
    );
})();