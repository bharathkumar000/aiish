"use client";
import React, { createContext, useContext, useState, useEffect } from 'react';

const AppContext = createContext();

const defaultState = {
  // Linear progression: 'phoneme' is unlocked by default
  unlockedModules: {
    phoneme: true,
    syllable: false,
    word: false,
    sentence: false,
    closure: false,
  },
  unlockedLevels: {
    phoneme: { 0: true, 1: false, 2: false },
    syllable: { 0: false },
    word: { 0: false },
    sentence: { 0: false },
    closure: { 0: false },
  },
  therapistConfig: {
    passThreshold: 80, // Default 80% to pass
  },
  sessionLogs: []
};

export const AppProvider = ({ children }) => {
  const [appState, setAppState] = useState(() => {
    if (typeof window !== 'undefined') {
      const saved = localStorage.getItem('aiish_app_state');
      return saved ? JSON.parse(saved) : defaultState;
    }
    return defaultState;
  });

  useEffect(() => {
    localStorage.setItem('aiish_app_state', JSON.stringify(appState));
  }, [appState]);

  const unlockModule = (moduleId) => {
    setAppState(prev => ({
      ...prev,
      unlockedModules: { ...prev.unlockedModules, [moduleId]: true }
    }));
  };

  const unlockLevel = (moduleId, levelId) => {
    setAppState(prev => ({
      ...prev,
      unlockedLevels: {
        ...prev.unlockedLevels,
        [moduleId]: { ...prev.unlockedLevels[moduleId], [levelId]: true }
      }
    }));
  };

  const addSessionLog = (log) => {
    setAppState(prev => ({
      ...prev,
      sessionLogs: [...prev.sessionLogs, { ...log, timestamp: new Date().toISOString() }]
    }));
  };

  const updateConfig = (newConfig) => {
    setAppState(prev => ({
      ...prev,
      therapistConfig: { ...prev.therapistConfig, ...newConfig }
    }));
  };
  
  const resetProgress = () => {
    setAppState(defaultState);
  };

  return (
    <AppContext.Provider value={{
      ...appState,
      unlockModule,
      unlockLevel,
      addSessionLog,
      updateConfig,
      resetProgress
    }}>
      {children}
    </AppContext.Provider>
  );
};

export const useAppContext = () => useContext(AppContext);
