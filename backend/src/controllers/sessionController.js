const { inMemoryStore } = require('../config/db');

// @desc    Log a completed training session
// @route   POST /api/sessions
exports.createSession = async (req, res, next) => {
  try {
    const { moduleId, levelId, score, total, trials, passed, childId = 'child_default' } = req.body;

    if (!moduleId || levelId === undefined || score === undefined) {
      return res.status(400).json({
        success: false,
        message: 'Missing required session fields: moduleId, levelId, score'
      });
    }

    const newSession = {
      id: `session_${Date.now()}`,
      childId,
      moduleId,
      levelId,
      score,
      total: total || 3,
      percentage: total ? Math.round((score / total) * 100) : 0,
      passed: Boolean(passed),
      trials: trials || [],
      createdAt: new Date().toISOString()
    };

    inMemoryStore.sessions.unshift(newSession);

    res.status(201).json({
      success: true,
      message: 'Training session recorded successfully',
      data: newSession
    });
  } catch (error) {
    next(error);
  }
};

// @desc    Get all session history
// @route   GET /api/sessions
exports.getSessions = async (req, res, next) => {
  try {
    const { childId, moduleId } = req.query;
    let results = inMemoryStore.sessions;

    if (childId) {
      results = results.filter(s => s.childId === childId);
    }
    if (moduleId) {
      results = results.filter(s => s.moduleId === moduleId);
    }

    res.json({
      success: true,
      count: results.length,
      data: results
    });
  } catch (error) {
    next(error);
  }
};
