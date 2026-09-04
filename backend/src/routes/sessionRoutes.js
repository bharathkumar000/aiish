const express = require('express');
const router = express.Router();
const { createSession, getSessions } = require('../controllers/sessionController');

router.route('/')
  .get(getSessions)
  .post(createSession);

module.exports = router;
