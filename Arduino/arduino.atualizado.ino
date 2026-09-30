const int PINO_SENSOR_LDR = A4; // Pino analógico conectado
const float RESISTOR_FIXO = 10000.0;
const float FATOR_FONTE = 54.0; // Utilizado para calcular o PPFD
const float LUX_REFERENCIA = 30000.0;
const float RESISTENCIA_REFERENCIA = 4614.29;
const float DLI_ALVO = 30.0;
const float HORAS_SOL = 12.0;
int dia = 0;

void setup() {
	Serial.begin(9600);
}

void loop() {
	dia++;

	// Lê valor do ADC
	int valorLuminosidade = analogRead(PINO_SENSOR_LDR);

	// Calcula a leitura do ADC para Tensão
	float vSaida = valorLuminosidade * (5.0 / 1023.0);
	
	// Calcula resistencia do LDR
	float rLdr;

	// Evita divisão po 0
	if (vSaida > 0) {
		// Calcula resistencia do LDR
		rLdr = RESISTOR_FIXO * (5.0 - vSaida) / vSaida;
	} else {
		rLdr = 10000000.0; // Se valorLuminosidade = 0, resistência muito alta / nenhuma luz
	}

	// Calibração 4614 rLdr = 30.000 lux
	// Converte resistencia do LDR para lux
	float lux;

	if (rLdr > 0) {
		lux = LUX_REFERENCIA * (RESISTENCIA_REFERENCIA / rLdr);
	} else {
		lux = 0;
	};

	// Converte lux para PPFD
	float ppfd = lux / FATOR_FONTE;

	// Simula 12h de sol diária
	float segundosSol = HORAS_SOL * 3600.0;

	// Calcula DLI do Dia
	float dliDia = (ppfd * segundosSol) / 1000000.0;

	// Calcula quanto falta para atingir o DLI alvo
	float diferencaDLI = DLI_ALVO - dliDia;

	if (diferencaDLI < 0) {
		diferencaDLI *= -1;
	}

	// Exibe o resultado de um dia em forma de relatório
	// Serial.println("------------------------");
	// Serial.print("DIA: ");
	// Serial.println(dia);

	// Serial.print("ADC: ");
	// Serial.println(valorLuminosidade);

	// Serial.print("Tensao de saida: ");
	// Serial.print(vSaida);
	// Serial.println(" V");

	// Serial.print("Resistencia LDR: ");
	// Serial.print(rLdr);
	// Serial.println("ohms");

	// Serial.print("Luminosidade: ");
	// Serial.print(lux);
	// Serial.println(" lux");

	// Serial.print("PPFD: ");
	// Serial.print(ppfd);
	// Serial.println(" umol/m2/s");
	// Serial.println();

	// Serial.print("Tempo simulado: ");
  	// Serial.print(HORAS_SOL);
  	// Serial.println(" horas");

  	// Serial.print("DLI do dia: ");
 	// Serial.print(dliDia, 4);
  	// Serial.println(" mol/m2/dia");

  	// Serial.print("DLI alvo: ");
  	// Serial.print(DLI_ALVO);
  	// Serial.println(" mol/m2/dia");

	// if (dliDia > DLI_ALVO) {
	// 	Serial.print("DLI excedido: ");
	// 	Serial.print(diferencaDLI);
  	// 	Serial.println(" mol/m2/dia");
	// } else {
  	// 	Serial.print("DLI faltante: ");
  	// 	Serial.print(diferencaDLI);
  	// 	Serial.println(" mol/m2/dia");
	// }

	// if (dliDia >= DLI_ALVO) {
    // Serial.println();
    // Serial.println("STATUS: DLI ALVO ATINGIDO!");
 	// } else {
    // Serial.println();
    // Serial.println("STATUS: DLI INSUFICIENTE.");
  	// }
	
	// Exibi o gráfico de ocilação diária do DLI
  	Serial.print(dliDia);
		Serial.print ("\n");
  	//Serial.println(22);

	delay(200);
}