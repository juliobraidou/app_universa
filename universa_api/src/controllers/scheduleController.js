const { z } = require('zod');
const scheduleService = require('../services/scheduleService');

const dateSchema = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/, 'Data invalida. Use YYYY-MM-DD');

async function listByDate(req, res, next) {
  try {
    const parsed = dateSchema.safeParse(req.query.date);
    if (!parsed.success) {
      return res.status(400).json({ message: 'Parametro date obrigatorio (YYYY-MM-DD)' });
    }
    const data = await scheduleService.getScheduleByDate(
      req.studentId,
      parsed.data,
    );
    res.json(data);
  } catch (err) {
    next(err);
  }
}

async function today(req, res, next) {
  try {
    const data = await scheduleService.getTodaySchedule(req.studentId);
    res.json(data);
  } catch (err) {
    next(err);
  }
}

module.exports = { listByDate, today };
