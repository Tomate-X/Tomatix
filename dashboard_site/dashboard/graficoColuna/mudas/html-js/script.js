const LIMITES = {
  abaixo: 6,
  elevado: 8,
};

const MAX_EIXO = 12;
const PASSO_EIXO = 2;

const DIAS = [
  { data: '15/08', valor: 7.2 },
  { data: '16/08', valor: 6.8 },
  { data: '17/08', valor: 5.1 },
  { data: '19/08', valor: 7.5 },
  { data: '20/08', valor: 9.1 },
  { data: '21/08', valor: 6.5 },
  { data: '22/08', valor: 7.0 },
];

function classificar(valor) {
  if (valor < LIMITES.abaixo) {
    return 'abaixo';
  }

  if (valor > LIMITES.elevado) {
    return 'elevado';
  }

  return 'adequado';
}

function contarPorFaixa(faixa) {
  return DIAS.filter((dia) => classificar(dia.valor) === faixa).length;
}

function renderKpis() {
  const total = DIAS.length;
  const diasIdeais = contarPorFaixa('adequado');
  document.getElementById('kpiDiasIdeais').textContent = `${diasIdeais}/${total} dias`;
}

function renderEixoY() {
  const eixoY = document.getElementById('eixoY');
  const fragment = document.createDocumentFragment();

  for (let valor = 0; valor <= MAX_EIXO; valor += PASSO_EIXO) {
    const tick = document.createElement('span');
    tick.className = 'grafico__tick-y';
    tick.style.setProperty('--posicao', `${(valor / MAX_EIXO) * 100}`);
    tick.textContent = valor;
    fragment.appendChild(tick);
  }

  eixoY.appendChild(fragment);
}

function renderGradeHorizontal() {
  const grade = document.getElementById('grade');
  const fragment = document.createDocumentFragment();

  for (let valor = 0; valor <= MAX_EIXO; valor += PASSO_EIXO) {
    const linha = document.createElement('span');
    linha.className = valor === 0 ? 'grafico__linha grafico__linha--base' : 'grafico__linha';
    linha.style.setProperty('--posicao', `${(valor / MAX_EIXO) * 100}`);
    fragment.appendChild(linha);
  }

  grade.appendChild(fragment);
}

function renderGradeVertical() {
  const grade = document.getElementById('grade');
  const fragment = document.createDocumentFragment();
  const total = DIAS.length;

  for (let indice = 0; indice <= total; indice += 1) {
    const coluna = document.createElement('span');
    coluna.className = 'grafico__coluna';
    coluna.style.setProperty('--posicao', `${(indice / total) * 100}`);
    fragment.appendChild(coluna);
  }

  grade.appendChild(fragment);
}

function renderBarras() {
  const container = document.getElementById('barras');
  const fragment = document.createDocumentFragment();

  container.style.setProperty('--max', `${MAX_EIXO}`);

  DIAS.forEach((dia) => {
    const slot = document.createElement('div');
    slot.className = 'grafico__slot';

    const barra = document.createElement('div');
    barra.className = `barra barra--${classificar(dia.valor)}`;
    barra.style.setProperty('--valor', `${dia.valor}`);

    slot.appendChild(barra);
    fragment.appendChild(slot);
  });

  container.setAttribute('aria-label', DIAS.map((dia) => `${dia.data}: ${dia.valor} DLI`).join('; '));
  container.appendChild(fragment);
}

function renderEixoX() {
  const eixoX = document.getElementById('eixoX');
  const fragment = document.createDocumentFragment();

  DIAS.forEach((dia) => {
    const tick = document.createElement('span');
    tick.className = 'grafico__tick-x';
    tick.textContent = dia.data;
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
  renderKpis();
  renderEixoY();
  renderGradeHorizontal();
  renderGradeVertical();
  renderBarras();
  renderEixoX();
  initMenuEstufas();
}

init();