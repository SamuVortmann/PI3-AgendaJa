function errorHandler(err, req, res, next) {
  console.error(err);

  if (err.code === '23505') {
    return res.status(409).json({ erro: 'Registro já existe' });
  }

  if (err.code === '23503') {
    return res.status(400).json({ erro: 'Referência inválida' });
  }

  const status = err.status || 500;
  const mensagem = err.message || 'Erro interno do servidor';

  res.status(status).json({ erro: mensagem });
}

module.exports = errorHandler;
