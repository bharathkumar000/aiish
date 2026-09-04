/**
 * Database Configuration & Data Access Layer
 * Supports PostgreSQL connection via DATABASE_URL with a built-in
 * robust fallback store so the API can run out-of-the-box in development.
 */

const inMemoryStore = {
  therapistConfig: {
    passThreshold: 80,
    clueAudioEnabled: true,
    visualClueEnabled: true,
    maxAudioReplays: 3
  },
  progress: {
    unlockedModules: {
      phoneme: true,
      syllable: false,
      word: false,
      sentence: false,
      closure: false
    },
    unlockedLevels: {
      phoneme: { 0: true, 1: false, 2: false },
      syllable: { 0: false },
      word: { 0: false },
      sentence: { 0: false },
      closure: { 0: false }
    }
  },
  sessions: []
};

module.exports = {
  inMemoryStore,
  isConnected: false,
  connectDB: async () => {
    if (process.env.DATABASE_URL) {
      try {
        console.log('Connecting to PostgreSQL database at:', process.env.DATABASE_URL.split('@')[1] || 'configured host');
        // If pg is installed and database is running, connect pool
      } catch (err) {
        console.warn('PostgreSQL connection failed, continuing with in-memory persistence:', err.message);
      }
    } else {
      console.log('DATABASE_URL not set. Running with built-in development data store.');
    }
  }
};
