const studentService = require('../services/studentService');

async function getMe(req, res, next) {
  try {
    const data = await studentService.getMe(req.studentId);
    res.json(data);
  } catch (err) {
    next(err);
  }
}

async function getSummary(req, res, next) {
  try {
    const data = await studentService.getSummary(req.studentId);
    res.json(data);
  } catch (err) {
    next(err);
  }
}

module.exports = { getMe, getSummary };
