function formatTime(timeValue) {
  if (!timeValue) return '';
  const str = String(timeValue);
  return str.slice(0, 5);
}

function formatDuration(minutes) {
  const hours = minutes / 60;
  if (hours === Math.floor(hours)) {
    return `${hours}h`;
  }
  return `${minutes}min`;
}

function roundOne(value) {
  return Math.round(Number(value) * 10) / 10;
}

function getFirstName(fullName) {
  return fullName.split(' ')[0] || fullName;
}

function getAvatarInitials(fullName) {
  const parts = fullName.trim().split(/\s+/);
  if (parts.length === 1) {
    return parts[0].slice(0, 2).toUpperCase();
  }
  return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
}

function getSemesterLabel(period, entryYear) {
  return `${period} SEMESTRE • ${entryYear}`;
}

function getAttendanceStatus(percent) {
  if (percent >= 75) return 'Excelente';
  if (percent >= 60) return 'Boa';
  return 'Ruim';
}

module.exports = {
  formatTime,
  formatDuration,
  roundOne,
  getFirstName,
  getAvatarInitials,
  getSemesterLabel,
  getAttendanceStatus,
};
