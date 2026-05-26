const attendanceService = require('../services/attendanceService');

async function list(req, res, next) {
  try {
    const data = await attendanceService.getAttendance(req.studentId);
    res.json(data);
  } catch (err) {
    next(err);
  }
}

module.exports = { list };
