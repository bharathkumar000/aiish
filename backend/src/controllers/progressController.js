const { inMemoryStore } = require('../config/db');

// @desc    Get child unlocked modules & levels
// @route   GET /api/progress
exports.getProgress = async (req, res, next) => {
  try {
    res.json({
      success: true,
      data: inMemoryStore.progress
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Unlock a module or level
// @route   POST /api/progress/unlock
exports.unlockProgress = async (req, res, next) => {
  try {
    const { moduleId, levelId } = req.body;

    if (!moduleId) {
      return res.status(400).json({ success: false, message: 'moduleId is required' });
    }

    inMemoryStore.progress.unlockedModules[moduleId] = true;

    if (levelId !== undefined) {
      if (!inMemoryStore.progress.unlockedLevels[moduleId]) {
        inMemoryStore.progress.unlockedLevels[moduleId] = {};
      }
      inMemoryStore.progress.unlockedLevels[moduleId][levelId] = true;
    }

    res.json({
      success: true,
      message: `Unlocked progress for ${moduleId} ${levelId !== undefined ? `level ${levelId}` : ''}`,
      data: inMemoryStore.progress
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Reset progress back to default
// @route   POST /api/progress/reset
exports.resetProgress = async (req, res, next) => {
  try {
    inMemoryStore.progress = {
      unlockedModules: { phoneme: true, syllable: false, word: false, sentence: false, closure: false },
      unlockedLevels: {
        phoneme: { 0: true, 1: false, 2: false },
        syllable: { 0: false },
        word: { 0: false },
        sentence: { 0: false },
        closure: { 0: false }
      }
    };
    inMemoryStore.sessions = [];

    res.json({
      success: true,
      message: 'All progress and session records reset successfully',
      data: inMemoryStore.progress
    });
  } catch (error) {
    next(error);
  }
};
