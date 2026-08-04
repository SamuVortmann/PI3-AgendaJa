-- Agenda Já - Schema do banco de dados PostgreSQL

CREATE TYPE perfil_usuario AS ENUM ('cliente', 'empresa', 'admin');
CREATE TYPE status_agendamento AS ENUM ('pendente', 'confirmado', 'cancelado');

CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  senha_hash VARCHAR(255) NOT NULL,
  telefone VARCHAR(20),
  perfil perfil_usuario NOT NULL DEFAULT 'cliente',
  criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE empresas (
  id SERIAL PRIMARY KEY,
  usuario_id INTEGER UNIQUE NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
  nome VARCHAR(255) NOT NULL,
  cnpj VARCHAR(18) UNIQUE,
  endereco TEXT NOT NULL,
  telefone VARCHAR(20) NOT NULL,
  dias_funcionamento INTEGER[] NOT NULL DEFAULT ARRAY[1, 2, 3, 4, 5],
  hora_abertura TIME NOT NULL DEFAULT '08:00',
  hora_fechamento TIME NOT NULL DEFAULT '18:00',
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (hora_fechamento > hora_abertura)
);

CREATE TABLE servicos (
  id SERIAL PRIMARY KEY,
  empresa_id INTEGER NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
  nome VARCHAR(255) NOT NULL,
  descricao TEXT,
  duracao_minutos INTEGER NOT NULL CHECK (duracao_minutos > 0),
  preco DECIMAL(10, 2) NOT NULL CHECK (preco >= 0),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE profissionais (
  id SERIAL PRIMARY KEY,
  empresa_id INTEGER NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
  nome VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  telefone VARCHAR(20),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE profissional_servico (
  profissional_id INTEGER NOT NULL REFERENCES profissionais(id) ON DELETE CASCADE,
  servico_id INTEGER NOT NULL REFERENCES servicos(id) ON DELETE CASCADE,
  PRIMARY KEY (profissional_id, servico_id)
);

CREATE TABLE disponibilidades (
  id SERIAL PRIMARY KEY,
  profissional_id INTEGER NOT NULL REFERENCES profissionais(id) ON DELETE CASCADE,
  dia_semana INTEGER NOT NULL CHECK (dia_semana BETWEEN 0 AND 6),
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,
  CHECK (hora_fim > hora_inicio),
  UNIQUE (profissional_id, dia_semana, hora_inicio, hora_fim)
);

CREATE TABLE agendamentos (
  id SERIAL PRIMARY KEY,
  empresa_id INTEGER NOT NULL REFERENCES empresas(id),
  cliente_id INTEGER NOT NULL REFERENCES usuarios(id),
  profissional_id INTEGER NOT NULL REFERENCES profissionais(id),
  servico_id INTEGER NOT NULL REFERENCES servicos(id),
  data_hora_inicio TIMESTAMPTZ NOT NULL,
  data_hora_fim TIMESTAMPTZ NOT NULL,
  status status_agendamento NOT NULL DEFAULT 'pendente',
  lembrete_enviado BOOLEAN NOT NULL DEFAULT FALSE,
  criado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (data_hora_fim > data_hora_inicio)
);

CREATE INDEX idx_agendamentos_profissional ON agendamentos(profissional_id, data_hora_inicio);
CREATE INDEX idx_agendamentos_empresa ON agendamentos(empresa_id, data_hora_inicio);
CREATE INDEX idx_agendamentos_cliente ON agendamentos(cliente_id);
CREATE INDEX idx_agendamentos_status ON agendamentos(status);
CREATE INDEX idx_agendamentos_lembrete ON agendamentos(lembrete_enviado, data_hora_inicio);
