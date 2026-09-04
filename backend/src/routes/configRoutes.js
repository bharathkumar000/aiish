const express = require('express');
const router = express.Router();
const { getConfig, updateConfig } = require('../controllers/configController');

router.route('/')
  .get(getConfig)
  .post(updateConfig);

module.exports = router;
