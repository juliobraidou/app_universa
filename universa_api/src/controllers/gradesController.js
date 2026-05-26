const gradesService = require('../services/gradesService');

async function list(req, res, next) {
  try {
    const data = await gradesService.getGrades(req.studentId);
    res.json(data);
  } catch (err) {
    next(err);
  }
}

module.exports = { list };
