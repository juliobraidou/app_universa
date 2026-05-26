const cors = require('cors');

function normalizeOrigin(origin) {
  if (!origin) return origin;
  return origin.endsWith('/') ? origin.slice(0, -1) : origin;
}

function isLocalDevOrigin(origin) {
  try {
    const { protocol, hostname } = new URL(origin);
    return protocol === 'http:' && (hostname === 'localhost' || hostname === '127.0.0.1');
  } catch {
    return false;
  }
}

function buildCorsOptions() {
  const fromEnv = process.env.CORS_ORIGINS;
  const allowedOrigins = fromEnv
    ? fromEnv.split(',').map((o) => normalizeOrigin(o.trim())).filter(Boolean)
    : [
        'http://localhost:3000',
        'http://127.0.0.1:3000',
        'http://localhost:8080',
        'http://127.0.0.1:8080',
        'http://localhost:5000',
        'http://127.0.0.1:5000',
      ];

  const isProduction = process.env.NODE_ENV === 'production';

  return {
    origin(origin, callback) {
      if (!origin) {
        return callback(null, true);
      }

      const normalized = normalizeOrigin(origin);

      if (allowedOrigins.includes(normalized)) {
        return callback(null, true);
      }

      if (!isProduction && isLocalDevOrigin(normalized)) {
        return callback(null, true);
      }

      return callback(new Error('Origem nao permitida pelo CORS'));
    },
    credentials: true,
  };
}

module.exports = cors(buildCorsOptions());
