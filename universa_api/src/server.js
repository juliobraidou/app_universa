require('dotenv').config();
const app = require('./app');

const port = Number(process.env.PORT || 3000);

app.listen(port, () => {
  console.log(`Universa API rodando em http://localhost:${port}`);
  console.log(`Health: http://localhost:${port}/health`);
});
