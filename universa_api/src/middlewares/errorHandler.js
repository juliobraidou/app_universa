function errorHandler(err, req, res, next) {
  if (res.headersSent) {
    return next(err);
  }

  if (err.message === 'Origem nao permitida pelo CORS') {
    return res.status(403).json({ message: err.message });
  }

  const status = err.status || 500;
  const message = err.message || 'Erro interno do servidor';

  if (process.env.NODE_ENV !== 'production') {
    console.error(err);
  }

  res.status(status).json({ message });
}

module.exports = errorHandler;
