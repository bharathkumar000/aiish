const express = require('express');
const router = express.Router();
const { getProgress, unlockProgress, resetProgress } = require('../controllers/progressController');

router.get('/', getProgress);
router.post('/unlock', unlockProgress);
router.post('/reset', resetProgress);

module.exports = router;
