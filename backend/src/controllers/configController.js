const { inMemoryStore } = require('../config/db');

// @desc    Get therapist configuration
// @route   GET /api/config
exports.getConfig = async (req, res, next) => {
  try {
    res.json({
      success: true,
      data: inMemoryStore.therapistConfig
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Update therapist configuration
// @route   POST /api/config
exports.updateConfig = async (req, res, next) => {
  try {
    const { passThreshold, clueAudioEnabled, visualClueEnabled, maxAudioReplays } = req.body;
    
    if (passThreshold !== undefined) {
      inMemoryStore.therapistConfig.passThreshold = Number(passThreshold);
    }
    if (clueAudioEnabled !== undefined) {
      inMemoryStore.therapistConfig.clueAudioEnabled = Boolean(clueAudioEnabled);
    }
    if (visualClueEnabled !== undefined) {
      inMemoryStore.therapistConfig.visualClueEnabled = Boolean(visualClueEnabled);
    }
    if (maxAudioReplays !== undefined) {
      inMemoryStore.therapistConfig.maxAudioReplays = Number(maxAudioReplays);
    }

    res.json({
      success: true,
      message: 'Therapist configuration updated successfully',
      data: inMemoryStore.therapistConfig
    });
  } catch (error) {
    next(error);
  }
};
