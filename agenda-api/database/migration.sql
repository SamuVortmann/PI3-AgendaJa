-- Atualiza instalacoes anteriores para o modelo com contas de empresa.
ALTER TYPE perfil_usuario ADD VALUE IF NOT EXISTS 'empresa';

CREATE TABLE IF NOT EXISTS empresas (
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

-- Preserva os dados legados associando-os a empresa do primeiro administrador.
INSERT INTO empresas (usuario_id, nome, endereco, telefone)
SELECT u.id, COALESCE(u.nome, 'Empresa principal'), 'Endereço não informado', COALESCE(u.telefone, 'Não informado')
FROM usuarios u
WHERE u.perfil = 'admin'
  AND NOT EXISTS (SELECT 1 FROM empresas e WHERE e.usuario_id = u.id)
ORDER BY u.id
LIMIT 1;

ALTER TABLE servicos ADD COLUMN IF NOT EXISTS empresa_id INTEGER REFERENCES empresas(id) ON DELETE CASCADE;
ALTER TABLE profissionais ADD COLUMN IF NOT EXISTS empresa_id INTEGER REFERENCES empresas(id) ON DELETE CASCADE;
ALTER TABLE agendamentos ADD COLUMN IF NOT EXISTS empresa_id INTEGER REFERENCES empresas(id);
ALTER TABLE agendamentos ADD COLUMN IF NOT EXISTS reagendado_em TIMESTAMPTZ;

UPDATE servicos SET empresa_id = (SELECT MIN(id) FROM empresas) WHERE empresa_id IS NULL;
UPDATE profissionais SET empresa_id = (SELECT MIN(id) FROM empresas) WHERE empresa_id IS NULL;
UPDATE agendamentos a
SET empresa_id = COALESCE(s.empresa_id, p.empresa_id, (SELECT MIN(id) FROM empresas))
FROM servicos s, profissionais p
WHERE a.servico_id = s.id
  AND a.profissional_id = p.id
  AND a.empresa_id IS NULL;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM servicos WHERE empresa_id IS NULL)
     OR EXISTS (SELECT 1 FROM profissionais WHERE empresa_id IS NULL)
     OR EXISTS (SELECT 1 FROM agendamentos WHERE empresa_id IS NULL) THEN
    RAISE EXCEPTION 'Não foi possível associar os dados existentes a uma empresa. Cadastre um administrador primeiro.';
  END IF;
END $$;

ALTER TABLE servicos ALTER COLUMN empresa_id SET NOT NULL;
ALTER TABLE profissionais ALTER COLUMN empresa_id SET NOT NULL;
ALTER TABLE agendamentos ALTER COLUMN empresa_id SET NOT NULL;

CREATE INDEX IF NOT EXISTS idx_agendamentos_empresa ON agendamentos(empresa_id, data_hora_inicio);
