const LIMITES = {
  abaixo: 162,
  elevado: 185,
};

const MIN_EIXO = 50;
const MAX_EIXO = 250;
const PASSO_EIXO = 50;

const LEITURAS = [
  { hora: '01:00', valor: 170 },
  { hora: '02:00', valor: 175 },
  { hora: '03:00', valor: 180 },
  { hora: '04:00', valor: 172 },
  { hora: '05:00', valor: 160 },
  { hora: '06:00', valor: 156 },
  { hora: '07:00', valor: 170 },
  { hora: '08:00', valor: 181 },
  { hora: '09:00', valor: 190 },
  { hora: '10:00', valor: 176 },
  { hora: '11:00', valor: 170 },
  { hora: '12:00', valor: 165 },
  { hora: '13:00', valor: 168 },
  { hora: '14:00', valor: 172 },
  { hora: '15:00', valor: 178 },
  { hora: '16:00', valor: 182 },
  { hora: '17:00', valor: 180 },
  { hora: '18:00', valor: 174 },
  { hora: '19:00', valor: 168 },
  { hora: '20:00', valor: 173 },
  { hora: '21:00', valor: 180 },
  { hora: '22:00', valor: 185 },
  { hora: '23:00', valor: 169 },
  { hora: '00:00', valor: 165.2 },
];

function posicaoX(indice) {
  return (indice / (LEITURAS.length - 1)) * 100;
}

function posicaoY(valor) {
  return ((valor - MIN_EIXO) / (MAX_EIXO - MIN_EIXO)) * 100;
}

function formatarLeitura(valor) {
  if (Number.isInteger(valor)) {
    return `${valor}`;
  }

  return `${valor}`.replace('.', ',');
}

function classificar(valor) {
  if (valor < LIMITES.abaixo) {
    return 'abaixo';
  }

  if (valor > LIMITES.elevado) {
    return 'elevado';
  }

  return 'adequado';
}

function renderKpiLeitura() {
  const ultima = LEITURAS[LEITURAS.length - 1];
  document.getElementById('kpiLeituraAtual').textContent = formatarLeitura(ultima.valor);
}

function renderEixoY() {
  const eixoY = document.getElementById('eixoY');
  const fragment = document.createDocumentFragment();

  for (let valor = MIN_EIXO; valor <= MAX_EIXO; valor += PASSO_EIXO) {
    const tick = document.createElement('span');
    tick.className = 'grafico__tick-y';
    tick.style.setProperty('--posicao', `${posicaoY(valor)}`);
    tick.textContent = valor;
    fragment.appendChild(tick);
  }

  eixoY.appendChild(fragment);
}

function renderGradeHorizontal() {
  const grade = document.getElementById('grade');
  const fragment = document.createDocumentFragment();

  for (let valor = MIN_EIXO; valor <= MAX_EIXO; valor += PASSO_EIXO) {
    const linha = document.createElement('span');
    linha.className = valor === MIN_EIXO ? 'grafico__linha grafico__linha--base' : 'grafico__linha';
    linha.style.setProperty('--posicao', `${posicaoY(valor)}`);
    fragment.appendChild(linha);
  }

  grade.appendChild(fragment);
}

function renderGradeVertical() {
  const grade = document.getElementById('grade');
  const fragment = document.createDocumentFragment();

  LEITURAS.forEach((leitura, indice) => {
    const coluna = document.createElement('span');
    coluna.className = 'grafico__coluna';
    coluna.style.setProperty('--posicao', `${posicaoX(indice)}`);
    fragment.appendChild(coluna);
  });

  grade.appendChild(fragment);
}

function renderTrilha() {
  const pontos = LEITURAS.map(
    (leitura, indice) => `${posicaoX(indice)},${100 - posicaoY(leitura.valor)}`
  ).join(' ');

  document.getElementById('trilha').setAttribute('points', pontos);

  const acima = 100 - posicaoY(LIMITES.elevado);
  const abaixo = 100 - posicaoY(LIMITES.abaixo);

  document.getElementById('limiteElevado').setAttribute('y1', `${acima}`);
  document.getElementById('limiteElevado').setAttribute('y2', `${acima}`);
  document.getElementById('limiteAbaixo').setAttribute('y1', `${abaixo}`);
  document.getElementById('limiteAbaixo').setAttribute('y2', `${abaixo}`);
}

function criarPonto(indice, valor, variante) {
  const ponto = document.createElement('span');
  ponto.className = `grafico__ponto grafico__ponto--${variante}`;
  ponto.style.setProperty('--x', `${posicaoX(indice)}%`);
  ponto.style.setProperty('--y', `${posicaoY(valor)}%`);
  return ponto;
}

function renderPontos() {
  const container = document.getElementById('pontos');
  const fragment = document.createDocumentFragment();

  LEITURAS.forEach((leitura, indice) => {
    fragment.appendChild(criarPonto(indice, leitura.valor, 'dados'));
    fragment.appendChild(criarPonto(indice, LIMITES.elevado, 'elevado'));
    fragment.appendChild(criarPonto(indice, LIMITES.abaixo, 'abaixo'));
  });

  container.appendChild(fragment);
}

function renderEixoX() {
  const eixoX = document.getElementById('eixoX');
  const fragment = document.createDocumentFragment();

  LEITURAS.forEach((leitura, indice) => {
    const tick = document.createElement('span');
    tick.className = 'grafico__tick';
    tick.style.setProperty('--posicao', `${posicaoX(indice)}`);

    const rotulo = document.createElement('span');
    rotulo.className = 'grafico__tick-x';
    rotulo.textContent = leitura.hora;

    tick.appendChild(rotulo);
    fragment.appendChild(tick);
  });

  eixoX.appendChild(fragment);
}

function initMenuEstufas() {
  const seletor = document.querySelector('.estufa-seletor');

  if (!seletor) {
    return;
  }

  const botao = seletor.querySelector('.estufa');
  const menu = seletor.querySelector('.estufa-menu');

  function alternarMenu(abrir) {
    menu.hidden = !abrir;
    botao.setAttribute('aria-expanded', `${abrir}`);
  }

  botao.addEventListener('click', () => {
    alternarMenu(menu.hidden);
  });

  document.addEventListener('keydown', (evento) => {
    if (evento.key === 'Escape') {
      alternarMenu(false);
    }
  });

  document.addEventListener('click', (evento) => {
    if (!seletor.contains(evento.target)) {
      alternarMenu(false);
    }
  });
}

function init() {
  renderKpiLeitura();
  renderEixoY();
  renderGradeHorizontal();
  renderGradeVertical();
  renderTrilha();
  renderPontos();
  renderEixoX();
  initMenuEstufas();
}

init();